#include "column_reader.hpp"
#include "utf8proc_wrapper.hpp"

#include <iostream>

namespace duckdb {

ColumnReader::~ColumnReader() {
}

void ColumnReader::Read(uint64_t num_values, parquet_filter_t &filter, Vector &result) {
	auto trans = (DuckdbFileTransport *)protocol.getTransport().get();
	trans->SetLocation(chunk_read_offset);

	idx_t to_read = num_values;
	idx_t result_offset = 0;

	while (to_read > 0) {

		while (rows_available == 0) {
			dict_decoder.reset();
			defined_decoder.reset();
			block.reset();

			// TODO make this a function, read page header, buffers and unpack if req.
			parquet::format::PageHeader page_hdr;
			page_hdr.read(&protocol);

			block = make_shared<ResizeableBuffer>(page_hdr.compressed_page_size);
			trans->read((uint8_t *)block->ptr, page_hdr.compressed_page_size);

			//			page_hdr.printTo(std::cout);
			//			std::cout << '\n';

			switch (chunk.meta_data.codec) {
			case CompressionCodec::UNCOMPRESSED:
				break;
			case CompressionCodec::GZIP: {
				MiniZStream s;

				auto unpacked_block = make_shared<ResizeableBuffer>(page_hdr.uncompressed_page_size);
				s.Decompress((const char *)block->ptr, page_hdr.compressed_page_size, (char *)unpacked_block->ptr,
				             page_hdr.uncompressed_page_size);
				block = move(unpacked_block);

				break;
			}
			default:
				D_ASSERT(0);
				break;
			}

			switch (page_hdr.type) {
			case PageType::DATA_PAGE: {
				rows_available = page_hdr.data_page_header.num_values;

				if (can_have_nulls) {
					uint32_t def_length = block->read<uint32_t>();
					block->available(def_length);
					defined_decoder = make_unique<RleBpDecoder>((const uint8_t *)block->ptr, def_length, 1);
					block->inc(def_length);
				}

				switch (page_hdr.data_page_header.encoding) {
				case Encoding::RLE_DICTIONARY:
				case Encoding::PLAIN_DICTIONARY: {
					auto enc_length = block->read<uint8_t>();
					// TODO fix len, its no longer accurate!
					dict_decoder = make_unique<RleBpDecoder>((const uint8_t *)block->ptr, block->len, enc_length);

					break;
				}
				case Encoding::PLAIN:
					// nothing here, see below
					break;

				default:
					D_ASSERT(0);
					break;
				}

				break;
			}
			case PageType::DICTIONARY_PAGE:
				// TODO add some checks

				Dictionary(move(block), page_hdr.dictionary_page_header.num_values);
				block.reset(); // make sure nobody below reads this
				break;
			default:
				D_ASSERT(0);
				break;
			}

			// TODO abort when running out of column
		}

		D_ASSERT(block);

		auto read_now = MinValue<idx_t>(to_read, rows_available);

		if (defined_decoder) {
			D_ASSERT(can_have_nulls);
			defined_buffer.resize(sizeof(uint8_t) * read_now);
			defined_decoder->GetBatch<uint8_t>(defined_buffer.ptr, read_now);
		}

		if (dict_decoder) {
			offset_buffer.resize(sizeof(uint32_t) * read_now);
			dict_decoder->GetBatch<uint32_t>(offset_buffer.ptr, read_now);
			DictReference(result);
			Offsets((uint32_t *)offset_buffer.ptr, (uint8_t *)defined_buffer.ptr, read_now, filter, result_offset,
			        result);
		} else {
			PlainReference(block, result);
			Plain(block, (uint8_t *)defined_buffer.ptr, read_now, filter, result_offset, result);
		}
		result_offset += read_now;
		rows_available -= read_now;
		to_read -= read_now;
	}
	chunk_read_offset = trans->GetLocation();
}

void ColumnReader::VerifyString(LogicalTypeId id, const char *str_data, idx_t str_len) {
	if (id != LogicalTypeId::VARCHAR) {
		return;
	}
	// verify if a string is actually UTF8, and if there are no null bytes in the middle of the string
	// technically Parquet should guarantee this, but reality is often disappointing
	auto utf_type = Utf8Proc::Analyze(str_data, str_len);
	if (utf_type == UnicodeType::INVALID) {
		throw InternalException("Invalid string encoding found in Parquet file: value is not valid UTF8!");
	}
}

unique_ptr<BaseStatistics> StringColumnReader::GetStatistics() {
	if (!chunk.__isset.meta_data || !chunk.meta_data.__isset.statistics) {
		return nullptr;
	}
	auto &parquet_stats = chunk.meta_data.statistics;

	auto string_stats = make_unique<StringStatistics>(type);
	if (parquet_stats.__isset.min) {
		memcpy(string_stats->min, (data_ptr_t)parquet_stats.min.data(),
		       MinValue<idx_t>(parquet_stats.min.size(), StringStatistics::MAX_STRING_MINMAX_SIZE));
	} else if (parquet_stats.__isset.min_value) {
		memcpy(string_stats->min, (data_ptr_t)parquet_stats.min_value.data(),
		       MinValue<idx_t>(parquet_stats.min_value.size(), StringStatistics::MAX_STRING_MINMAX_SIZE));
	} else {
		return nullptr;
	}
	if (parquet_stats.__isset.max) {
		memcpy(string_stats->max, (data_ptr_t)parquet_stats.max.data(),
		       MinValue<idx_t>(parquet_stats.max.size(), StringStatistics::MAX_STRING_MINMAX_SIZE));
	} else if (parquet_stats.__isset.max_value) {
		memcpy(string_stats->max, (data_ptr_t)parquet_stats.max_value.data(),
		       MinValue<idx_t>(parquet_stats.max_value.size(), StringStatistics::MAX_STRING_MINMAX_SIZE));
	} else {
		return nullptr;
	}

	string_stats->has_unicode = true; // we dont know better
	return move(string_stats);
}

void StringColumnReader::Dictionary(shared_ptr<ByteBuffer> data, idx_t num_entries) {
	dict = move(data);
	dict_strings = unique_ptr<string_t[]>(new string_t[num_entries]);
	for (idx_t dict_idx = 0; dict_idx < num_entries; dict_idx++) {
		// TODO we can apply filters here already and put a marker into dict
		uint32_t str_len = dict->read<uint32_t>();
		dict->available(str_len);

		VerifyString(type.id(), dict->ptr, str_len);
		dict_strings[dict_idx] = string_t(dict->ptr, str_len);
		dict->inc(str_len);
	}
}

class ParquetStringVectorBuffer : public VectorBuffer {
public:
	ParquetStringVectorBuffer(shared_ptr<ByteBuffer> buffer_p)
	    : VectorBuffer(VectorBufferType::OPAQUE_BUFFER), buffer(move(buffer_p)) {
	}

private:
	shared_ptr<ByteBuffer> buffer;
};

void StringColumnReader::DictReference(Vector &result) {
	StringVector::AddBuffer(result, make_unique<ParquetStringVectorBuffer>(dict));
}
void StringColumnReader::PlainReference(shared_ptr<ByteBuffer> plain_data, Vector &result) {
	StringVector::AddBuffer(result, make_unique<ParquetStringVectorBuffer>(move(plain_data)));
}

string_t StringColumnReader::DictRead(uint32_t &offset, Vector &result) {
	return dict_strings[offset];
};

string_t StringColumnReader::PlainRead(ByteBuffer &plain_data, Vector &result) {
	uint32_t str_len = plain_data.read<uint32_t>();
	plain_data.available(str_len);
    VerifyString(type.id(), plain_data.ptr, str_len);
    auto ret_str = string_t(plain_data.ptr, str_len);
	plain_data.inc(str_len);
	return ret_str;
};

void StringColumnReader::PlainSkip(ByteBuffer &plain_data) {
	uint32_t str_len = plain_data.read<uint32_t>();
	plain_data.available(str_len);
	plain_data.inc(str_len);
}

void StringColumnReader::Skip(idx_t num_values) {
	D_ASSERT(0);
}

} // namespace duckdb

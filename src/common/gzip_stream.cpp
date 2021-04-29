#include "duckdb/common/gzip_stream.hpp"

#include "duckdb/common/exception.hpp"
#include "duckdb/common/fstream_util.hpp"

#include "miniz.hpp"

#include "duckdb/common/limits.hpp"

namespace duckdb {

/*

  0      2 bytes  magic header  0x1f, 0x8b (\037 \213)
  2      1 byte   compression method
                     0: store (copied)
                     1: compress
                     2: pack
                     3: lzh
                     4..7: reserved
                     8: deflate
  3      1 byte   flags
                     bit 0 set: file probably ascii text
                     bit 1 set: continuation of multi-part gzip file, part number present
                     bit 2 set: extra field present
                     bit 3 set: original file name present
                     bit 4 set: file comment present
                     bit 5 set: file is encrypted, encryption header present
                     bit 6,7:   reserved
  4      4 bytes  file modification time in Unix format
  8      1 byte   extra flags (depend on compression method)
  9      1 byte   OS type
[
         2 bytes  optional part number (second part=1)
]?
[
         2 bytes  optional extra field length (e)
        (e)bytes  optional extra field
]?
[
           bytes  optional original file name, zero terminated
]?
[
           bytes  optional file comment, zero terminated
]?
[
        12 bytes  optional encryption header
]?
           bytes  compressed data
         4 bytes  crc32
         4 bytes  uncompressed input size modulo 2^32

 */

static idx_t GZipConsumeString(fstream &input) {
	idx_t size = 1; // terminator
	while (input.get() != '\0') {
		size++;
	}
	return size;
}

static constexpr const uint8_t GZIP_COMPRESSION_DEFLATE = 0x08;

static constexpr const uint8_t GZIP_FLAG_ASCII = 0x1;
static constexpr const uint8_t GZIP_FLAG_MULTIPART = 0x2;
static constexpr const uint8_t GZIP_FLAG_EXTRA = 0x4;
static constexpr const uint8_t GZIP_FLAG_NAME = 0x8;
static constexpr const uint8_t GZIP_FLAG_COMMENT = 0x10;
static constexpr const uint8_t GZIP_FLAG_ENCRYPT = 0x20;

static constexpr const uint8_t GZIP_HEADER_MINSIZE = 10;

static constexpr const unsigned char GZIP_FLAG_UNSUPPORTED =
    GZIP_FLAG_ASCII | GZIP_FLAG_MULTIPART | GZIP_FLAG_EXTRA | GZIP_FLAG_COMMENT | GZIP_FLAG_ENCRYPT;

void GzipStreamBuf::Initialize() {
	if (is_initialized) {
		return;
	}
	D_ASSERT(BUFFER_SIZE >= 3); // found to work fine with 3
	uint8_t gzip_hdr[10];
	data_start = GZIP_HEADER_MINSIZE;

	in_buff = new data_t[BUFFER_SIZE];
	in_buff_start = in_buff;
	in_buff_end = in_buff;
	out_buff = new data_t[BUFFER_SIZE];

	mz_stream_ptr = new duckdb_miniz::mz_stream();
	// TODO use custom alloc/free methods in miniz to throw exceptions on OOM

	FstreamUtil::OpenFile(filename, input, ios::in | ios::binary);

	input.read((char *)gzip_hdr, GZIP_HEADER_MINSIZE);
	if (!input) {
		throw Exception("Input is not a GZIP stream");
	}
	if (gzip_hdr[0] != 0x1F || gzip_hdr[1] != 0x8B) { // magic header
		throw Exception("Input is not a GZIP stream");
	}
	if (gzip_hdr[2] != GZIP_COMPRESSION_DEFLATE) { // compression method
		throw Exception("Unsupported GZIP compression method");
	}
	if (gzip_hdr[3] & GZIP_FLAG_UNSUPPORTED) {
		throw Exception("Unsupported GZIP archive");
	}

	if (gzip_hdr[3] & GZIP_FLAG_NAME) {
		input.seekg(data_start, input.beg);
		data_start += GZipConsumeString(input);
	}
	input.seekg(data_start, input.beg);
	// stream is now set to beginning of payload data

	auto ret = duckdb_miniz::mz_inflateInit2((duckdb_miniz::mz_streamp)mz_stream_ptr, -MZ_DEFAULT_WINDOW_BITS);
	if (ret != duckdb_miniz::MZ_OK) {
		throw Exception("Failed to initialize miniz");
	}
	// initialize eback, gptr, egptr
	setg((char *)out_buff, (char *)out_buff, (char *)out_buff);
	is_initialized = true;
}

std::streambuf::int_type GzipStreamBuf::underflow() {
	if (!is_initialized) {
		Initialize();
	}

	// adapted from https://github.com/mateidavid/zstr
	auto zstrm_p = (duckdb_miniz::mz_streamp)mz_stream_ptr;
	if (!zstrm_p) {
		return traits_type::eof();
	}

	if (gptr() == egptr()) {
		// pointers for free region in output buffer
		auto out_buff_free_start = out_buff;
		do {
			D_ASSERT(in_buff_start <= in_buff_end);
			D_ASSERT(in_buff_end <= in_buff_start + BUFFER_SIZE);

			// read more input if none available
			if (in_buff_start == in_buff_end) {
				// empty input buffer: refill from the start
				in_buff_start = in_buff;
				std::streamsize sz = input.rdbuf()->sgetn((char *)in_buff, BUFFER_SIZE);
				if (sz == 0) {
					break; // end of input
				}
				in_buff_end = in_buff + sz;
			}

			// actually decompress
			D_ASSERT(zstrm_p);
			zstrm_p->next_in = (data_ptr_t)in_buff_start;
			D_ASSERT(in_buff_end - in_buff_start < NumericLimits<int32_t>::Maximum());
			zstrm_p->avail_in = (uint32_t)(in_buff_end - in_buff_start);
			zstrm_p->next_out = (data_ptr_t)out_buff_free_start;
			D_ASSERT((out_buff + BUFFER_SIZE) - out_buff_free_start < NumericLimits<int32_t>::Maximum());
			zstrm_p->avail_out = (uint32_t)((out_buff + BUFFER_SIZE) - out_buff_free_start);
			auto ret = duckdb_miniz::mz_inflate(zstrm_p, duckdb_miniz::MZ_NO_FLUSH);
			if (ret != duckdb_miniz::MZ_OK && ret != duckdb_miniz::MZ_STREAM_END) {
				throw Exception(duckdb_miniz::mz_error(ret));
			}
			// update pointers following inflate()
			in_buff_start = (data_ptr_t)zstrm_p->next_in;
			in_buff_end = in_buff_start + zstrm_p->avail_in;
			out_buff_free_start = (data_ptr_t)zstrm_p->next_out;
			D_ASSERT(out_buff_free_start + zstrm_p->avail_out == out_buff + BUFFER_SIZE);
			// if stream ended, deallocate inflator
			if (ret == duckdb_miniz::MZ_STREAM_END) {
				duckdb_miniz::mz_inflateEnd(zstrm_p);
				delete zstrm_p;
				mz_stream_ptr = nullptr;
				break;
			}

		} while (out_buff_free_start == out_buff);
		// 2 exit conditions:
		// - end of input: there might or might not be output available
		// - out_buff_free_start != out_buff: output available
		setg((char *)out_buff, (char *)out_buff, (char *)out_buff_free_start);
	}

	// ensure all those pointers point at something sane
	D_ASSERT(out_buff);
	D_ASSERT(gptr() <= egptr());
	D_ASSERT(eback() == (char *)out_buff);
	D_ASSERT(gptr() >= (char *)out_buff);
	D_ASSERT(gptr() <= (char *)out_buff + BUFFER_SIZE);
	D_ASSERT(egptr() >= (char *)out_buff);
	D_ASSERT(egptr() <= (char *)out_buff + BUFFER_SIZE);
	D_ASSERT(gptr() <= egptr());

	return this->gptr() == this->egptr() ? traits_type::eof() : traits_type::to_int_type(*this->gptr());
}

GzipStreamBuf::~GzipStreamBuf() {
	delete[] in_buff;
	delete[] out_buff;
	auto zstrm_p = (duckdb_miniz::mz_streamp)mz_stream_ptr;
	if (zstrm_p) {
		duckdb_miniz::mz_inflateEnd(zstrm_p);
	}
	delete zstrm_p;
}

} // namespace duckdb

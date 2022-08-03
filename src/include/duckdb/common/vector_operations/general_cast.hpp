//===----------------------------------------------------------------------===//
//                         DuckDB
//
// duckdb/common/vector_operations/general_cast.hpp
//
//
//===----------------------------------------------------------------------===//

#pragma once

#include "duckdb/common/operator/cast_operators.hpp"
#include "duckdb/common/string_util.hpp"

namespace duckdb {

struct HandleVectorCastError {
	template <class RESULT_TYPE>
	static RESULT_TYPE Operation(string error_message, ValidityMask &mask, idx_t idx, string *error_message_ptr,
	                             bool &all_converted) {
		HandleCastError::AssignError(error_message, error_message_ptr);
		all_converted = false;
		mask.SetInvalid(idx);
		return NullValue<RESULT_TYPE>();
	}
};

static string UnimplementedCastMessage(const LogicalType &source_type, const LogicalType &target_type) {
	return StringUtil::Format("Unimplemented type for cast (%s -> %s)", source_type.ToString(), target_type.ToString());
}

} // namespace duckdb

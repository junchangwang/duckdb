//===----------------------------------------------------------------------===//
//                         DuckDB
//
// icu-datepart.hpp
//
//
//===----------------------------------------------------------------------===//

#pragma once

#include "duckdb.hpp"

namespace duckdb {

void RegisterICUDatePartFunctions(DatabaseInstance &instance);

} // namespace duckdb

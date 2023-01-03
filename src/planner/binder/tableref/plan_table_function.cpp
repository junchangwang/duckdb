#include "duckdb/planner/binder.hpp"
#include "duckdb/planner/tableref/bound_table_function.hpp"

namespace duckdb {

unique_ptr<LogicalOperator> Binder::CreatePlan(BoundTableFunction &ref) {
	return Move(ref.get);
}

} // namespace duckdb

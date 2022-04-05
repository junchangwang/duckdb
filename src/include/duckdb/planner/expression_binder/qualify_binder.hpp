//===----------------------------------------------------------------------===//
//                         DuckDB
//
// duckdb/planner/expression_binder/qualify_binder.hpp
//
//
//===----------------------------------------------------------------------===//

#pragma once

#include "duckdb/planner/expression_binder/select_binder.hpp"
#include "duckdb/planner/expression_binder/column_alias_binder.hpp"

namespace duckdb {

//! The QUALIFY binder is responsible for binding an expression within the QUALIFY clause of a SQL statement
class QualifyBinder : public SelectBinder {
public:
	QualifyBinder(Binder &binder, ClientContext &context, BoundSelectNode &node,
	              const case_insensitive_map_t<idx_t> &alias_map, BoundGroupInformation &info);

protected:
	BindResult BindColumnRef(ColumnRefExpression &expr, idx_t depth, bool root_expression);
	BindResult BindExpression(unique_ptr<ParsedExpression> *expr_ptr, idx_t depth,
	                          bool root_expression = false) override;
protected:
	ColumnAliasProjectionBinder column_alias_projection_binder;
};

} // namespace duckdb

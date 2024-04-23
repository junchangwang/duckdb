#include "duckdb/main/relation/materialized_relation.hpp"
#include "duckdb/parser/query_node/select_node.hpp"
#include "duckdb/main/client_context.hpp"
#include "duckdb/planner/bound_statement.hpp"
#include "duckdb/planner/operator/logical_column_data_get.hpp"
#include "duckdb/parser/tableref/column_data_ref.hpp"

namespace duckdb {

MaterializedRelation::MaterializedRelation(const shared_ptr<ClientContext> &context, ColumnDataCollection &collection_p,
                                           vector<string> names, string alias_p)
    : Relation(context, RelationType::MATERIALIZED_RELATION), collection(collection_p), alias(std::move(alias_p)) {
	// create constant expressions for the values
	auto types = collection.Types();
	D_ASSERT(types.size() == names.size());

	QueryResult::DeduplicateColumns(names);
	for (idx_t i = 0; i < types.size(); i++) {
		auto &type = types[i];
		auto &name = names[i];
		auto column_definition = ColumnDefinition(name, type);
		columns.push_back(std::move(column_definition));
	}
}

unique_ptr<QueryNode> MaterializedRelation::GetQueryNode() {
	auto result = make_uniq<SelectNode>();
	result->select_list.push_back(make_uniq<StarExpression>());
	result->from_table = GetTableRef();
	return std::move(result);
}

unique_ptr<TableRef> MaterializedRelation::GetTableRef() {
	auto table_ref = make_uniq<ColumnDataRef>(collection);
	for (auto &col : columns) {
		table_ref->expected_names.push_back(col.Name());
	}
	table_ref->alias = GetAlias();
	return std::move(table_ref);
}

// BoundStatement MaterializedRelation::Bind(Binder &binder) {
//	auto return_types = collection.Types();
//	vector<string> names;

//	for (auto &col : columns) {
//		names.push_back(col.Name());
//	}
//	auto to_scan = make_uniq<ColumnDataCollection>(collection);
//	auto logical_get = make_uniq_base<LogicalOperator, LogicalColumnDataGet>(binder.GenerateTableIndex(), return_types,
// std::move(to_scan));
//	// FIXME: add Binding???

//	BoundStatement result;
//	result.plan = std::move(logical_get);
//	result.types = std::move(return_types);
//	result.names = std::move(names);
//	return result;
//}

string MaterializedRelation::GetAlias() {
	return alias;
}

const vector<ColumnDefinition> &MaterializedRelation::Columns() {
	return columns;
}

string MaterializedRelation::ToString(idx_t depth) {
	return collection.ToString();
}

} // namespace duckdb
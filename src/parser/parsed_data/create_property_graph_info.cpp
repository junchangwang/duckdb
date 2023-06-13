#include "duckdb/parser/parsed_data/create_property_graph_info.hpp"
#include "duckdb/catalog/catalog_entry/schema_catalog_entry.hpp"
#include "duckdb/catalog/catalog_entry/table_catalog_entry.hpp"
#include "duckdb/catalog/catalog.hpp"

namespace duckdb {

CreatePropertyGraphInfo::CreatePropertyGraphInfo() :
        ParsedExpression(ExpressionType::FUNCTION_REF, ExpressionClass::BOUND_EXPRESSION)) {
}


CreatePropertyGraphInfo::CreatePropertyGraphInfo(string property_graph_name) :
        ParsedExpression(ExpressionType::FUNCTION_REF, ExpressionClass::BOUND_EXPRESSION),
        property_graph_name(std::move(property_graph_name)) {
}

string CreatePropertyGraphInfo::ToString() const {
    string result;
    result += "CREATE PROPERTY GRAPH " + property_graph_name + "\n";
    result += "VERTEX TABLES (\n";
    for (idx_t i = 0; i < vertex_tables.size(); i++) {
        if (i != vertex_tables.size() - 1) {
            result += vertex_tables[i]->ToString() + ", ";
        } else {
            // Last element should be without a trailing , instead )
            result = vertex_tables[i]->ToString() + ")\n";
        }
    }

    result += "EDGE TABLES (\n";
    for (idx_t i = 0; i < edge_tables.size(); i++) {
        if (i != edge_tables.size() - 1) {
            result += edge_tables[i]->ToString() + ", ";
        } else {
            // Last element should be without a trailing , instead )
            result = edge_tables[i]->ToString() + ")\n";
        }
    }
    return result;
}

bool CreatePropertyGraphInfo::Equals(const BaseExpression *other_p) const {
    // TODO Check label map in this method as well
    if (!ParsedExpression::Equals(other_p)) {
        return false;
    }

    auto other = (CreatePropertyGraphInfo *)other_p;
    if (property_graph_name != other->property_graph_name) {
        return false;
    }

    if (vertex_tables.size() != other->vertex_tables.size()) {
        return false;
    }
    for (idx_t i = 0; i < vertex_tables.size(); i++) {
        if (vertex_tables[i]->Equals(other->vertex_tables[i].get())) {
            return false;
        }
    }

    if (edge_tables.size() != other->edge_tables.size()) {
        return false;
    }
    for (idx_t i = 0; i < edge_tables.size(); i++) {
        if (edge_tables[i]->Equals(other->edge_tables[i].get())) {
            return false;
        }
    }
    return true;
}


void CreatePropertyGraphInfo::Serialize(FieldWriter &writer) const {
	writer.WriteString(property_graph_name);
    writer.WriteSerializableList<PropertyGraphTable>(vertex_tables);
    writer.WriteSerializableList<PropertyGraphTable>(edge_tables);
//    writer.WriteRegularSerializableMap<PropertyGraphTable*>(label_map);
}

unique_ptr<ParsedExpression> CreatePropertyGraphInfo::Copy() const {
	auto result = make_uniq<CreatePropertyGraphInfo>(property_graph_name);

	for (auto &vertex_table : vertex_tables) {
        auto copied_vertex_table = vertex_table->Copy();
        for (auto &label : copied_vertex_table->sub_labels) {
            result->label_map[label] = copied_vertex_table.get();
        }
        result->label_map[copied_vertex_table->main_label] = copied_vertex_table.get();
		result->vertex_tables.push_back(std::move(copied_vertex_table));
	}
	for (auto &edge_table : edge_tables) {
        auto copied_edge_table = edge_table->Copy();
        for (auto &label : copied_edge_table->sub_labels) {
            result->label_map[label] = copied_edge_table.get();
        }
        result->label_map[copied_edge_table->main_label] = copied_edge_table.get();
        result->edge_tables.push_back(std::move(copied_edge_table));
	}
	return std::move(result);
}

    unique_ptr<ParsedExpression> CreatePropertyGraphInfo::Deserialize(FieldReader &reader) {
        auto result = make_uniq<CreatePropertyGraphInfo>();
        result->property_graph_name = reader.ReadRequired<string>();
        result->vertex_tables = reader.ReadRequiredSerializableList<PropertyGraphTable>();
        result->edge_tables = reader.ReadRequiredSerializableList<PropertyGraphTable>();
//        result->label_map = reader.ReadRequiredSerializableMap<PropertyGraphTable>();
        reader.Finalize();
        return result;
    }

} // namespace duckdb

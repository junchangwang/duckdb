#include "duckdb/planner/binder.hpp"
#include "duckdb/planner/expression/bound_cast_expression.hpp"
#include "duckdb/planner/expression/bound_columnref_expression.hpp"
#include "duckdb/planner/operator/logical_projection.hpp"
#include "duckdb/planner/operator/logical_window.hpp"
#include "duckdb/planner/expression/bound_reference_expression.hpp"
#include "duckdb/planner/expression/bound_window_expression.hpp"
#include "duckdb/planner/operator/logical_set_operation.hpp"
#include "duckdb/planner/query_node/bound_set_operation_node.hpp"

namespace duckdb {

// Optionally push a PROJECTION operator
unique_ptr<LogicalOperator> Binder::CastLogicalOperatorToTypes(vector<LogicalType> &source_types,
                                                               vector<LogicalType> &target_types,
                                                               unique_ptr<LogicalOperator> op) {
	D_ASSERT(op);
	// first check if we even need to cast
	D_ASSERT(source_types.size() == target_types.size());
	if (source_types == target_types) {
		// source and target types are equal: don't need to cast
		return op;
	}
	// otherwise add casts
	auto node = op.get();
	if (node->type == LogicalOperatorType::LOGICAL_PROJECTION) {
		// "node" is a projection; we can just do the casts in there
		D_ASSERT(node->expressions.size() == source_types.size());
		// add the casts to the selection list
		for (idx_t i = 0; i < target_types.size(); i++) {
			if (source_types[i] != target_types[i]) {
				// differing types, have to add a cast
				string alias = node->expressions[i]->alias;
				node->expressions[i] =
				    BoundCastExpression::AddCastToType(context, std::move(node->expressions[i]), target_types[i]);
				node->expressions[i]->alias = alias;
			}
		}
		return op;
	} else {
		// found a non-projection operator
		// push a new projection containing the casts

		// fetch the set of column bindings
		auto setop_columns = op->GetColumnBindings();
		D_ASSERT(setop_columns.size() == source_types.size());

		// now generate the expression list
		vector<unique_ptr<Expression>> select_list;
		for (idx_t i = 0; i < target_types.size(); i++) {
			unique_ptr<Expression> result = make_uniq<BoundColumnRefExpression>(source_types[i], setop_columns[i]);
			if (source_types[i] != target_types[i]) {
				// add a cast only if the source and target types are not equivalent
				result = BoundCastExpression::AddCastToType(context, std::move(result), target_types[i]);
			}
			select_list.push_back(std::move(result));
		}
		auto projection = make_uniq<LogicalProjection>(GenerateTableIndex(), std::move(select_list));
		projection->children.push_back(std::move(op));
		return std::move(projection);
	}
}

unique_ptr<LogicalOperator> Binder::CreatePlan(BoundSetOperationNode &node) {
	// Generate the logical plan for the left and right sides of the set operation
	node.left_binder->is_outside_flattened = is_outside_flattened;
	node.right_binder->is_outside_flattened = is_outside_flattened;

	auto left_node = node.left_binder->CreatePlan(*node.left);
	auto right_node = node.right_binder->CreatePlan(*node.right);

	// Add a new projection to child node
	D_ASSERT(node.left_reorder_exprs.size() == node.right_reorder_exprs.size());
	if (!node.left_reorder_exprs.empty()) {
		D_ASSERT(node.setop_type == SetOperationType::UNION_BY_NAME);
		vector<LogicalType> left_types;
		vector<LogicalType> right_types;
		// We are going to add a new projection operator, so collect the type
		// of reorder exprs in order to call CastLogicalOperatorToTypes()
		for (idx_t i = 0; i < node.left_reorder_exprs.size(); ++i) {
			left_types.push_back(node.left_reorder_exprs[i]->return_type);
			right_types.push_back(node.right_reorder_exprs[i]->return_type);
		}

		auto left_projection = make_uniq<LogicalProjection>(GenerateTableIndex(), std::move(node.left_reorder_exprs));
		left_projection->children.push_back(std::move(left_node));
		left_node = std::move(left_projection);

		auto right_projection = make_uniq<LogicalProjection>(GenerateTableIndex(), std::move(node.right_reorder_exprs));
		right_projection->children.push_back(std::move(right_node));
		right_node = std::move(right_projection);

		left_node = CastLogicalOperatorToTypes(left_types, node.types, std::move(left_node));
		right_node = CastLogicalOperatorToTypes(right_types, node.types, std::move(right_node));
	} else {
		left_node = CastLogicalOperatorToTypes(node.left->types, node.types, std::move(left_node));
		right_node = CastLogicalOperatorToTypes(node.right->types, node.types, std::move(right_node));
	}

	// check if there are any unplanned subqueries left in either child
	has_unplanned_dependent_joins =
	    node.left_binder->has_unplanned_dependent_joins || node.right_binder->has_unplanned_dependent_joins;

	// create actual logical ops for setops
	LogicalOperatorType logical_type;
	switch (node.setop_type) {
	case SetOperationType::UNION:
	case SetOperationType::UNION_BY_NAME:
		logical_type = LogicalOperatorType::LOGICAL_UNION;
		break;
	case SetOperationType::EXCEPT:
		logical_type = LogicalOperatorType::LOGICAL_EXCEPT;
		break;
	case SetOperationType::INTERSECT:
		logical_type = LogicalOperatorType::LOGICAL_INTERSECT;
		break;
	default:
		D_ASSERT(false);
		break;
	}

	// here we convert the set operation to anti semi if required. Using the node.setop all we know what conversion we
	// need.
	auto root = make_uniq<LogicalSetOperation>(node.setop_index, node.types.size(), std::move(left_node),
	                                           std::move(right_node), logical_type, node.setop_all);

	unique_ptr<LogicalOperator> op;

	// if we have an intersect or except, immediately translate it to a semi or anti join.
	if (logical_type == LogicalOperatorType::LOGICAL_INTERSECT || logical_type == LogicalOperatorType::LOGICAL_EXCEPT) {
		auto &left = root->children[0];
		auto &right = root->children[1];
		auto left_types = root->children[0]->types;
		auto right_types = root->children[1]->types;
		auto old_bindings = root->GetColumnBindings();
		auto table_index = root->table_index;
		if (node.setop_all) {

			// instead create a logical projection on top of whatever to add the window expression, then
			auto left_window_table_index = GenerateTableIndex();
			auto left_window = make_uniq<LogicalWindow>(left_window_table_index);
			auto row_number =
			    make_uniq<BoundWindowExpression>(ExpressionType::WINDOW_ROW_NUMBER, LogicalType::BIGINT, nullptr, nullptr);
			row_number->start = WindowBoundary::UNBOUNDED_PRECEDING;
			row_number->end = WindowBoundary::CURRENT_ROW_ROWS;
			auto left_bindings = left->GetColumnBindings();
			for (idx_t i = 0; i < left_types.size(); i++) {
				auto left_type = LogicalType(LogicalType::UNKNOWN);
				if (i < left_types.size()) {
					left_type = left_types[i];
				}
				row_number->partitions.push_back(make_uniq<BoundColumnRefExpression>(left_type, left_bindings[i]));
			}
			left_window->expressions.push_back(std::move(row_number));
			left_window->AddChild(std::move(left));
			left = std::move(left_window);

			auto right_window_table_index = GenerateTableIndex();
			auto right_window = make_uniq<LogicalWindow>(right_window_table_index);
			row_number =
			    make_uniq<BoundWindowExpression>(ExpressionType::WINDOW_ROW_NUMBER, LogicalType::BIGINT, nullptr, nullptr);
			row_number->start = WindowBoundary::UNBOUNDED_PRECEDING;
			row_number->end = WindowBoundary::CURRENT_ROW_ROWS;
			auto right_bindings = right->GetColumnBindings();
			for (idx_t i = 0; i < right_bindings.size(); i++) {
				auto right_type = LogicalType(LogicalType::UNKNOWN);
				if (i < right_types.size()) {
					right_type = right_types[i];
				}
				row_number->partitions.push_back(make_uniq<BoundColumnRefExpression>(right_type, right_bindings[i]));
			}
			right_window->expressions.push_back(std::move(row_number));
			right_window->AddChild(std::move(right));
			right = std::move(right_window);

			root->types.push_back(LogicalType::BIGINT);
			root->column_count += 1;
		}

		auto left_bindings = left->GetColumnBindings();
		auto right_bindings = right->GetColumnBindings();
		D_ASSERT(left_bindings.size() == right_bindings.size());

		vector<JoinCondition> conditions;
		// create equality condition for all columns
		for (idx_t i = 0; i < left_bindings.size() - 1; i++) {
			auto cond_type_left = LogicalType(LogicalType::UNKNOWN);
			auto cond_type_right = LogicalType(LogicalType::UNKNOWN);
			if (i < left_types.size()) {
				cond_type_left = left_types[i];
				cond_type_right = right_types[i];
			}
			JoinCondition cond;
			cond.left = make_uniq<BoundColumnRefExpression>(cond_type_left, left_bindings[i]);
			cond.right = make_uniq<BoundColumnRefExpression>(cond_type_right, right_bindings[i]);
			cond.comparison = ExpressionType::COMPARE_NOT_DISTINCT_FROM;
			conditions.push_back(std::move(cond));
		}

		if (node.setop_all) {
			JoinCondition cond;
			cond.left =
			    make_uniq<BoundColumnRefExpression>(LogicalType::BIGINT, left_bindings[left_bindings.size() - 1]);
			cond.right =
			    make_uniq<BoundColumnRefExpression>(LogicalType::BIGINT, right_bindings[right_bindings.size() - 1]);
			cond.comparison = ExpressionType::COMPARE_NOT_DISTINCT_FROM;
			conditions.push_back(std::move(cond));
		}

		JoinType join_type = root->type == LogicalOperatorType::LOGICAL_EXCEPT ? JoinType::ANTI : JoinType::SEMI;

		auto join_op = make_uniq<LogicalComparisonJoin>(join_type);
		join_op->children.push_back(std::move(left));
		join_op->children.push_back(std::move(right));
		join_op->conditions = std::move(conditions);
		join_op->ResolveOperatorTypes();

		op = std::move(join_op);

		// create projection to remove row_id.
		if (node.setop_all) {
			vector<unique_ptr<Expression>> projection_select_list;
			auto bindings = op->GetColumnBindings();
			for (idx_t i = 0; i < bindings.size() - 1; i++) {
				projection_select_list.push_back(make_uniq<BoundColumnRefExpression>(op->types[i], bindings[i]));
			}
			auto projection_table_index = GenerateTableIndex();
			auto projection =
			    make_uniq<LogicalProjection>(projection_table_index, std::move(projection_select_list));
			projection->children.push_back(std::move(op));
//			projection->ResolveOperatorTypes();
			op = std::move(projection);
		}

		if (!node.setop_all) {
			// push a distinct operator on the join
			auto &types = op->types;
			auto join_bindings = op->GetColumnBindings();
			vector<unique_ptr<Expression>> distinct_targets;
			vector<unique_ptr<Expression>> select_list;
			for (idx_t i = 0; i < join_bindings.size(); i++) {
				distinct_targets.push_back(make_uniq<BoundColumnRefExpression>(types[i], join_bindings[i]));
				select_list.push_back(make_uniq<BoundColumnRefExpression>(types[i], join_bindings[i]));
			}
			auto distinct = make_uniq<LogicalDistinct>(std::move(distinct_targets), DistinctType::DISTINCT);
			distinct->children.push_back(std::move(op));
			op = std::move(distinct);

			auto projection = make_uniq<LogicalProjection>(table_index, std::move(select_list));
			projection->children.push_back(std::move(op));
			op = std::move(projection);
			op->ResolveOperatorTypes();
		}
		return VisitQueryNode(node, std::move(op));
	}
	return VisitQueryNode(node, std::move(root));
}

} // namespace duckdb

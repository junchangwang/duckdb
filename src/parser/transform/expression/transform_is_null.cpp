#include "duckdb/common/exception.hpp"
#include "duckdb/parser/expression/operator_expression.hpp"
#include "duckdb/parser/transformer.hpp"

namespace duckdb {
using namespace std;
using namespace duckdb_libpgquery;

unique_ptr<ParsedExpression> Transformer::TransformNullTest(PGNullTest *root) {
	D_ASSERT(root);
	auto arg = TransformExpression(reinterpret_cast<PGNode *>(root->arg));
	if (root->argisrow) {
		throw NotImplementedException("IS NULL argisrow");
	}
	ExpressionType expr_type =
	    (root->nulltesttype == PG_IS_NULL) ? ExpressionType::OPERATOR_IS_NULL : ExpressionType::OPERATOR_IS_NOT_NULL;

	return unique_ptr<ParsedExpression>(new OperatorExpression(expr_type, move(arg)));
}

} // namespace duckdb

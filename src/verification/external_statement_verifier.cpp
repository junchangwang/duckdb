#include "duckdb/verification/external_statement_verifier.hpp"

namespace duckdb {

ExternalStatementVerifier::ExternalStatementVerifier(unique_ptr<SQLStatement> statement_p)
    : StatementVerifier(VerificationType::EXTERNAL, "External", Move(statement_p)) {
}

unique_ptr<StatementVerifier> ExternalStatementVerifier::Create(const SQLStatement &statement) {
	return make_unique<ExternalStatementVerifier>(statement.Copy());
}

} // namespace duckdb

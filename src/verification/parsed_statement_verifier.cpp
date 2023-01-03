#include "duckdb/verification/parsed_statement_verifier.hpp"

#include "duckdb/parser/parser.hpp"

namespace duckdb {

ParsedStatementVerifier::ParsedStatementVerifier(unique_ptr<SQLStatement> statement_p)
    : StatementVerifier(VerificationType::PARSED, "Parsed", Move(statement_p)) {
}

unique_ptr<StatementVerifier> ParsedStatementVerifier::Create(const SQLStatement &statement) {
	auto query_str = statement.ToString();
	Parser parser;
	try {
		parser.ParseQuery(query_str);
	} catch (std::exception &ex) {
		throw InternalException("Parsed statement verification failed. Query:\n%s\n\nError: %s", query_str, ex.what());
	}
	D_ASSERT(parser.statements.size() == 1);
	D_ASSERT(parser.statements[0]->type == StatementType::SELECT_STATEMENT);
	return make_unique<ParsedStatementVerifier>(Move(parser.statements[0]));
}

} // namespace duckdb

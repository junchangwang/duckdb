#include "../common.h"

using namespace odbc_test;

std::vector<std::vector<std::string>> all_types = {
	{"boolean", "true"},
	{"bytea", "\\x464F4F"},
	{"char", "x"},
	{"int8", "1234567890"},
	{"int2", "12345"},
	{"int4", "1234567"},
	{"text", "textdata"},
	{"float4", "1.234"},
	{"double", "1.23456789012"},
	{"varchar", "foobar"},
	{"date", "2011-02-13"},
	{"time", "13:23:34"},
	{"timestamp", "2011-02-15 15:49:18"},
	{"interval", "10 years -11 months -12 days 13:14:00"},
	{"numeric", "1234.567890"}
};

std::vector<std::pair<SQLINTEGER, std::string>> all_sql_types =  {
    {SQL_C_CHAR, "SQL_C_CHAR"},
    {SQL_C_WCHAR, "SQL_C_WCHAR"},
    {SQL_C_SSHORT, "SQL_C_SSHORT"},
    {SQL_C_USHORT, "SQL_C_USHORT"},
    {SQL_C_SLONG, "SQL_C_SLONG"},
    {SQL_C_ULONG, "SQL_C_ULONG"},
    {SQL_C_FLOAT, "SQL_C_FLOAT"},
    {SQL_C_DOUBLE, "SQL_C_DOUBLE"},
    {SQL_C_BIT, "SQL_C_BIT"},
    {SQL_C_STINYINT, "SQL_C_STINYINT"},
    {SQL_C_UTINYINT, "SQL_C_UTINYINT"},
    {SQL_C_SBIGINT, "SQL_C_SBIGINT"},
    {SQL_C_UBIGINT, "SQL_C_UBIGINT"},
    {SQL_C_BINARY, "SQL_C_BINARY"},
    {SQL_C_NUMERIC, "SQL_C_NUMERIC"},
    {SQL_C_BOOKMARK, "SQL_C_BOOKMARK"},
    {SQL_C_VARBOOKMARK, "SQL_C_VARBOOKMARK"},
    {SQL_C_TYPE_DATE, "SQL_C_TYPE_DATE"},
    {SQL_C_TYPE_TIME, "SQL_C_TYPE_TIME"},
    {SQL_C_TYPE_TIMESTAMP, "SQL_C_TYPE_TIMESTAMP"},
    {SQL_C_GUID, "SQL_C_GUID"},
    {SQL_C_INTERVAL_YEAR, "SQL_C_INTERVAL_YEAR"},
    {SQL_C_INTERVAL_MONTH, "SQL_C_INTERVAL_MONTH"},
    {SQL_C_INTERVAL_DAY, "SQL_C_INTERVAL_DAY"},
    {SQL_C_INTERVAL_HOUR, "SQL_C_INTERVAL_HOUR"},
    {SQL_C_INTERVAL_MINUTE, "SQL_C_INTERVAL_MINUTE"},
    {SQL_C_INTERVAL_SECOND, "SQL_C_INTERVAL_SECOND"},
    {SQL_C_INTERVAL_YEAR_TO_MONTH, "SQL_C_INTERVAL_YEAR_TO_MONTH"},
    {SQL_C_INTERVAL_DAY_TO_HOUR, "SQL_C_INTERVAL_DAY_TO_HOUR"},
    {SQL_C_INTERVAL_DAY_TO_MINUTE, "SQL_C_INTERVAL_DAY_TO_MINUTE"},
    {SQL_C_INTERVAL_DAY_TO_SECOND, "SQL_C_INTERVAL_DAY_TO_SECOND"},
    {SQL_C_INTERVAL_HOUR_TO_MINUTE, "SQL_C_INTERVAL_HOUR_TO_MINUTE"},
    {SQL_C_INTERVAL_HOUR_TO_SECOND, "SQL_C_INTERVAL_HOUR_TO_SECOND"},
    {SQL_C_INTERVAL_MINUTE_TO_SECOND, "SQL_C_INTERVAL_MINUTE_TO_SECOND"}
};

std::vector<std::vector<std::string>> results = {
    {"true", "true", "1", "1", "1", "1", "1.000000", "1.000000", "", "1", "1", "1", "1", "hex: 74727565", "1", "hex: 74727565", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"F4F4F", "F4F4F", "", "", "", "", "", "", "", "", "", "", "", "hex: 4634463446", "", "hex: 4634463446", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"x", "x", "", "", "", "", "", "", "", "", "", "", "", "hex: 78", "", "hex: 78", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"1234567890", "1234567890", "", "", "", "", "1234567936.000000", "1234567890.000000", "", "", "", "1234567890", "1234567890", "hex: 31323334353637383930", "1234567890", "hex: 31323334353637383930", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"12345", "12345", "12345", "12345", "12345", "12345", "12345.000000", "12345.000000", "", "12345", "12345", "12345", "12345", "hex: 3132333435", "12345", "hex: 3132333435", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"1234567", "1234567", "", "", "1234567", "1234567", "1234567.000000", "1234567.000000", "", "", "", "", "1234567", "1234567", "hex: 31323334353637", "1234567", "hex: 31323334353637", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"textdata", "textdata", "", "", "", "", "", "", "", "", "", "", "", "", "hex: 7465787464617461", "", "hex: 7465787464617461", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"1.234", "1.234", "1", "1", "1", "1", "1.234000", "1.234000", "", "1", "1", "1", "1", "hex: 312E323334", "1", "hex: 312E323334", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"1.23456789012", "1.23456789012", "1", "1", "1", "1", "1.234568", "1.234568", "", "1", "1", "1", "1", "hex: 312E3233343536373839303132", "1", "hex: 312E3233343536373839303132", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"foobar", "foobar", "", "", "", "", "", "", "", "", "", "", "", "", "hex: 666F6F626172", "", "hex: 666F6F626172", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"2011-02-13", "2011-02-13", "", "", "", "", "", "", "", "", "", "", "hex: 323031312D30322D3133", "", "hex: 323031312D30322D3133", "y: 2011 m: 2 d: 13", "", "y: 2011 m: 2 d: 13 h: 0 m: 0 s: 0 f: 0", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"13:23:34", "13:23:34", "", "", "", "", "", "", "", "", "", "", "", "", "hex: 31333A32333A3334", "", "hex: 31333A32333A3334", "", "h: 13 m: 23 s: 34", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    {"2011-02-15 15:49:18", "2011-02-15 15:49:18", "", "", "", "", "", "", "", "", "", "", "", "", "hex: 323031312D30322D31352031353A34393A3138", "", "hex: 323031312D30322D31352031353A34393A3138", "y: 2011 m: 2 d: 15", "h: 15 m: 49 s: 18", "y: 2011 m: 2 d: 15 h: 15 m: 49 s: 18 f: 0", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
    { "9 years 1 month -12 days 13:14:00", "9 years 1 month -12 days 13:14:00", "", "", "", "", "", "", "", "", "", "", "", "hex: 392079656172732031206D6F6E7468202D313220646179732031333A31343A3030", "", "hex: 392079656172732031206D6F6E7468202D313220646179732031333A31343A3030", "", "", "", "interval sign: 0 year: 9", "interval sign: 0 month: 109", "interval sign: 0 day: 3258", "interval sign: 0 hour: 78205", "interval sign: 0 minute: 4692314", "interval sign: 0 second: 281538840", "interval sign: 0 year 9 month: 1", "interval sign: 0 day: 3258 hour: 13", "interval sign: 0 day: 3258 hour: 13 minute: 14", "interval sign: 0 day: 3258 hour: 13 minute: 14 second: 0 fraction: 0", "interval sign: 0 hour: 78205 minute: 14", "interval sign: 0 hour: 78205 minute: 14 second: 0 fraction: 0", "interval sign: 0 minute: 4692314 second: 0 fraction: 0" },
    { "1234.568", "1234.568", "1235", "1235", "1235", "1235", "1234.567993", "1234.568000", "", "", "", "1235", "1235", "hex: 313233342E353638", "1235", "hex: 313233342E353638", "", "", "", "precision: 7 scale: 3 sign: 1 val: 88d61200000000000000000000000000", "", "", "", "", "", "", "", "", "", "", "", "", "", "" },
};

static void ConvertAndCheck(HSTMT &hstmt, std::vector<std::string> type, const std::string& sql_type, int type_index, int sql_type_index) {
	std::string query = "SELECT $$" + type[1] + "$$::" + type[0] + " AS result_col /* convert to " + sql_type + " */";

	EXECUTE_AND_CHECK(query.c_str(), SQLExecDirect, hstmt, ConvertToSQLCHAR(query), SQL_NTS);

	EXECUTE_AND_CHECK("SQLFetch", SQLFetch, hstmt);
	if (results[type_index][sql_type_index].empty()) {
		SQLCHAR content[256];
		SQLLEN content_len;
		SQLRETURN ret = SQLGetData(hstmt, 1, SQL_C_CHAR, content, sizeof(content), &content_len);
		REQUIRE(ret == SQL_ERROR);
	}
	DATA_CHECK(hstmt, 1, results[type_index][sql_type_index]);
}

TEST_CASE("Test Result Conversion", "[odbc]") {
	SQLHANDLE env;
	SQLHANDLE dbc;

	HSTMT hstmt = SQL_NULL_HSTMT;

	// Connect to the database using SQLConnect
	CONNECT_TO_DATABASE(env, dbc);

	// Allocate a statement handle
	EXECUTE_AND_CHECK("SQLAllocHandle (HSTMT)", SQLAllocHandle, SQL_HANDLE_STMT, dbc, &hstmt);

	for (int type_index = 0; type_index < all_types.size(); type_index++) {
		for (int sql_type_index = 0; sql_type_index < all_sql_types.size(); sql_type_index++) {
			ConvertAndCheck(hstmt, all_types[type_index], all_sql_types[sql_type_index].second, type_index, sql_type_index);
		}
	}

	// Free the statement handle
	EXECUTE_AND_CHECK("SQLFreeStmt (HSTMT)", SQLFreeStmt, hstmt, SQL_CLOSE);
	EXECUTE_AND_CHECK("SQLFreeHandle (HSTMT)", SQLFreeHandle, SQL_HANDLE_STMT, hstmt);

	DISCONNECT_FROM_DATABASE(env, dbc);
}

//SELECT $$true$$::boolean AS boolean_col /* convert to SQL_C_CHAR */

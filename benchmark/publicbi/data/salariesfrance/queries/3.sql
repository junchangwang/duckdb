SELECT "SalariesFrance_11"."A129_LIBCOURT_PJ" AS "A129_LIBCOURT_PJ",   "SalariesFrance_11"."A129_LIB" AS "A129_LIB",   "SalariesFrance_11"."Calculation_490892384732147714" AS "Calculation_490892384732147714",   MIN("SalariesFrance_11"."NOM_PAGES_JAUNES") AS "min:NOM_PAGES_JAUNES:nk",   SUM("SalariesFrance_11"."EMPSAL_NP1") AS "sum:EMPSAL_NP1:ok" FROM "SalariesFrance_11" GROUP BY "SalariesFrance_11"."A129_LIBCOURT_PJ",   "SalariesFrance_11"."A129_LIB", "SalariesFrance_11"."Calculation_490892384732147714" ORDER BY "A129_LIBCOURT_PJ";

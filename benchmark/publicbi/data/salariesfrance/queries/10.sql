SELECT "SalariesFrance_13"."ROME" AS "ROME",   "SalariesFrance_13"."ROME_LIB" AS "ROME_LIB",   MIN("SalariesFrance_13"."CODGEO_PRINCIPAL") AS "min:CODGEO_PRINCIPAL:nk",   SUM("SalariesFrance_13"."EMPSAL_NP1") AS "sum:EMPSAL_NP1:ok" FROM "SalariesFrance_13" GROUP BY "SalariesFrance_13"."ROME",   "SalariesFrance_13"."ROME_LIB" HAVING (SUM("SalariesFrance_13"."EMPSAL_NP1") >= cast('0' as double)) ORDER BY "ROME";

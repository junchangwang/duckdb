SELECT CAST("USCensus_3"."REGION" AS BIGINT) AS "REGION",   COUNT(DISTINCT "USCensus_3"."SERIALNO1") AS "ctd:SERIALNO:ok",   SUM(CAST("USCensus_3"."Number of Records" AS BIGINT)) AS "sum:Number of Records:ok" FROM "USCensus_3" GROUP BY "USCensus_3"."REGION",   "USCensus_3"."REGION" ORDER BY "REGION";

SELECT CAST(EXTRACT(HOUR FROM "HashTags_1"."Calculation_6610227171140491") AS BIGINT) AS "hr:Calculation_6610227171140491:ok",   SUM(CAST("HashTags_1"."Number of Records" AS BIGINT)) AS "sum:Number of Records:ok" FROM "HashTags_1" GROUP BY "hr:Calculation_6610227171140491:ok" ORDER BY "hr:Calculation_6610227171140491:ok";

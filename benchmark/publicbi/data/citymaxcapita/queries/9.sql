SELECT "CityMaxCapita_1"."City" AS "City",   SUM(1) AS "TEMP(Calculation_-1088745174867206144)(2109769841)(0)",   SUM(CAST("CityMaxCapita_1"."Number of Records" AS BIGINT)) AS "TEMP(Calculation_383650433982345216)(3967762572)(0)" FROM "CityMaxCapita_1" WHERE ("CityMaxCapita_1"."Keyword" = 'dyke') GROUP BY "CityMaxCapita_1"."City" ORDER BY "City";

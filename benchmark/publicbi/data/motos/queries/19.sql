SELECT CAST(EXTRACT(MONTH FROM "Motos_1"."FECHA") AS BIGINT) AS "mn:FECHA:ok" FROM "Motos_1" WHERE (("Motos_1"."Categoria" IN ('CAMIONES', 'CAMIONES, BUSES Y PANELES', 'MOTOCICLETAS', 'PICK UPS, VANS Y JEEPS', 'PICK-UPS', 'SUV Y JEEPS', 'VEHICULOS NUEVOS')) AND (CAST(EXTRACT(YEAR FROM "Motos_1"."FECHA") AS BIGINT) >= 2010) AND (CAST(EXTRACT(YEAR FROM "Motos_1"."FECHA") AS BIGINT) <= 2015)) GROUP BY "mn:FECHA:ok" ORDER BY "mn:FECHA:ok";

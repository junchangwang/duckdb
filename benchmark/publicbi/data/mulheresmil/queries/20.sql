SELECT COUNT(DISTINCT "MulheresMil_1"."Calculation_838513981462429699") AS "ctd:Calculation_838513981462429699:ok" FROM "MulheresMil_1" WHERE ((NOT (("MulheresMil_1"."nome da sit matricula (situacao detalhada)" NOT IN ('', 'INTEGRALIZADA', 'TRANCADA', 'EM_CURSO', 'EM_DEPENDÊNCIA')) OR ("MulheresMil_1"."nome da sit matricula (situacao detalhada)" IS NULL))) AND (NOT ("MulheresMil_1"."situacao_da_turma" IN ('CANCELADA', 'CRIADA', 'PUBLICADA')))) HAVING (COUNT(1) > 0) ORDER BY "ctd:Calculation_838513981462429699:ok";

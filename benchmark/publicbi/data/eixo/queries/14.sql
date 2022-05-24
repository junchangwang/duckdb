SELECT COUNT(DISTINCT "Eixo_1"."Calculation_838513981462429699") AS "ctd:Calculation_838513981462429699:ok" FROM "Eixo_1" WHERE (("Eixo_1"."eixo_tecnologico_catalogo_guia" IN ('Hospitalidade e Lazer', 'Turismo, Hospitalidade e Lazer')) AND ("Eixo_1"."eixo_tecnológico" = 'Turismo, Hospitalidade e Lazer') AND (NOT (("Eixo_1"."nome da sit matricula (situacao detalhada)" IN ('CANC_DESISTENTE', 'CANC_MAT_PRIM_OPCAO', 'CANC_SANÇÃO', 'CANC_SEM_FREQ_INICIAL', 'CANC_TURMA', 'DOC_INSUFIC', 'ESCOL_INSUFIC', 'INC _ITINERARIO', 'INSC_CANC', 'Não Matriculado', 'NÃO_COMPARECEU', 'TURMA_CANC', 'VAGAS_INSUFIC')) OR ("Eixo_1"."nome da sit matricula (situacao detalhada)" IS NULL))) AND (NOT ("Eixo_1"."situacao_da_turma" IN ('CANCELADA', 'CRIADA', 'PUBLICADA'))) AND (CAST(EXTRACT(YEAR FROM "Eixo_1"."data_de_inicio") AS BIGINT) IN (2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016))) HAVING (COUNT(1) > 0) ORDER BY "ctd:Calculation_838513981462429699:ok";

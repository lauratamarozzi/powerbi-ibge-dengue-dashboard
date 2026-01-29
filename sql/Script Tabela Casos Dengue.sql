CREATE TABLE dengue_ibge (
    cod_municipio_6 VARCHAR(6),
    municipio VARCHAR(255),
    casos_provaveis INT
);

CREATE TEMP TABLE temp_dengue (
    coluna_misturada VARCHAR(255),
    qtd_casos VARCHAR(20)
);

COPY temp_dengue 
FROM 'C:\PowerBI_Projeto\Tabela_Dengue.csv' 
WITH (
    FORMAT CSV, 
    DELIMITER ';',
    HEADER false,
    ENCODING 'UTF8'
);

INSERT INTO dengue_ibge (cod_municipio_6, municipio, casos_provaveis)
SELECT 
    SPLIT_PART(coluna_misturada, ' ', 1),
    SUBSTRING(coluna_misturada FROM 8),
    CASE 
        WHEN qtd_casos = '-' THEN 0 
        WHEN qtd_casos = '...' THEN 0
        ELSE CAST(qtd_casos AS INTEGER) 
    END
FROM temp_dengue
WHERE coluna_misturada IS NOT NULL 
  AND LENGTH(coluna_misturada) > 6;

DROP TABLE temp_dengue;

SELECT * FROM dengue_ibge LIMIT 10;
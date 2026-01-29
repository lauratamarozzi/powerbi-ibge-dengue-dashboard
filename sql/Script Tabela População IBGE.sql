CREATE TABLE populacao_ibge (
    cod_municipio VARCHAR(7),
    municipio VARCHAR(255),
    populacao INT
);

CREATE TEMP TABLE temp_ibge_segura (
    codigo_bruto VARCHAR(255),
    nome_bruto VARCHAR(255),
    populacao_bruto VARCHAR(255)
);

COPY temp_ibge_segura 
FROM 'C:\PowerBI_Projeto\Tabela Densidade.csv' 
WITH (
    FORMAT CSV, 
    DELIMITER ';',
    HEADER false, 
    ENCODING 'UTF8'
);

INSERT INTO populacao_ibge (cod_municipio, municipio, populacao)
SELECT 
    codigo_bruto, 
    nome_bruto, 
    CAST(populacao_bruto AS INTEGER)
FROM temp_ibge_segura
WHERE LENGTH(codigo_bruto) = 7
  AND populacao_bruto ~ '^[0-9]+$';

DROP TABLE temp_ibge_segura;

SELECT * FROM populacao_ibge LIMIT 10;
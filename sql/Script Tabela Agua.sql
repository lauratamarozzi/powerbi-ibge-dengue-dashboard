CREATE TABLE agua_parana (
    municipio VARCHAR(255),
    regional VARCHAR(255),
    economias_totais INT,
    economias_residenciais INT,
    ligacoes_totais INT
);

CREATE TEMP TABLE temp_agua (
    cidade VARCHAR(255),
    regiao VARCHAR(255),
    col_econ_total VARCHAR(50),
    col_econ_res VARCHAR(50),
    col_lig_total VARCHAR(50)
);

COPY temp_agua 
FROM 'C:\PowerBI_Projeto\Abastecimento de Agua Editado.csv' 
WITH (
    FORMAT CSV, 
    DELIMITER ';', 
    HEADER false,    
    ENCODING 'LATIN1'
);

INSERT INTO agua_parana
SELECT 
    cidade,
    regiao,
    CASE WHEN col_econ_total = '...' THEN 0 
         ELSE CAST(REPLACE(col_econ_total, '.', '') AS INTEGER) END,
    CASE WHEN col_econ_res = '...' THEN 0 
         ELSE CAST(REPLACE(col_econ_res, '.', '') AS INTEGER) END,
    CASE WHEN col_lig_total = '...' THEN 0 
         ELSE CAST(REPLACE(col_lig_total, '.', '') AS INTEGER) END
FROM temp_agua
WHERE cidade IS NOT NULL AND cidade <> '';

DROP TABLE temp_agua;

SELECT * FROM agua_parana LIMIT 10;
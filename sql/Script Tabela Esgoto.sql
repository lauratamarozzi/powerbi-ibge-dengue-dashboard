CREATE TABLE esgoto_parana (
    municipio VARCHAR(255),
    regional VARCHAR(255),
    unidades_total INT,
    unidades_residencial INT,
    ligacoes_total INT
);

CREATE TEMP TABLE temp_esgoto (
    cidade VARCHAR(255),
    regiao VARCHAR(255),
    v_unidades_tot VARCHAR(50),
    v_unidades_res VARCHAR(50),
    v_ligacoes_tot VARCHAR(50)
);

COPY temp_esgoto 
FROM 'C:\PowerBI_Projeto\Atendimento de Esgoto Editado.csv' 
WITH (
    FORMAT CSV, 
    DELIMITER ';',
    HEADER false,
    ENCODING 'UTF8' 
);

INSERT INTO esgoto_parana (municipio, regional, unidades_total, unidades_residencial, ligacoes_total)
SELECT 
    cidade,
    regiao,
    -- TRATAMENTO DA COLUNA 1 (Unidades Total)
    CASE 
        WHEN v_unidades_tot = '...' THEN 0 
        ELSE CAST(REPLACE(v_unidades_tot, '.', '') AS INTEGER)
    END,
    -- TRATAMENTO DA COLUNA 2 (Unidades Residencial)
    CASE 
        WHEN v_unidades_res = '...' THEN 0 
        ELSE CAST(REPLACE(v_unidades_res, '.', '') AS INTEGER)
    END,
    -- TRATAMENTO DA COLUNA 3 (Ligações)
    CASE 
        WHEN v_ligacoes_tot = '...' THEN 0 
        ELSE CAST(REPLACE(v_ligacoes_tot, '.', '') AS INTEGER)
    END
FROM temp_esgoto
WHERE cidade IS NOT NULL AND cidade <> '';

DROP TABLE temp_esgoto;

SELECT * FROM esgoto_parana LIMIT 10;
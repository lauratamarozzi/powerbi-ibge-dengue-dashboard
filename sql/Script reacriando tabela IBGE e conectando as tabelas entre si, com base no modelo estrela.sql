DROP TABLE IF EXISTS populacao_ibge;
DROP TABLE IF EXISTS temp_ibge_segura;

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

--limpa pra tabela oficial
INSERT INTO populacao_ibge (cod_municipio, municipio, populacao)
SELECT 
    codigo_bruto, 
    nome_bruto, 
    CAST(populacao_bruto AS INTEGER)
FROM temp_ibge_segura
WHERE LENGTH(codigo_bruto) = 7 
  AND populacao_bruto ~ '^[0-9]+$';

DROP TABLE temp_ibge_segura;

TRUNCATE TABLE dim_municipio CASCADE;

INSERT INTO dim_municipio (cod_ibge_7, cod_ibge_6, nome_municipio, uf)
SELECT 
    cod_municipio,
    LEFT(cod_municipio, 6),
    --separar "Curitiba" de "PR"
    TRIM(SPLIT_PART(municipio, '(', 1)), 
    REPLACE(SPLIT_PART(municipio, '(', 2), ')', '')
FROM populacao_ibge;

SELECT * FROM dim_municipio LIMIT 10;

INSERT INTO fato_populacao (id_municipio, populacao_total)
SELECT 
    dm.id_municipio,
    p.populacao
FROM populacao_ibge p
JOIN dim_municipio dm ON dm.cod_ibge_7 = p.cod_municipio;

INSERT INTO fato_dengue (id_municipio, casos_provaveis)
SELECT 
    dm.id_municipio,
    d.casos_provaveis
FROM dengue_ibge d
JOIN dim_municipio dm ON dm.cod_ibge_6 = d.cod_municipio_6;

INSERT INTO fato_saneamento (
    id_municipio, 
    agua_economias_totais, 
    agua_ligacoes_totais,
    esgoto_unidades_totais, 
    esgoto_ligacoes_totais
)
SELECT 
    dm.id_municipio,
    a.economias_totais,
    a.ligacoes_totais,
    e.unidades_total,
    e.ligacoes_total
FROM dim_municipio dm
--junta com agua
LEFT JOIN agua_parana a 
    ON UNACCENT(UPPER(dm.nome_municipio)) = UNACCENT(UPPER(a.municipio))
--junta com esgoto
LEFT JOIN esgoto_parana e 
    ON UNACCENT(UPPER(dm.nome_municipio)) = UNACCENT(UPPER(e.municipio))
WHERE a.municipio IS NOT NULL OR e.municipio IS NOT NULL;

--ta preenchendo coluna regional
UPDATE dim_municipio dm
SET regional_saude = a.regional
FROM agua_parana a
WHERE UNACCENT(UPPER(dm.nome_municipio)) = UNACCENT(UPPER(a.municipio))
AND dm.uf = 'PR';

SELECT 
    dm.nome_municipio,
    dm.regional_saude,
    fp.populacao_total,
    fd.casos_provaveis,
    fs.agua_ligacoes_totais,
    fs.esgoto_ligacoes_totais
FROM dim_municipio dm
LEFT JOIN fato_populacao fp ON dm.id_municipio = fp.id_municipio
LEFT JOIN fato_dengue fd ON dm.id_municipio = fd.id_municipio
LEFT JOIN fato_saneamento fs ON dm.id_municipio = fs.id_municipio
WHERE dm.uf = 'PR' --filtra
ORDER BY fp.populacao_total DESC
LIMIT 20;
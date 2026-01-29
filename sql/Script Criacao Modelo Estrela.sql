CREATE EXTENSION IF NOT EXISTS unaccent;

DROP TABLE IF EXISTS dim_municipio CASCADE;
CREATE TABLE dim_municipio (
    id_municipio SERIAL PRIMARY KEY,
    cod_ibge_7 VARCHAR(7) UNIQUE,
    cod_ibge_6 VARCHAR(6),
    nome_municipio VARCHAR(255),
    uf VARCHAR(2),
    regional_saude VARCHAR(255)
);

DROP TABLE IF EXISTS fato_populacao;
CREATE TABLE fato_populacao (
    id_fato SERIAL PRIMARY KEY,
    id_municipio INT REFERENCES dim_municipio(id_municipio),
    populacao_total INT
);

DROP TABLE IF EXISTS fato_dengue;
CREATE TABLE fato_dengue (
    id_fato SERIAL PRIMARY KEY,
    id_municipio INT REFERENCES dim_municipio(id_municipio),
    casos_provaveis INT
);

DROP TABLE IF EXISTS fato_saneamento;
CREATE TABLE fato_saneamento (
    id_fato SERIAL PRIMARY KEY,
    id_municipio INT REFERENCES dim_municipio(id_municipio),
    agua_economias_totais INT,
    agua_ligacoes_totais INT,
    esgoto_unidades_totais INT,
    esgoto_ligacoes_totais INT,
    percentual_cobertura_esgoto NUMERIC(5,2) 
);

INSERT INTO dim_municipio (cod_ibge_7, cod_ibge_6, nome_municipio, uf)
SELECT 
    cod_municipio,
    LEFT(cod_municipio, 6),
    TRIM(SPLIT_PART(municipio,
    REPLACE(SPLIT_PART(municipio,
FROM populacao_ibge;
DELETE FROM fato_saneamento
WHERE id_municipio IN (
    SELECT id_municipio FROM dim_municipio WHERE uf <> 'PR'
);

DELETE FROM fato_populacao
WHERE id_municipio IN (
    SELECT id_municipio FROM dim_municipio WHERE uf <> 'PR'
);

DELETE FROM fato_dengue
WHERE id_municipio IN (
    SELECT id_municipio FROM dim_municipio WHERE uf <> 'PR'
);

DELETE FROM dim_municipio WHERE uf <> 'PR';

SELECT count(*) as total_cidades_pr FROM dim_municipio;
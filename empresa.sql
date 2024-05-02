SELECT
    e.razao_social,
    e.nome_fantasia,
    e.data_abertura,
    CONCAT(
        SUBSTRING(en.cep, 1, 2),
        '.',
        SUBSTRING(en.cep, 3)
    ) AS cep_formatado,
    UNACCENT(en.tipo_logradouro) AS tipo_logradouro_sem_acentos,
    UNACCENT(en.logradouro) AS logradouro_sem_acentos,
    en.numero,
    UNACCENT(en.complemento) AS complemento_sem_acentos,
    UNACCENT(en.bairro) AS bairro_sem_acentos,
    cid.uf,
    cid.id AS cidade_ibge,
    UNACCENT(cid.nome) AS cidade_nome_sem_acentos,
    e.cnpj,
    e.natureza AS natureza_juridica,
    CONCAT(
        SUBSTRING(ae.cnae, 1, 4),
        '-',
        SUBSTRING(ae.cnae, 5, 1),
        '/',
        SUBSTRING(ae.cnae, 6)
    ) AS cnae_formatado,
    e.nire
FROM
    empresas e
    LEFT JOIN enderecos en ON e.endereco_id = en.id
    LEFT JOIN cidades cid ON en.cidade_id = cid.id
    LEFT JOIN atividade_economica_empresa aee ON e.id = aee.empresa_id
    AND aee.principal = true
    AND aee.deleted_at IS NULL
    LEFT JOIN atividades_economicas ae ON aee.atividade_economica_id = ae.id
WHERE
    e.cnpj IN (
        '54.755.630/0001-03',
        '54.904.096/0001-41',
        '54.953.991/0001-56',
        '54.728.925/0001-82',
        '49.159.447/0001-05',
        '54.953.818/0001-58',
        '54.948.342/0001-67',
        '54.713.651/0001-58',
        '54.871.153/0001-33',
        '54.867.117/0001-04'
    )
    AND e.deleted_at IS NULL
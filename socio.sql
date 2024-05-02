SELECT
    e.cnpj,
    e.data_abertura,
    c.nome,
    c.cpf,
    CASE
        WHEN ce.responsavel_legal THEN 1
        ELSE 0
    END AS responsavel_legal,
    u.email,
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
    cid.id AS cidade_ibge,
    UNACCENT(cid.nome) AS cidade_nome_sem_acentos,
    cid.uf
FROM
    clientes c
    LEFT JOIN cliente_empresa ce ON ce.cliente_id = c.id
    LEFT JOIN empresas e ON ce.empresa_id = e.id
    LEFT JOIN enderecos en ON c.endereco_id = en.id
    LEFT JOIN cidades cid ON en.cidade_id = cid.id
    LEFT JOIN usuarios u ON c.usuario_id = u.id
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
    AND ce.deleted_at IS NULL
    AND c.deleted_at IS NULL
ORDER BY
    ce.responsavel_legal DESC
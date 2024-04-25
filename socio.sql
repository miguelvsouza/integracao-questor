SELECT
    e.cnpj,
    e.data_abertura,
    c.nome,
    c.cpf,
    CASE
        ce.responsavel_legal
        WHEN true THEN 1
        ELSE 0
    END AS responsavel_legal,
    u.email,
    en.cep,
    -- replace para incluir o formato: 00.000-000
    en.tipo_logradouro,
    en.logradouro,
    en.numero,
    en.complemento,
    en.bairro,
    -- replace em caracteres especiais
    cid.id AS cidade_ibge,
    cid.nome AS cidade_nome,
    cid.uf
FROM
    clientes c
    LEFT JOIN cliente_empresa ce ON ce.cliente_id = c.id
    LEFT JOIN empresas e ON ce.empresa_id = e.id
    LEFT JOIN enderecos en ON c.endereco_id = en.id
    LEFT JOIN cidades cid ON en.cidade_id = cid.id
    LEFT JOIN usuarios u ON c.usuario_id = u.id
WHERE
    e.id = 1 -- Remover o filtro de empresa em produção
    AND e.deleted_at IS NULL
    AND ce.deleted_at IS NULL
    AND c.deleted_at IS NULL
ORDER BY
    ce.responsavel_legal DESC
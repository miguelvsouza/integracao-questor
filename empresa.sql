SELECT
    e.razao_social,
    e.nome_fantasia,
    e.data_abertura,
    en.cep,
    -- replace para incluir o formato: 00.000 -000
    en.tipo_logradouro,
    en.logradouro,
    en.numero,
    en.complemento,
    en.bairro,
    -- replace em caracteres especiais
    cid.uf,
    cid.id AS cidade_ibge,
    cid.nome AS cidade_nome,
    e.cnpj,
    e.natureza AS natureza_juridica,
    ae.cnae,
    -- replace para formato: 0000-0/00
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
    e.id = 1 -- Remover o filtro de empresa em produção
    AND e.deleted_at IS NULL
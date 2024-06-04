SELECT
  unaccent(e.razao_social) as razao_social,
  unaccent(e.nome_fantasia) as nome_fantasia,
  e.cnpj,
  e.data_competencia,
  e.data_abertura,
  e.natureza as natureza_juridica,
  e.nire,
  CONCAT(
    SUBSTRING(en.cep, 1, 2),
    '.',
    SUBSTRING(en.cep, 3)
  ) as cep,
  unaccent(en.tipo_logradouro) as tipo_logradouro,
  unaccent(en.logradouro) as logradouro,
  en.numero as numero,
  unaccent(en.complemento) as complemento,
  unaccent(en.bairro) as bairro,
  en.cidade_id as cidade_ibge,
  ci.uf as uf,
  unaccent(c.nome) as nome,
  c.cpf as cpf,
  u.email
FROM
  empresas e
  LEFT JOIN enderecos en ON e.endereco_id = en.id
  LEFT JOIN cidades ci ON en.cidade_id = ci.id
  LEFT JOIN cliente_empresa ce ON e.id = ce.empresa_id
  AND ce.responsavel_legal = true
  LEFT JOIN clientes c ON ce.cliente_id = c.id
  LEFT JOIN usuarios u ON c.usuario_id = u.id
WHERE
  e.id = 7
  AND e.deleted_at IS NULL
  AND en.deleted_at IS NULL
  AND ce.deleted_at IS NULL
  AND c.deleted_at IS NULL
  AND u.deleted_at IS NULL
-- unaccent para evitar problemas de acentuação na importação para a Questor
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
  -- 16
  c.cpf as cpf,
  u.email,
  c.data_nascimento,
  CASE
    c.raca_cor
    WHEN 1 THEN 2
    WHEN 2 THEN 4
    WHEN 3 THEN 6
    WHEN 4 THEN 8
    WHEN 5 THEN 1
    ELSE 2
  END AS raca_cor,
  c.genero,
  CASE
    c.estado_civil
    WHEN 3 THEN 2
    WHEN 4 THEN 3
    ELSE c.estado_civil
  END AS estado_civil
FROM
  empresas e
  LEFT JOIN enderecos en ON e.endereco_id = en.id
  LEFT JOIN cidades ci ON en.cidade_id = ci.id
  LEFT JOIN cliente_empresa ce ON e.id = ce.empresa_id
  AND ce.responsavel_legal = true
  LEFT JOIN clientes c ON ce.cliente_id = c.id
  LEFT JOIN usuarios u ON c.usuario_id = u.id
WHERE
  e.regime_tributario = 1 -- Somente empresas do Simples Nacional
  AND e.id IN (1032, 1033)
  AND e.categoria_cliente = 1 -- Somente empresas abertas pela GxMed
  AND e.data_abertura BETWEEN '2024-07-01'
  AND '2024-07-31'
  AND e.deleted_at IS NULL
  AND en.deleted_at IS NULL
  AND ce.deleted_at IS NULL
  AND c.deleted_at IS NULL
  AND u.deleted_at IS NULL -- PegarCampoTabela;CODIGOEMPRESA;ESTAB;INSCRFEDERAL
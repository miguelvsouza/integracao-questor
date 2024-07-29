SELECT
  REPLACE(
    UNACCENT(
    CASE t.pessoa_juridica
      WHEN true THEN t.razao_social
      ELSE t.nome_completo
    END
  ), ',', ''
  ) AS nome_tomador_1,
  CASE t.pessoa_juridica
    WHEN true THEN 2
    ELSE 1
  END AS tipo_inscricao_2,
  t.documento AS cpf_cnpj_3,
  CONCAT(
    SUBSTRING(en.cep, 1, 2),
    '.',
    SUBSTRING(en.cep, 3)
  ) as cep_4,
  UNACCENT(en.tipo_logradouro) as tipo_logradouro_5,
  UNACCENT(en.logradouro) as logradouro_6,
  UNACCENT(en.numero) as numero_7,
  UNACCENT(en.complemento) as complemento_8,
  UNACCENT(en.bairro) as bairro_9,
  cid.uf as uf_10,
  cid.id as cidade_id_11
FROM tomadores t
  LEFT JOIN enderecos en ON t.endereco_id = en.id
  LEFT JOIN cidades cid ON en.cidade_id = cid.id
WHERE t.deleted_at IS NULL
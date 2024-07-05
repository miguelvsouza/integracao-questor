SELECT
  replace(
    unaccent(
      CASE
        t.pessoa_juridica
        WHEN true THEN t.razao_social
        ELSE t.nome_completo
      END
    ),
    ',',
    ''
  ) AS nome_tomador_1,
  CASE
    t.pessoa_juridica
    WHEN true THEN 2
    ELSE 1
  END AS tipo_inscricao_2,
  t.documento as cpf_cnpj_3,
  CONCAT(
    SUBSTRING(en.cep, 1, 2),
    '.',
    SUBSTRING(en.cep, 3)
  ) as cep_4,
  unaccent(en.tipo_logradouro) as tipo_logradouro_5,
  unaccent(en.logradouro) as logradouro_6,
  unaccent(en.numero) as numero_7,
  unaccent(en.complemento) as complemento_8,
  unaccent(en.bairro) as bairro_9,
  cid.uf as uf_10,
  cid.id as cidade_id_11,
  nf.id as nf_id_12,
  nf.data_emissao :: date as nf_data_emissao_13,
  nf.valor as nf_valor_14,
  CASE
    (
      aliquota_ir + aliquota_csll + aliquota_pis + aliquota_cofins + aliquota_inss + CASE
        retem_iss
        WHEN true THEN aliquota_iss
        ELSE 0
      END
    )
    WHEN 0 THEN '9.000.001'
    ELSE '9.000.003'
  END AS codigo_cfop_15,
  nf.aliquota_iss as aliquota_iss_16,
  round(nf.aliquota_iss * nf.valor / 100, 2) as valor_iss_17,
  e.cnpj as cnpj_prestador_18,
  CASE
    nf.retem_iss
    WHEN true THEN nf.valor
    ELSE 0
  END as base_calculo_iss_19,
  CASE
    nf.retem_iss
    WHEN true THEN nf.aliquota_iss
    else 0
  end as aliquota_iss_retido_20,
  case
    nf.retem_iss
    when true then round(nf.valor * nf.aliquota_iss / 100, 2)
    else 0
  end as valor_iss_retido_21,
  case
    aliquota_ir
    when 0 then 0
    else nf.valor
  end as base_calculo_ir_22,
  case
    aliquota_ir
    when 0 then 0
    else round(nf.valor * nf.aliquota_ir / 100, 2)
  end as valor_ir_retido_23,
  case
    aliquota_ir
    when 0 then 0
    else nf.aliquota_ir
  end as aliquota_ir_retido_24,
  case
    aliquota_csll
    when 0 then 0
    else nf.valor
  end as base_calculo_csll_25,
  case
    aliquota_csll
    when 0 then 0
    else round(nf.valor * nf.aliquota_csll / 100, 2)
  end as valor_csll_retido_25,
  case
    aliquota_csll
    when 0 then 0
    else nf.aliquota_csll
  end as aliquota_csll_retido_26,
  case
    aliquota_pis
    when 0 then 0
    else nf.valor
  end as base_calculo_pis_27,
  case
    aliquota_pis
    when 0 then 0
    else round(nf.valor * nf.aliquota_pis / 100, 2)
  end as valor_pis_retido_28,
  case
    aliquota_pis
    when 0 then 0
    else nf.aliquota_pis
  end as aliquota_pis_retido_29,
  case
    aliquota_cofins
    when 0 then 0
    else nf.valor
  end as base_calculo_cofins_30,
  case
    aliquota_cofins
    when 0 then 0
    else round(nf.valor * nf.aliquota_cofins / 100, 2)
  end as valor_cofins_retido_31,
  case
    aliquota_cofins
    when 0 then 0
    else nf.aliquota_cofins
  end as aliquota_cofins_retido_32,
  case
    aliquota_inss
    when 0 then 0
    else nf.valor
  end as base_calculo_inss_33,
  case
    aliquota_inss
    when 0 then 0
    else round(nf.valor * nf.aliquota_inss / 100, 2)
  end as valor_inss_retido_34,
  case
    aliquota_inss
    when 0 then 0
    else nf.aliquota_inss
  end as aliquota_inss_retido_35,
  round(
    (aliquota_pis + aliquota_cofins + aliquota_csll) * nf.valor / 100,
    2
  ) as total_pis_cofins_csll_36
FROM
  notas_fiscais nf
  LEFT JOIN empresas e ON nf.empresa_id = e.id
  LEFT JOIN tomadores t ON nf.tomador_id = t.id
  LEFT JOIN enderecos en ON t.endereco_id = en.id
  LEFT JOIN cidades cid ON en.cidade_id = cid.id
WHERE
  nf.id IN (14989, 14984)
  AND nf.situacao IN ('CONCLUIDO', 'NOTA INTERNA DIGITADA')
SELECT
  t.documento AS tomador_cpf_cnpj_1,
  nf.id AS nf_id_2,
  nf.data_emissao::date AS nf_data_emissao_3,
  nf.valor AS nf_valor_4,
  ROUND(nf.aliquota_iss, 2) AS aliquota_iss_5,
  ROUND(nf.aliquota_iss * nf.valor / 100, 2) AS valor_iss_6,
  e.cnpj AS cnpj_prestador_7
FROM
  notas_fiscais nf
  LEFT JOIN empresas e ON nf.empresa_id = e.id
  LEFT JOIN tomadores t ON nf.tomador_id = t.id
WHERE
  nf.data_emissao::date BETWEEN '2024-07-01' AND '2024-07-31' -- Apenas notas fiscais emitidas em Julho/2024
  AND nf.numero_nfse IS NOT NULL -- Apenas notas fiscais que possuem número cadastrado
  AND nf.situacao IN ('CONCLUIDO', 'NOTA INTERNA DIGITADA') -- Apenas notas ativas
  AND nf.retem_iss = false -- Garante que não existam notas fiscais com retenção de ISS
	AND (nf.aliquota_ir + nf.aliquota_csll + nf.aliquota_pis + nf.aliquota_cofins + nf.aliquota_inss) = 0 -- Garante que não existam notas com retenção de impostos federais
	AND e.regime_tributario = 1 -- Garante que apenas notas fiscais de empresas do Simples Nacional sejam listadas
  AND nf.deleted_at IS NULL -- Garante que apenas notas fiscais não deletadas sejam listadas
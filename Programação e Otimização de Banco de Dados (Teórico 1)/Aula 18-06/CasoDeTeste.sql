----------------------
CASOS DE TESTE
----------------------
-- Consulta 1
 SELECT dt_movimento, vl_unitario
 FROM   estoque
 WHERE  id_empresa = 1000
  -- 590 ms   690

-- Consulta 2
  SELECT n.*, e.*
  FROM   nota n inner join estoque e ON
         n.id_empresa = e.id_empresa and
		 n.id_planilha = e.id_planilha
 WHERE  e.dt_movimento = '12/03/2007' and
        n.id_empresa = 1 and e.id_item = 2821

-- Consulta 3
SELECT *
FROM  estoque
WHERE dt_movimento >= '01/01/2007' and
      id_cfop = 5102 and id_item= 2821 and vl_unitario > 38
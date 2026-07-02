
 OTIMIZAÇÃO DE BANCO DE DADOS

 -- Casos de Teste
--1
SELECT * FROM dados WHERE id_numerico = 8899;
  -- 15s  115ms
--2
SELECT id_numerico, texto1 FROM dados 
WHERE id_literal = md5('8000');
  -- 1s 68ms  14s
--3
SELECT * FROM dados 
WHERE id_numerico between 49999 and 51229;
  -- 1s 14ms   211ms
--4
 SELECT u.nome, d.id_numerico, d.id_literal
 FROM   usuarios u INNER JOIN dados d ON
        u.id = d.idUsuario
 WHERE  d.id_numerico < 200 		
 -- 24s  132ms

  CREATE INDEX idx_um ON dados(texto1);
  DROP INDEX  idx_um;
  CREATE INDEX idx_um ON dados(id_numerico);

------ Banco de DADOS 2
  SELECT count(*) FROM nota  -- 429 628
  SELECT count(*) FROM estoque -- 1 221 151

----------------------
CASOS DE TESTE
----------------------
-- Consulta 1
 SELECT dt_movimento, vl_unitario
 FROM   estoque
 WHERE  id_empresa = 1000
  --422ms  --485ms  --388ms

-- Consulta 2
  SELECT n.*, e.*
  FROM   nota n inner join estoque e ON
         n.id_empresa = e.id_empresa and
		 n.id_planilha = e.id_planilha
 WHERE  e.dt_movimento = '12/03/2007' and
        n.id_empresa = 1 and e.id_item = 2821
--180ms   110ms  110ms

-- Consulta 3
SELECT *
FROM  estoque
WHERE dt_movimento >= '01/01/2007' and
      id_cfop = 5102 and id_item= 2821 and vl_unitario > 38
--344ms   135ms --126ms

 CREATE INDEX abc ON estoque(dt_movimento, id_cfop, id_item);
 drop index abc
  SELECT distinct dt_movimento FROM estoque  --1.619
  SELECT distinct id_cfop FROM estoque  --23
  SELECT distinct id_item FROM estoque  --26.412

CREATE INDEX abc ON estoque(id_item, dt_movimento, id_cfop);

  -- TRANSAÇÕES
 CREATE TABLE BANCO(
  conta integer primary key,
  agencia varchar(20) NOT NULL,
  saldo   numeric(10,2)
  );

  INSERT INTO banco(conta,agencia,saldo) VALUES
   (2311,'1689-85',900.34),
   (2229,'5474-99',11.34),
   (1211,'1004-11',750);

  BEGIN;
    UPDATE Banco SET saldo = 999 WHERE  conta = 2311;
	DELETE FROM Banco WHERE conta = 2229;
	UPDATE Banco SET saldo = 1000 WHERE conta = 2311;
	ROLLBACK;

    SELECT saldo FROM Banco WHERE conta = 2311;
	
  BEGIN;
    insert into banco values(4544,'Ag 98 -x',100);
    UPDATE Banco SET saldo = 1000 WHERE conta = 2311;
    UPDATE Banco SET saldo = 101 WHERE conta = 4544;
	savepoint s1;
    delete from banco where conta = 2311;
	select * from banco where conta = 2311;
	rollback to s1;
	
 SELECT * FROM Banco
	
	
   





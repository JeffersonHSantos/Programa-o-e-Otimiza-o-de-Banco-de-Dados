-- Exercícios Procedure/Function/Trigger

  
5- Faça uma function PLSQL para retornar a quantidade de consultas de um médico 
conforme período(data inicio - data fim) passado como parâmetro
 describe consulta

CREATE or replace FUNCTION f_exerc05 (varIdM NUMBER,varDI TIMESTAMP,
                                     varDF Consulta.data_hora%TYPE)
 RETURN NUMBER IS   
  varX NUMBER;
 BEGIN
     SELECT count(c.id_consulta) INTO varX
     FROM consulta c inner join medico m ON
          c.id_medico = m.id_medico
     WHERE m.id_medico = varIdM and 
           c.data_hora >= varDI and 
           c.data_hora <= varDF; 
  RETURN varX;   
 END;    
 -- EXecuta a Função
 SELECT f_exerc05(2,'01/03/2026','28/05/2026') FROM DUAL
 
  6- Faça um procedimento que apresente/print disponibilidade de um médico de 
  acordo com uma data e horário. Faça essa verifição de disponibilidade em 
  uma FUNÇÃO.
 CREATE or replace FUNCTION f_disponibilidadeMedico(varID MEDICO.id_medico%TYPE,
                                             varData CONSULTA.data_hora%TYPE)
 RETURN VARCHAR IS
     varAgenda  NUMBER;
     varResult  VARCHAR2(4);
 BEGIN    
    SELECT count(*) INTO varAgenda   
    FROM   medico m inner join consulta c ON
           m.id_Medico = c.id_medico   
    WHERE  m.id_medico = varID and c.data_hora = varData;
        
    IF(varAgenda >= 1) THEN
      varResult := 'NÃO';
    ELSE  
      varResult := 'SIM';
    END IF;  
   RETURN varResult;   
 END;     -- SELECT f_disponibilidadeMedico(2,'14/05/2026 20:13:06') From dual

CREATE OR REPLACE PROCEDURE p_agendaCons (vMedico MEDICO.id_medico%TYPE,
                                          vData_hora CONSULTA.data_hora%TYPE,
                                          vPac CONSULTA.ID_PACIENTE%TYPE)
IS
  varAgenda  VARCHAR2(4);
BEGIN
   varAgenda := f_disponibilidadeMedico(vMedico,vData_hora); -- chama FUNÇÃO  
   IF (varAgenda = 'SIM') THEN
     INSERT INTO Consulta(id_consulta,data_hora,status,id_paciente,id_medico) 
                  VALUES(geraId.nextval,vData_hora,'agendada',vPac,vMedico);
     DBMS_OUTPUT.PUT_LINE('Consulta Agendada!');
   ELSE
     DBMS_OUTPUT.PUT_LINE('SEM agenda para o período informado!');
   END IF;
END;
    
    SET SERVEROUTPUT ON;  -- Select * from consulta where id_paciente = 4
    EXEC  p_agendaCons(2,'29/05/2026 10:30:00',4);
    
  Criar sequencia para o ID automático da consulta
  CREATE SEQUENCE geraId
    start with 500
    increment by 1;
  
  ------------  BASE DE DADOS VENDAS ----------------
  --drop table produtos cascade constraints;    
create table produtos (
 codigo number not null,
 descricao varchar2(20),
 estoque number(7,2),
 precounitario number(7,2),
 primary key (codigo)
);

   insert into produtos values(1,'Computador',5,3700);
   insert into produtos values(2,'SmartPhone',2,1299);
   insert into produtos values(3,'MacBook',2,12000);
   insert into produtos values(4,'Impressora',10,499.89);

  --drop table vendas cascade constraints;  
  CREATE TABLE vendas(
   numero NUMBER PRIMARY KEY,
   valorProduto NUMBER NOT NULL,
   quantidade NUMBER,
   data DATE,
   parcelas NUMBER,   
   codigoProduto NUMBER,
   FOREIGN KEY (codigoProduto) REFERENCES produtos(codigo)
  );
 
 --  drop table parcelas cascade constraints; 
   CREATE TABLE parcelas(
   numero NUMBER,
   valorParcela NUMBER NOT NULL,
   dataVenc date NOT NULL,
   dataPagto date,
   nvenda NUMBER,
   FOREIGN KEY (nvenda) REFERENCES vendas(numero),
   PRIMARY KEY (numero,nvenda)
);
  --- Criar um Trigger que gera PARCELAS
  CREATE or replace TRIGGER t_geraParcelas
   AFTER INSERT ON VENDAS
   BEGIN
      INSERT INTO Parcelas(numero,valorParcela,dataVenc,Nvenda) 
                    VALUES();
   END;
   SELECT * FROM Parcelas
    
    
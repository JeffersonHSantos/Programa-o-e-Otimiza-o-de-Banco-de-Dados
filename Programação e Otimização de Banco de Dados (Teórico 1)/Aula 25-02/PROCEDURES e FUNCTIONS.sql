-- Exemplos de Blocos PLSQL

DECLARE
  varNome INT; --VARCHAR2(20);
BEGIN
  varNome := 'Joana';
  DBMS_OUTPUT.put_line('Olá seja bem vinda! ' || varNome);
  EXCEPTION -- seção de tratamento de erros
    when others then -- others é um tratamento genérico para erros
      raise_application_error(-20001,'Opa, temos um problema aqui!');
      --DBMS_OUTPUT.put_line('Opa, temos um problema aqui! ');
END;
  -- toda vez que logar no servidor preciso habilitar o DBMS
  SET SERVEROUTPUT ON;
  
-- exemplo de bloco com IF

DECLARE
  varNome varchar2(20); varIdade INT;
BEGIN
  varNome   := 'Joana'; varIdade  := 18;
  IF (varIdade > 18) THEN
    DBMS_OUTPUT.put_line('Tem mais de 18 anos ' || varNome || ' - ' || varIdade);
  ELSIF (varIdade < 18) THEN
    DBMS_OUTPUT.put_line('Tem menos de 18 anos ' || varNome || ' - ' || varIdade);
  ELSE
    DBMS_OUTPUT.put_line('Tem 18 anos ' || varNome || ' - ' || varIdade);
  END IF;
END;

-- exemplo de bloco c/ loop

DECLARE
  varNome varchar2(20); varIdade INT;
BEGIN
  varNome   := 'Joana'; varIdade  := 18;
  
  IF (varIdade >= 18) THEN
    DBMS_OUTPUT.put_line('É maior de idade ' || varNome || ' - ' || varIdade);
    FOR i in 1..2 LOOP
    DBMS_OUTPUT.put_line(i || 'já pode dirigir e beber!');
    END LOOP; 
  ELSE
    DBMS_OUTPUT.put_line(varNome || 'É menor de idade ' || varIdade);
  END IF;
  
END;


 -- exemplo de PROCEDURE
  CREATE or replace PROCEDURE p_exemplo1 (vNome VARCHAR2, idade INT) Is
  BEGIN -- seção executável
    IF (vNome is null) THEN
       DBMS_OUTPUT.put_line('Error - Informe um nome!');
    ELSE
       DBMS_OUTPUT.put_line('Olá =>' || vNome || ' Idade ' || idade);
    END IF;
  END;
  
    EXECUTE p_exemplo1('Juca',40);
  

-- Exercício
-- 1 - faça um procedimento para atualizar a carga horaria de um especialização
    CREATE or replace PROCEDURE p_exerc01 (varId NUMBER, varCH NUMBER) is
    BEGIN
        UPDATE  Especialidade
        set     ch = varCH
        where   id_especialidade = varID;
    END;
    
    EXEC p_exerc01(3, 999); select * from especialidade
    
    
-- 2 faça um procedure PLSQL para atualizar o status de uma consulta
  -- lembre-se que o status já está definido
  -- emita uma mensagem, caso o status passado como parâmetro é o mesmo
  
  select * from consulta
  
  Select status
  
  CREATE or replace PROCEDURE p_exerc02 (varId NUMBER, varStatus VARCHAR2) is
  
  varX varchar2(15);
    BEGIN
      IF (varStatus = 'agendada' or varStatus = 'realizada' or varStatus = 'cancelada') THEN
        select status 
        INTO varX 
        from consulta 
        where id_consulta = varId;
      
      if (varStatus <> varX)then 
        UPDATE  Consulta
        set     status = varStatus
        where   id_consulta = varId;
      ELSE
        DBMS_OUTPUT.put_line('A consulta já está com esse Status');
      END IF;
      ELSE
         DBMS_OUTPUT.put_line('Status DESCONHECIDO');
      END IF;
    END;

    EXEC p_exerc02(3,'agendada'); --select * from consulta
    
    
    -- Exercícios Procedure
  --3- Faça um procedure PLSQL para cadastrar uma nova consulta, informando 
  --paciente, médico, data, hora e valor. O status inicial será definido 
  --como 'agendada'. Garantir que:
  -- O paciente e o médico existem
  -- O médico não possui outra consulta no mesmo horário
  -- Se possuir gere uma Exception com uma mensagem
  
  CREATE or replace PROCEDURE p_exerc03 (varId CONSULTA.id_consulta%TYPE,
           varDH CONSULTA.data_hora%TYPE,  varValor CONSULTA.valor%TYPE,
           varOBS CONSULTA.obs%TYPE,varIdM CONSULTA.id_medico%TYPE,
           varIdP CONSULTA.id_paciente%TYPE)IS
   varContaM NUMBER;        varContaP NUMBER;   erro1 EXCEPTION;
   varHor  NUMBER;       erro2 EXCEPTION;
   BEGIN
     SELECT count(id_medico) INTO varContaM 
     FROM Medico WHERE id_medico = varIdM;
     
     SELECT count(id_paciente) INTO varContaP
     FROM Paciente WHERE id_paciente = varIdP;
     
     SELECT count(id_consulta) INTO varHor FROM Consulta 
       WHERE id_medico = varIdM and data_hora = varDH;       
     
    IF (varContaM <> 0 ) and (varContaP <> 0) THEN  
       IF (varHor = 0) THEN   
         INSERT INTO Consulta(id_consulta,data_hora,status,valor,obs,id_medico,
         id_paciente)VALUES(varId,varDH,'agendada',varValor,varOBS,varIdM,varIdP);
       ELSE
        raise erro2;
      END IF;  
    ELSE
      raise erro1; -- erro1 é uma variável do tipo Exception
    END IF;   
    EXCEPTION   -- area de Tratamento de Exceção
      WHEN erro1 THEN
        raise_application_error(-20001,'Verificar Médico ou Paciente!');  
      WHEN erro2 THEN
        raise_application_error(-20002,'Horário indisponível!');    
  END;
   EXEC p_exerc03(10,current_date,500,'pode atrasar',2,4);
   EXEC p_exerc03(11,current_date,500,'pode atrasar',12,4);--erro Medico
   EXEC p_exerc03(11,current_date,500,'pode atrasar',2,14);--erro Paciente
   EXEC p_exerc03(13,'14/05/26 20:15:06,000000000',500,'pode atrasar',2,1);--erro horário

   -- teste        select * from consulta where id_consulta = 10
   
  --- Exemplos de FUNCTIONS/Funções ------
Faça uma função que passado código do Médico retorne quantas especializações 
ele possui
CREATE or replace FUNCTION f_exemplo1 (varIdM NUMBER)
 RETURN NUMBER  IS  
 varX NUMBER;
 BEGIN
   SELECT count(me.id_Especialidade) INTO varX FROM MedEsp me inner join medico m 
          ON me.id_medico = m.id_medico WHERE m.id_medico = varIdM;
  RETURN varX;   
 END;
 
 -- executar uma função   
 
 SELECT f_exemplo1(5) FROM dual;
 
--4- Faça uma function PLSQL que passado o nº do procedimento, retorne a descrição deste procedimento
CREATE or replace FUNCTION f_exerc04 (varNumProc NUMBER)
 RETURN VARCHAR2 IS   
  varDesc VARCHAR2(30);
 BEGIN
     SELECT descricao INTO varDesc
     FROM procedimento WHERE id_procedimento = varNumProc; 
     RETURN varDesc;   
 END;    -- SELECT f_exerc04(3) FROM DUAL
    
    
--5- Faça uma function PLSQL para retornar a quantidade de consultas de um médico 
--conforme período(data inicio - data fim) passado como parâmetro




--6- Faça um procedimento que apresente/print disponibilidade de um médico
--de acordo com uma data e horário. faça essa verificação de disponibilidade em
--uma função

select * from consulta

CREATE or replace FUNCTION f_disponibilidadeMedico (varID MEDICO.id_medico%TYPE,
                                                    varData CONSULTA.data_hora%TYPE) 
return varchar is
    varAgenda NUMBER;
    varResult VARCHAR2(5);
BEGIN
  select count(*) INTO varAgenda
  from  medico m inner join consulta c ON
        m.id_medico = c.id_medico
  where m.id_medico = varID and c.data_hora = varData;   
  
  IF (varAgenda >= 1) then
      varResult := 'NÃO';
  ELSE
      varResult := 'SIM';
  END IF;
 RETURN varResult;
END; -- SELECT f_disponibilidadeMedico(2,'02/02/26 10:01:00') from dual

CREATE OR REPLACE PROCEDURE p_agendaCons (vMedico MEDICO.ID_MEDICO%TYPE, 
                                          vData_hora CONSULTA.DATA_HORA%TYPE, 
                                          vpac CONSULTA.id_paciente%TYPE)
IS
  varAgenda VARCHAR2(4);
BEGIN
  varAgenda := f_disponibilidadeMedico(vMedico, vData_hora); --chama função
  IF (varAgenda = 'SIM') THEN
    insert into consulta(id_consulta, data_hora, status, id_paciente, id_medico) 
                        VALUES(geraId.nextval,vData_hora,'agendada',vpac,vMedico);
    DBMS_OUTPUT.put_line('Consulta agendada!');
  ELSE
    DBMS_OUTPUT.put_line('SEM agenda para o periodo informado!');  
  END IF;
END; 
  -- select * from consulta
  exec p_agendaCons(2,'03/03/26 10:00:00',4)
  
  -- Criar sequencia para o ID automático da consulta
  CREATE SEQUENCE geraId
    start with 501
    increment by 1
    
  drop sequence geraId


  


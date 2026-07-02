-- Exercícios Procedure
3- Faça um procedure PLSQL para cadastrar uma nova consulta, informando 
paciente, médico, data, hora e valor. O status inicial será definido 
como 'agendada'. Garantir que:
 - O paciente e o médico existem
 - O médico não possui outra consulta no mesmo horário
    - Se possuir gere uma Exception com uma mensagem
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
4- Faça uma function PLSQL que passado o nº do procedimento, retorne a descrição 
    deste procedimento
CREATE or replace FUNCTION f_exerc04 (varNumProc NUMBER)
 RETURN VARCHAR2 IS   
  varDesc VARCHAR2(30);
 BEGIN
     SELECT descricao INTO varDesc
     FROM procedimento WHERE id_procedimento = varNumProc; 
     RETURN varDesc;   
 END;    -- SELECT f_exerc04(3) FROM DUAL
    
    
5- Faça uma function PLSQL para retornar a quantidade de consultas de um médico 
conforme período(data inicio - data fim) passado como parâmetro
  
   
   
   
   
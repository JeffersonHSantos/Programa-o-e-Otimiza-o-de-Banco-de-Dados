-- Exemplos de Blocos PLSQL
DECLARE 
  varNome INT; -- VARCHAR2(20);
BEGIN
  varNome := 'Joana';
  DBMS_OUTPUT.PUT_LINE('Olá seja bem vinda! ' || varNome);
  EXCEPTION -- seção de tratamento de erros
     WHEN OTHERS THEN  -- OTHERS é um tratamento genérico para erros
      raise_application_error(-20001,'Opa temos um problemas aqui!');
      --DBMS_OUTPUT.PUT_LINE('Opa temos um problemas aqui!');
END;
  -- todas vez que logar no servido preciso habilitar o DBMS
  SET SERVEROUTPUT ON;
  
-- Exemplo de bloco com IF
DECLARE
 varNome varchar2(20);  varIdade INT;
 BEGIN
   varNome := 'Joana';  varIdade := 18;
   IF (varIdade > 18) THEN
    DBMS_OUTPUT.PUT_LINE('Tem mais de 18 anos ' || varNome || ' - '|| varIdade);
   ELSIF (varIdade < 18) THEN
    DBMS_OUTPUT.PUT_LINE('Tem MENOS de 18 anos ' || varNome || ' - '|| varIdade);
   ELSE
    DBMS_OUTPUT.PUT_LINE('Tem 18 anos ' || varNome || ' - '|| varIdade);
   END IF;
 END;

-- Exemplo de Boloco com LOOP
DECLARE
 varNome varchar2(20);  varIdade INT;
 BEGIN
   varNome := 'Joana';  varIdade := 18;
   IF (varIdade >= 18) THEN
    DBMS_OUTPUT.PUT_LINE(varNome ||' é MAIOR de idade: ' || varIdade);
    FOR i in 1..2 LOOP
     DBMS_OUTPUT.PUT_LINE(i ||' já pode dirigir e beber! ');
    END LOOP;
   ELSE
    DBMS_OUTPUT.PUT_LINE(varNome ||' é MENOR de idade: ' || varIdade);
   END IF;
 END;
  -- Exemplo de PROCEDURE
  CREATE or replace PROCEDURE p_exemplo1 (vNome VARCHAR2, idade INT)IS
  BEGIN  -- seção executável
    IF (vNome is null) THEN
      DBMS_OUTPUT.put_line('Error - informe um nome! ');
    ELSE  
     DBMS_OUTPUT.put_line('Olá => ' || vNome || ' Idade '|| idade);
    END IF;
  END;

    EXECUTE p_exemplo1('Juca',40);

 Exercícios
  1- Faça um procedimento para atualizar a Carga Horária de um Especialização
    CREATE or replace PROCEDURE p_exerc01 (varId NUMBER, varCH NUMBER)IS
    BEGIN
       UPDATE Especialidade
       SET    ch = varCH
       WHERE  id_especialidade = varId;
    END;
       
      EXEC p_exerc01(3,480);   select * from especialidade

2- Faça um procedure PLSQL para atualizar o status de uma consulta.
   - lembre se que o status já está definido
   - emita uma mensagem, caso o status passado como parâmetro é o mesmo
   
  CREATE or replace PROCEDURE p_exerc02 (varId NUMBER, varStatus VARCHAR2)IS
    varX VARCHAR2(15);
   BEGIN
      IF (varStatus = 'agendada' or varStatus = 'realizada' or 
         varStatus = 'cancelada') THEN
         
         SELECT status INTO varX FROM Consulta WHERE id_consulta = varId;
         
       IF (varStatus <> varX) THEN  
         UPDATE  Consulta
         SET    status = varStatus
         WHERE  id_consulta = varId;
       ELSE  
         DBMS_OUTPUT.put_line ('A consulta já está com esse Status!');
       END IF; 
      ELSE
        DBMS_OUTPUT.put_line ('Status DESCONHECIDO!');
      END IF; 
    END;

    EXEC p_exerc02(3,'agendada');  -- select * from consulta


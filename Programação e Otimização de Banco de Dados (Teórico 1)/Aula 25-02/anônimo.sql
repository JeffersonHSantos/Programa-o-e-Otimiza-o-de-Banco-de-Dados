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


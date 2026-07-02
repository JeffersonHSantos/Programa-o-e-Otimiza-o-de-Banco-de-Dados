CREATE TABLE Usuarios(
  id  serial PRIMARY KEY,         
  nome   VARCHAR(30)
 );
 
CREATE TABLE Dados(
  id_numerico  INT,         
  id_literal   VARCHAR(32),
  texto1	   VARCHAR(40),  texto2	   VARCHAR(40),
  texto3	   VARCHAR(40),  texto4	   VARCHAR(40),
  texto5	   VARCHAR(40),  texto6	   VARCHAR(40),
  texto7	   VARCHAR(40),  texto8	   VARCHAR(40),
  idUsuario    INT,
  FOREIGN KEY(idUsuario) REFERENCES Usuarios(id)
  );

------------------
Povoa Usuários
------------------
CREATE OR REPLACE PROCEDURE povoaUsuarios(qtd INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    i INTEGER;
    j INTEGER;
    tamanho_nome INTEGER;
    nome_random TEXT;
BEGIN
    FOR i IN 1..qtd LOOP

        -- tamanho aleatório entre 5 e 12 caracteres
		-- serve para gerar um número aleatório que será usado como tamanho do nome.
		-- A função floor() remove a parte decimal, deixando apenas o inteiro.
        tamanho_nome := floor(random() * 8 + 5);

        nome_random := '';

        -- monta o nome letra por letra
        FOR j IN 1..tamanho_nome LOOP
            nome_random := nome_random || chr(floor(random() * 26 + 65)::INT);
				--26 são as letras do Alfabeto e 65 porque na tabela ASCII: 65 = A 66 = B
        END LOOP;

        INSERT INTO Usuarios(nome) VALUES(nome_random);

    END LOOP;
END;
$$;

-- executa procedimento
CALL povoaUsuarios (50000);

------------------
Povoa Dados
------------------
-- função para povoar a tabela
  CREATE or replace FUNCTION f_povoaDados()
  RETURNS VOID AS
  $$
  DECLARE
    i INTEGER;   texto VARCHAR(40); t INTEGER;   
  BEGIN
    i:= 1;    	texto := 'Lab. Banco de Dados UPF, 2026';
	SELECT max(id) INTO t FROM Usuarios;
	LOOP
	 INSERT INTO Dados(id_numerico,id_literal,texto1,texto2,
	                   texto3,texto4,texto5,texto6,texto7,texto8,idUsuario)
					   VALUES(i,MD5(i::TEXT),texto,texto,texto,
					   texto,texto,texto,texto,texto,
					   floor(random() * t + 1)
					   
					   );
	 EXIT WHEN (i >= 10);
	 i := i + 1;
	END LOOP;    
  END;
  $$
  language plpgsql;


   SELECT f_povoaDados();
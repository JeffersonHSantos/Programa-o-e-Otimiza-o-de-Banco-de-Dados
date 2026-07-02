  CREATE TABLE cliente  (
  rg    INT NOT NULL,
  nome  VARCHAR(40) NOT NULL,
  sexo  CHAR(1) NOT NULL,
  telefone VARCHAR(15),
  PRIMARY KEY (rg)
  );
   
  CREATE TABLE tipo_quarto  (
  id_tipo   INT NOT NULL,
  descricao VARCHAR(40) NOT NULL,
  valor     NUMERIC(9,2) NOT NULL,
   PRIMARY KEY (id_tipo)
  );
   
 CREATE TABLE quarto  (
  num_quarto INT NOT NULL,
  andar      VARCHAR(10),
  id_tipo    INT NOT NULL,
  status     CHAR(1) DEFAULT 'D' NOT NULL,
  PRIMARY KEY (num_quarto),
  CONSTRAINT fk_tipoQ FOREIGN KEY(id_tipo) REFERENCES tipo_quarto(id_tipo)
  );
   
   
 CREATE TABLE servico  (
  id_servico  INT NOT NULL,
  descricao   VARCHAR(60) NOT NULL,
  valor       NUMERIC(9,2) NOT NULL,
   PRIMARY KEY (id_servico)
  );
   
  CREATE TABLE reserva  (
  id_reserva INT NOT NULL,
  rg         INT NOT NULL,
  num_quarto INT NOT NULL,
  dt_reserva DATE NOT NULL,
  qtd_dias   INT NOT NULL,
  data_entrada DATE NOT NULL,
  status CHAR(1) DEFAULT 'A',
   PRIMARY KEY (id_reserva),
   FOREIGN KEY (rg) REFERENCES cliente (rg),
   FOREIGN KEY (num_quarto) REFERENCES quarto(num_quarto)
  );
   
  CREATE TABLE hospedagem  (
   id_hospedagem INT NOT NULL,
   rg            INT NOT NULL,
   num_quarto    INT NOT NULL,
   data_entrada  DATE NOT NULL,
   data_saida    DATE,
   status CHAR(1) NOT NULL,
    PRIMARY KEY (id_hospedagem),
    FOREIGN KEY (rg) REFERENCES cliente (rg),
    FOREIGN KEY (num_quarto) REFERENCES quarto (num_quarto)
  );
   
  CREATE TABLE atendimento  (
   id_atendimento INT NOT NULL,
   id_servico     INT NOT NULL,
   id_hospedagem  INT NOT NULL,
    PRIMARY KEY (id_atendimento),
    FOREIGN KEY (id_servico) REFERENCES servico (id_servico),
    FOREIGN KEY (id_hospedagem) REFERENCES hospedagem (id_hospedagem)
  );

  SELECT * FROM pg_user;

  -- criação de Usuários
  CREATE USER Brasil PASSWORD '123';
  CREATE USER Haiti PASSWORD '456';
  CREATE USER Escocia PASSWORD '789' 
                      valid until '12/06/2026 20:00:00';
  
  GRANT select,insert ON cliente,reserva TO Brasil;
  GRANT select ON quarto TO Brasil;

   GRANT select(nome) ON Cliente TO Escocia;


-- criar o grupo sócio
create role socio

grant all privileges ON all tables in schema public TO socio;

-- cria o usuário e já coloca no grupo Sócio
CREATE USER Carlo Password 'brasil' IN role socio;

-- altera o grupo com adição de um usuário
ALTER GROUP socio add user haiti;

-- listar os grupos e seus usuarios
SELECT		groname,usename
FROM		pg_group, pg_user
WHERE 		usesysid = any(grolist);


-- tirar o usuário do grupo
alter group socio drop user haiti;

-- pode conceder os mesmos privilégios que recebeu
grant insert, update ON cliente TO haiti with GRANT OPTION;



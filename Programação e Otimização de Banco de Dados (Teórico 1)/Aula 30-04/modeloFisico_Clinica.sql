-- TABELA MEDICO
CREATE TABLE MEDICO (
    id_medico        NUMBER(10) PRIMARY KEY,
    nome             VARCHAR2(50) NOT NULL,
    crm              VARCHAR2(10) UNIQUE NOT NULL,
    telefone         VARCHAR2(15),
    salario          NUMBER(10,2)
);

-- TABELA ESPECIALIDADE
CREATE TABLE ESPECIALIDADE (
    id_especialidade NUMBER(10) PRIMARY KEY,
    nome             VARCHAR2(50) NOT NULL,
    ch               NUMBER(4)   -- carga horária
);

-- TABELA MEDICO_ESPECIALIDADE
-- (Relacionamento N:N)
CREATE TABLE MEDESP (
    id_medico        NUMBER(10),
    id_especialidade NUMBER(10),
    dataConclusao    DATE,

    CONSTRAINT pk_medico_especialidade PRIMARY KEY (id_medico, id_especialidade),
    CONSTRAINT fk_me_medico FOREIGN KEY (id_medico)REFERENCES MEDICO(id_medico),
    CONSTRAINT fk_me_especialidade FOREIGN KEY (id_especialidade) REFERENCES ESPECIALIDADE(id_especialidade)
);

-- TABELA PACIENTE
CREATE TABLE PACIENTE (
    id_paciente NUMBER(10) PRIMARY KEY,
    nome        VARCHAR2(50) NOT NULL,
    cpf         VARCHAR2(14) UNIQUE NOT NULL,
    telefone    VARCHAR2(15),
    endereco    VARCHAR2(100),
    sexo        CHAR(1)
);

-- TABELA CONSULTA
CREATE TABLE CONSULTA (
    id_consulta NUMBER(10) PRIMARY KEY,
    data_hora   TIMESTAMP NOT NULL,
    status      VARCHAR2(20) CHECK (status IN ('agendada','realizada','cancelada')),
    valor       NUMBER(10,2),
    obs         VARCHAR2(200),
    id_paciente NUMBER(10) NOT NULL,
    id_medico   NUMBER(10) NOT NULL,

    CONSTRAINT fk_consulta_paciente FOREIGN KEY (id_paciente)REFERENCES PACIENTE(id_paciente),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (id_medico) REFERENCES MEDICO(id_medico)
);

-- TABELA PROCEDIMENTO
CREATE TABLE PROCEDIMENTO (
    id_procedimento NUMBER(10) PRIMARY KEY,
    nome_procd      VARCHAR2(100) NOT NULL,
    descricao       VARCHAR2(200),
    valor_procd     NUMBER(10,2),
    id_consulta     NUMBER(10) NOT NULL,

    CONSTRAINT fk_procedimento_consulta FOREIGN KEY (id_consulta)REFERENCES CONSULTA(id_consulta)
);
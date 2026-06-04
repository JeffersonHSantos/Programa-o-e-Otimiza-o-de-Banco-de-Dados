-- DEPARTAMENTOS
CREATE TABLE EAD4_DEPARTAMENTOS (
    CODIGO_DEPARTAMENTO NUMBER PRIMARY KEY,
    NOME VARCHAR2(100) NOT NULL
);

-- PROJETOS
CREATE TABLE EAD4_PROJETOS (
    CODIGO_PROJETO NUMBER PRIMARY KEY,
    NOME VARCHAR2(100) NOT NULL,
    DURACAO NUMBER NOT NULL
);

-- FUNCIONÁRIOS
CREATE TABLE EAD4_FUNCIONARIOS (
    CODIGO_FUNCIONARIO NUMBER PRIMARY KEY,
    NOME VARCHAR2(100) NOT NULL,
    CODIGO_DEPARTAMENTO NUMBER NOT NULL,
    NUMEROPROJETOS NUMBER DEFAULT 0,
    NUMERODEPENDENTES NUMBER DEFAULT 0,

    CONSTRAINT FK_FUNC_DEPTO
        FOREIGN KEY (CODIGO_DEPARTAMENTO)
        REFERENCES EAD4_DEPARTAMENTOS(CODIGO_DEPARTAMENTO)
);

-- DEPENDENTES
CREATE TABLE EAD4_DEPENDENTES (
    CODIGO_DEPENDENTE NUMBER PRIMARY KEY,
    NOME VARCHAR2(100) NOT NULL,
    CODIGO_FUNCIONARIO NUMBER NOT NULL,

    CONSTRAINT FK_DEP_FUNC
        FOREIGN KEY (CODIGO_FUNCIONARIO)
        REFERENCES EAD4_FUNCIONARIOS(CODIGO_FUNCIONARIO)
);

-- FUNCIONÁRIOS X PROJETOS
CREATE TABLE EAD4_FUNCIONARIOSPROJETOS (
    CODIGO_FUNCIONARIO NUMBER NOT NULL,
    CODIGO_PROJETO NUMBER NOT NULL,
    HORAS_ALOCADAS NUMBER NOT NULL,

    CONSTRAINT PK_FUNC_PROJ
        PRIMARY KEY (CODIGO_FUNCIONARIO, CODIGO_PROJETO),

    CONSTRAINT FK_FP_FUNC
        FOREIGN KEY (CODIGO_FUNCIONARIO)
        REFERENCES EAD4_FUNCIONARIOS(CODIGO_FUNCIONARIO),

    CONSTRAINT FK_FP_PROJ
        FOREIGN KEY (CODIGO_PROJETO)
        REFERENCES EAD4_PROJETOS(CODIGO_PROJETO)
);



-- Sequences para gerar os códigos automaticamente
CREATE SEQUENCE SEQ_EAD4_DEPARTAMENTO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_EAD4_PROJETO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_EAD4_FUNCIONARIO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_EAD4_DEPENDENTE
START WITH 1
INCREMENT BY 1;

-- ----------------------------------

INSERT INTO EAD4_DEPARTAMENTOS
VALUES (SEQ_EAD4_DEPARTAMENTO.NEXTVAL, 'TI');

INSERT INTO EAD4_DEPARTAMENTOS
VALUES (SEQ_EAD4_DEPARTAMENTO.NEXTVAL, 'RH');

INSERT INTO EAD4_DEPARTAMENTOS
VALUES (SEQ_EAD4_DEPARTAMENTO.NEXTVAL, 'Financeiro');

COMMIT;


-- Procedure incluiProjeto
CREATE OR REPLACE PROCEDURE incluiProjeto (
    p_nome IN VARCHAR2,
    p_duracao IN NUMBER
)
AS
BEGIN
    INSERT INTO EAD4_PROJETOS (
        CODIGO_PROJETO,
        NOME,
        DURACAO
    )
    VALUES (
        SEQ_EAD4_PROJETO.NEXTVAL,
        p_nome,
        p_duracao
    );

    COMMIT;
END;
/

EXEC incluiProjeto('Sistema ERP', 12);

-- Procedure incluiFuncionario
CREATE OR REPLACE PROCEDURE incluiFuncionario (
    p_nome IN VARCHAR2,
    p_codigo_departamento IN NUMBER
)
AS
BEGIN
    INSERT INTO EAD4_FUNCIONARIOS (
        CODIGO_FUNCIONARIO,
        NOME,
        CODIGO_DEPARTAMENTO,
        NUMEROPROJETOS,
        NUMERODEPENDENTES
    )
    VALUES (
        SEQ_EAD4_FUNCIONARIO.NEXTVAL,
        p_nome,
        p_codigo_departamento,
        0,
        0
    );

    COMMIT;
END;
/

EXEC incluiFuncionario('Jefferson', 1);
EXEC incluiFuncionario('Maria', 2);

-- Procedure incluiDependente
CREATE OR REPLACE PROCEDURE incluiDependente (
    p_nome IN VARCHAR2,
    p_codigo_funcionario IN NUMBER
)
AS
BEGIN

    INSERT INTO EAD4_DEPENDENTES (
        CODIGO_DEPENDENTE,
        NOME,
        CODIGO_FUNCIONARIO
    )
    VALUES (
        SEQ_EAD4_DEPENDENTE.NEXTVAL,
        p_nome,
        p_codigo_funcionario
    );

    UPDATE EAD4_FUNCIONARIOS
    SET NUMERODEPENDENTES = NUMERODEPENDENTES + 1
    WHERE CODIGO_FUNCIONARIO = p_codigo_funcionario;

    COMMIT;
END;
/

EXEC incluiDependente('Pedro', 1);
EXEC incluiDependente('Ana', 1);

-- Procedure incluiParticipacao
-- Regras: 
-- Insere participação
-- Atualiza NUMEROPROJETOS
-- Não permite ultrapassar 40 horas

CREATE OR REPLACE PROCEDURE incluiParticipacao (
    p_codigo_funcionario IN NUMBER,
    p_codigo_projeto IN NUMBER,
    p_horas IN NUMBER
)
AS
    v_total_horas NUMBER;
BEGIN

    SELECT NVL(SUM(HORAS_ALOCADAS),0)
    INTO v_total_horas
    FROM EAD4_FUNCIONARIOSPROJETOS
    WHERE CODIGO_FUNCIONARIO = p_codigo_funcionario;

    IF (v_total_horas + p_horas) > 40 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Funcionario ultrapassaria o limite de 40 horas.'
        );
    END IF;

    INSERT INTO EAD4_FUNCIONARIOSPROJETOS (
        CODIGO_FUNCIONARIO,
        CODIGO_PROJETO,
        HORAS_ALOCADAS
    )
    VALUES (
        p_codigo_funcionario,
        p_codigo_projeto,
        p_horas
    );

    UPDATE EAD4_FUNCIONARIOS
    SET NUMEROPROJETOS = NUMEROPROJETOS + 1
    WHERE CODIGO_FUNCIONARIO = p_codigo_funcionario;

    COMMIT;
END;
/

-- inserções válidas
EXEC incluiProjeto('Projeto A', 6);
EXEC incluiProjeto('Projeto B', 8);
EXEC incluiProjeto('Projeto C', 4);

EXEC incluiParticipacao(1,1,15);
EXEC incluiParticipacao(1,2,10);
EXEC incluiParticipacao(1,3,10);

-- inserção inválida - ORA-20001: Funcionario ultrapassaria o limite de 40 horas.
EXEC incluiParticipacao(1,2,10);

SELECT * FROM EAD4_FUNCIONARIOS;
SELECT * FROM EAD4_DEPENDENTES;
SELECT * FROM EAD4_PROJETOS;
SELECT * FROM EAD4_FUNCIONARIOSPROJETOS;


-- Total de horas trabalhadas por um funcionário
CREATE OR REPLACE FUNCTION fn_total_horas_funcionario (
    p_codigo_funcionario IN NUMBER
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN

    SELECT NVL(SUM(HORAS_ALOCADAS), 0)
    INTO v_total
    FROM EAD4_FUNCIONARIOSPROJETOS
    WHERE CODIGO_FUNCIONARIO = p_codigo_funcionario;

    RETURN v_total;

END;
/

SELECT fn_total_horas_funcionario(1)
FROM DUAL;

-- Número de dependentes de um funcionário
CREATE OR REPLACE FUNCTION fn_num_dependentes (
    p_codigo_funcionario IN NUMBER
)
RETURN NUMBER
AS
    v_qtd NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_qtd
    FROM EAD4_DEPENDENTES
    WHERE CODIGO_FUNCIONARIO = p_codigo_funcionario;

    RETURN v_qtd;

END;
/

SELECT fn_num_dependentes(1)
FROM DUAL;

-- Dados de um projeto pelo código
CREATE OR REPLACE FUNCTION fn_dados_projeto (
    p_codigo_projeto IN NUMBER
)
RETURN VARCHAR2
AS
    v_dados VARCHAR2(200);
BEGIN

    SELECT
        'Código: ' || CODIGO_PROJETO ||
        ' | Nome: ' || NOME ||
        ' | Duração: ' || DURACAO
    INTO v_dados
    FROM EAD4_PROJETOS
    WHERE CODIGO_PROJETO = p_codigo_projeto;

    RETURN v_dados;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Projeto não encontrado';
END;
/

SELECT fn_dados_projeto(1)
FROM DUAL;

-- Número de projetos em que um departamento participa
CREATE OR REPLACE FUNCTION fn_projetos_departamento (
    p_codigo_departamento IN NUMBER
)
RETURN NUMBER
AS
    v_qtd NUMBER;
BEGIN

    SELECT COUNT(DISTINCT FP.CODIGO_PROJETO)
    INTO v_qtd
    FROM EAD4_FUNCIONARIOS F
    INNER JOIN EAD4_FUNCIONARIOSPROJETOS FP
        ON F.CODIGO_FUNCIONARIO = FP.CODIGO_FUNCIONARIO
    WHERE F.CODIGO_DEPARTAMENTO = p_codigo_departamento;

    RETURN v_qtd;

END;
/

SELECT fn_projetos_departamento(1)
FROM DUAL;

SELECT
    CODIGO_FUNCIONARIO,
    NOME,
    fn_total_horas_funcionario(CODIGO_FUNCIONARIO) AS TOTAL_HORAS,
    fn_num_dependentes(CODIGO_FUNCIONARIO) AS TOTAL_DEPENDENTES
FROM EAD4_FUNCIONARIOS;




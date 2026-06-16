SET SERVEROUTPUT ON;

-- 1. Criação da Tabela de Produtos
CREATE TABLE EAD5_Produtos (
    CodigoProduto INT PRIMARY KEY,
    descricao VARCHAR2(100),
    estoque_minimo INT,
    estoque_atual INT,
    preco NUMBER(10, 2)
);

-- 2. Criação da Tabela de Entradas (Estoque entrando)
CREATE TABLE EAD5_Entradas (
    NumeroNota INT,
    CodigoProduto INT,
    quantidade INT,
    PRIMARY KEY (NumeroNota, CodigoProduto),
    FOREIGN KEY (CodigoProduto) REFERENCES EAD5_Produtos(CodigoProduto)
);

-- 3. Criação da Tabela de Vendas (Estoque saindo)
CREATE TABLE EAD5_Vendas (
    NumeroNota INT,
    CodigoProduto INT,
    quantidade INT,
    PRIMARY KEY (NumeroNota, CodigoProduto),
    FOREIGN KEY (CodigoProduto) REFERENCES EAD5_Produtos(CodigoProduto)
);

-- 4. Criação da Tabela de Pedidos (Pedidos automáticos de compra)
CREATE TABLE EAD5_Pedidos (
    NumeroPedido INT PRIMARY KEY,
    CodigoProduto INT,
    quantidade INT,
    FOREIGN KEY (CodigoProduto) REFERENCES EAD5_Produtos(CodigoProduto)
);

-- 5. Criação da Sequence para gerar o número do pedido automaticamente
CREATE SEQUENCE seq_numero_pedido START WITH 1 INCREMENT BY 1;



-- Verifica se já existe um pedido ativo para o produto
CREATE OR REPLACE FUNCTION temPedido(p_codigo_produto IN INT) 
RETURN BOOLEAN IS
    v_total INT;
BEGIN
    -- Conta quantos registros esse produto possui na tabela de pedidos
    SELECT COUNT(*) INTO v_total 
    FROM EAD5_Pedidos 
    WHERE CodigoProduto = p_codigo_produto;
    
    -- Se a contagem for maior que zero, significa que o pedido já existe
    IF v_total > 0 THEN
        RETURN TRUE;   -- Retorna Verdadeiro (já tem pedido)
    ELSE
        RETURN FALSE;  -- Retorna Falso (não tem pedido)
    END IF;
END;
/


-- Requisito 1: Atualizar estoque na Entrada de Produtos (Acréscimo)
CREATE OR REPLACE TRIGGER trg_atualiza_estoque_entrada
AFTER INSERT ON EAD5_Entradas
FOR EACH ROW
BEGIN
    -- Soma a quantidade recém-inserida ao estoque atual do produto correspondente
    UPDATE EAD5_Produtos
    SET estoque_atual = estoque_atual + :NEW.quantidade
    WHERE CodigoProduto = :NEW.CodigoProduto;
END;
/


-- Requisito 2: Atualizar estoque na Venda de Produtos (Decréscimo)
-- Requisito 3: Gerar pedido automático se o estoque estiver abaixo do mínimo
CREATE OR REPLACE TRIGGER trg_atualiza_estoque_venda
AFTER INSERT ON EAD5_Vendas
FOR EACH ROW
DECLARE
    v_estoque_atual  INT;
    v_estoque_minimo INT;
    v_qtd_comprar    INT;
BEGIN
    -- [REQUISITO 2]: Subtrai as unidades vendidas do saldo da tabela mestre
    UPDATE EAD5_Produtos
    SET estoque_atual = estoque_atual - :NEW.quantidade
    WHERE CodigoProduto = :NEW.CodigoProduto;

    -- [REQUISITO 3]: Consulta o novo saldo e o estoque mínimo estipulado para o produto
    SELECT estoque_atual, estoque_minimo
    INTO v_estoque_atual, v_estoque_minimo
    FROM EAD5_Produtos
    WHERE CodigoProduto = :NEW.CodigoProduto;

    -- Condição: O estoque atual ficou abaixo do mínimo tolerável?
    IF v_estoque_atual < v_estoque_minimo THEN
        
        -- Condição Auxiliar: A nossa função confirmou que NÃO (NOT) existe pedido aberto?
        IF NOT temPedido(:NEW.CodigoProduto) THEN
            
            -- Calcula a quantidade necessária para cobrir o buraco do estoque mais uma margem de segurança
            v_qtd_comprar := (v_estoque_minimo - v_estoque_atual) + 10; 
            
            -- Realiza a inserção do pedido usando a SEQUENCE para gerar a chave primária
            INSERT INTO EAD5_Pedidos (NumeroPedido, CodigoProduto, quantidade)
            VALUES (seq_numero_pedido.NEXTVAL, :NEW.CodigoProduto, v_qtd_comprar);
            
        END IF;
        
    END IF;
END;
/


-- ==============================================================================
-- TESTE: Inserindo um produto inicial para a simulação
-- ==============================================================================

INSERT INTO EAD5_Produtos (CodigoProduto, descricao, estoque_minimo, estoque_atual, preco)
VALUES (999, 'Fone de Ouvido Bluetooth', 10, 15, 250.00);

-- Confirma a gravação dos dados no banco
COMMIT;

SELECT * FROM EAD5_Produtos;

-- ==============================================================================
-- TESTE REQUISITO 1: Entrada de mercadoria (Estoque deve ir de 15 para 20)
-- ==============================================================================

INSERT INTO EAD5_Entradas (NumeroNota, CodigoProduto, quantidade)
VALUES (1001, 999, 5);

-- Verifique se o estoque atual do produto mudou sozinho para 20:
SELECT CodigoProduto, descricao, estoque_atual FROM EAD5_Produtos WHERE CodigoProduto = 999;

-- ==============================================================================
-- TESTE REQUISITO 2 e 3: Venda e disparo do Alerta Crítico de Compra
-- ==============================================================================

INSERT INTO EAD5_Vendas (NumeroNota, CodigoProduto, quantidade)
VALUES (5001, 999, 14);

-- Verificação A: O estoque atual do produto caiu para 6?
SELECT CodigoProduto, descricao, estoque_atual, estoque_minimo 
FROM EAD5_Produtos 
WHERE CodigoProduto = 999;

-- ==============================================================================
-- VERIFICAÇÃO FINAL: O banco de dados gerou o pedido sozinho?
-- ==============================================================================

SELECT * FROM EAD5_Pedidos;








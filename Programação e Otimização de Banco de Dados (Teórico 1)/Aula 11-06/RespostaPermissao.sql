SET SERVEROUTPUT ON;

-- ==============================================================================
-- QUESTÃO 1: Como DBA, crie os grupos/roles - papeis (Gerente, Camareira e Atendente).
-- Depois crie os respectivos usuários, conforme os papeis: 
-- Gerente (usuário: Ger); Camareira (usuário: Gover01); Atendente (usuários: user01 e user02).
-- ==============================================================================

-- 1.1. Criação dos Papéis (Roles)
CREATE ROLE Gerente;
CREATE ROLE Camareira;
CREATE ROLE Atendente;

-- 1.2. Criação dos Usuários (Defina as senhas conforme sua política de segurança)
CREATE USER Ger IDENTIFIED BY "SenhaGer123";
CREATE USER Gover01 IDENTIFIED BY "SenhaGov123";
CREATE USER user01 IDENTIFIED BY "SenhaUser01";
CREATE USER user02 IDENTIFIED BY "SenhaUser02";

-- 1.3. Concessão mútua de privilégio de conexão básico (CREATE SESSION) para os usuários conseguirem logar
GRANT CREATE SESSION TO Ger, Gover01, user01, user02;

-- 1.4. Atribuição dos papéis (Roles) aos respectivos usuários
GRANT Gerente TO Ger;
GRANT Camareira TO Gover01;
GRANT Atendente TO user01, user02;


-- ==============================================================================
-- QUESTÃO 2: Crie uma política de segurança, concedendo autoridade aos seguintes papéis:
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- a) Conceder permissão para o papel Gerente acessar todas as tabelas e este 
--    conceder as mesmas permissões para outros usuários.
-- ------------------------------------------------------------------------------
-- Nota no Oracle: Para dar acesso total a todas as tabelas do schema atual com a 
-- opção de repasse (WITH GRANT OPTION), o comando deve especificar as tabelas 
-- ou usar privilégios de sistema como ANY TABLE caso o DBA aplique globalmente. 
-- Exemplo abaixo simulando as tabelas do contexto "Hotel":

GRANT SELECT, INSERT, UPDATE, DELETE ON cliente TO Gerente WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON reserva TO Gerente WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON hospedagem TO Gerente WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON quarto TO Gerente WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON atendimento TO Gerente WITH GRANT OPTION;


-- ------------------------------------------------------------------------------
-- b) Conceder permissão para o papel Atendente consultar, inserir e atualizar 
--    dados das tabelas cliente, reserva, hospedagem, quarto e atendimento.
-- ------------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE ON cliente TO Atendente;
GRANT SELECT, INSERT, UPDATE ON reserva TO Atendente;
GRANT SELECT, INSERT, UPDATE ON hospedagem TO Atendente;
GRANT SELECT, INSERT, UPDATE ON quarto TO Atendente;
GRANT SELECT, INSERT, UPDATE ON atendimento TO Atendente;


-- ------------------------------------------------------------------------------
-- c) Conceder permissão para o papel Camareira consultar apenas os nomes dos clientes.
-- ------------------------------------------------------------------------------
-- Nota: No Oracle, a restrição de coluna direta no GRANT funciona para INSERT, UPDATE e REFERENCES.
-- Para SELECT restrito a colunas específicas, a boa prática recomendada é criar uma VIEW.

-- Criando a VIEW de segurança:
CREATE OR REPLACE VIEW vw_clientes_camareira AS 
SELECT nome_cliente FROM cliente;

-- Concedendo a permissão de leitura na VIEW para o papel:
GRANT SELECT ON vw_clientes_camareira TO Camareira;


-- ------------------------------------------------------------------------------
-- d) Conceder permissões e depois retira uma delas do usuário user02 (a seu critério).
-- ------------------------------------------------------------------------------
-- Passo 1: Concedendo um privilégio direto ao user02 (ex: criar tabelas temporárias ou uma role extra)
GRANT CREATE TABLE TO user02;

-- Passo 2: Revogando a permissão concedida criteriosamente
REVOKE CREATE TABLE FROM user02;

-- FIM DO SCRIPT
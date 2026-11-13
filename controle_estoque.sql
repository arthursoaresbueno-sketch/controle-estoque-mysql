
-- =====================================================
-- PROJETO: CONTROLE DE ESTOQUE
-- BANCO DE DADOS: controle_estoque
-- TECNOLOGIA: MySQL
-- =====================================================

-- 1. CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE controle_estoque;
USE controle_estoque;


-- =====================================================
-- 2. CRIAÇÃO DAS TABELAS
-- =====================================================

-- TABELA DE CATEGORIAS

CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL
);


-- TABELA DE FORNECEDORES

CREATE TABLE fornecedor (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);


-- TABELA DE PRODUTOS

CREATE TABLE produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    id_categoria INT,
    id_fornecedor INT,

    FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),

    FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor(id_fornecedor)
);


-- TABELA DE MOVIMENTAÇÕES DO ESTOQUE

CREATE TABLE movimentacao_estoque (
    id_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT NOT NULL,
    tipo ENUM('ENTRADA', 'SAIDA') NOT NULL,
    quantidade INT NOT NULL,
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
);


-- =====================================================
-- 3. RESTRIÇÕES DE INTEGRIDADE (CHECK)
-- =====================================================

-- IMPEDIR PREÇOS NEGATIVOS

ALTER TABLE produto
ADD CONSTRAINT chk_produto_preco
CHECK (preco >= 0);


-- IMPEDIR QUANTIDADES ZERO OU NEGATIVAS

ALTER TABLE movimentacao_estoque
ADD CONSTRAINT chk_mov_quantidade
CHECK (quantidade > 0);


-- =====================================================
-- 4. INSERÇÃO DOS DADOS
-- =====================================================

-- CATEGORIAS

INSERT INTO categoria (nome) VALUES
('Eletrônicos'),
('Informática'),
('Alimentos'),
('Roupas'),
('Acessórios');


-- FORNECEDORES

INSERT INTO fornecedor (nome, telefone, email) VALUES
('Tech Distribuidora', '51999990001', 'tech@email.com'),
('Alimentos Sul', '51999990002', 'alimentos@email.com'),
('Moda Brasil', '51999990003', 'moda@email.com'),
('Info Center', '51999990004', 'info@email.com'),
('Acessórios RS', '51999990005', 'acessorios@email.com');


-- PRODUTOS

INSERT INTO produto (nome, preco, id_categoria, id_fornecedor) VALUES
('Notebook', 3500.00, 2, 1),
('Mouse', 80.00, 2, 4),
('Camiseta', 59.90, 4, 3),
('Arroz 5kg', 28.50, 3, 2),
('Fone Bluetooth', 150.00, 1, 5),
('Webcam', 120.00, 2, 4);


-- MOVIMENTAÇÕES DO ESTOQUE

INSERT INTO movimentacao_estoque
(id_produto, tipo, quantidade) VALUES
(1, 'ENTRADA', 20),
(1, 'SAIDA', 3),
(2, 'ENTRADA', 50),
(2, 'SAIDA', 10),
(3, 'ENTRADA', 30),
(4, 'ENTRADA', 40),
(4, 'SAIDA', 5),
(5, 'ENTRADA', 15);


-- =====================================================
-- 5. CONSULTAS DE ESTOQUE
-- =====================================================

-- ESTOQUE ATUAL POR PRODUTO

SELECT
    p.nome,
    SUM(
        CASE
            WHEN m.tipo = 'ENTRADA' THEN m.quantidade
            WHEN m.tipo = 'SAIDA' THEN -m.quantidade
        END
    ) AS estoque_atual
FROM produto p
INNER JOIN movimentacao_estoque m
    ON p.id_produto = m.id_produto
GROUP BY p.id_produto, p.nome;


-- CONSULTA DE PRODUTOS, CATEGORIAS E FORNECEDORES

SELECT
    p.nome AS produto,
    c.nome AS categoria,
    f.nome AS fornecedor,
    p.preco
FROM produto p
INNER JOIN categoria c
    ON p.id_categoria = c.id_categoria
INNER JOIN fornecedor f
    ON p.id_fornecedor = f.id_fornecedor;


-- RELATÓRIO DE ESTOQUE COM CATEGORIA E FORNECEDOR

SELECT
    p.nome AS produto,
    c.nome AS categoria,
    f.nome AS fornecedor,
    SUM(
        CASE
            WHEN m.tipo = 'ENTRADA' THEN m.quantidade
            WHEN m.tipo = 'SAIDA' THEN -m.quantidade
        END
    ) AS estoque_atual
FROM produto p
INNER JOIN categoria c
    ON p.id_categoria = c.id_categoria
INNER JOIN fornecedor f
    ON p.id_fornecedor = f.id_fornecedor
INNER JOIN movimentacao_estoque m
    ON p.id_produto = m.id_produto
GROUP BY p.id_produto, p.nome, c.nome, f.nome
ORDER BY estoque_atual ASC;


-- PRODUTOS COM ESTOQUE ABAIXO DE 20 UNIDADES

SELECT
    p.nome AS produto,
    SUM(
        CASE
            WHEN m.tipo = 'ENTRADA' THEN m.quantidade
            WHEN m.tipo = 'SAIDA' THEN -m.quantidade
        END
    ) AS estoque_atual
FROM produto p
INNER JOIN movimentacao_estoque m
    ON p.id_produto = m.id_produto
GROUP BY p.id_produto, p.nome
HAVING estoque_atual < 20;


-- =====================================================
-- 6. VIEW: ESTOQUE ATUAL
-- =====================================================

CREATE OR REPLACE VIEW view_estoque_atual AS
SELECT
    p.id_produto,
    p.nome AS produto,
    c.nome AS categoria,
    f.nome AS fornecedor,

    COALESCE(
        SUM(
            CASE
                WHEN m.tipo = 'ENTRADA' THEN m.quantidade
                WHEN m.tipo = 'SAIDA' THEN -m.quantidade
            END
        ), 0
    ) AS estoque_atual

FROM produto p
INNER JOIN categoria c
    ON p.id_categoria = c.id_categoria
INNER JOIN fornecedor f
    ON p.id_fornecedor = f.id_fornecedor
LEFT JOIN movimentacao_estoque m
    ON p.id_produto = m.id_produto

GROUP BY
    p.id_produto,
    p.nome,
    c.nome,
    f.nome;


-- CONSULTAR ESTOQUE ATUAL

SELECT * FROM view_estoque_atual;


-- =====================================================
-- 7. VIEW: PRODUTOS COM ESTOQUE BAIXO
-- =====================================================

CREATE OR REPLACE VIEW view_estoque_baixo AS
SELECT *
FROM view_estoque_atual
WHERE estoque_atual < 20;


-- CONSULTAR PRODUTOS COM ESTOQUE BAIXO

SELECT * FROM view_estoque_baixo;


-- =====================================================
-- 8. ESTRUTURA DAS TABELAS
-- =====================================================

DESCRIBE categoria;
DESCRIBE fornecedor;
DESCRIBE produto;
DESCRIBE movimentacao_estoque;


-- =====================================================
-- 9. VALOR TOTAL DO ESTOQUE POR PRODUTO
-- =====================================================

SELECT
    produto,
    estoque_atual,
    preco,
    (estoque_atual * preco) AS valor_total
FROM (
    SELECT
        p.nome AS produto,
        p.preco,
        v.estoque_atual
    FROM produto p
    INNER JOIN view_estoque_atual v
        ON p.id_produto = v.id_produto
) AS relatorio;


-- =====================================================
-- 10. VALOR TOTAL DE TODO O ESTOQUE
-- =====================================================

SELECT
    SUM(estoque_atual * preco) AS valor_total_estoque
FROM view_estoque_atual v
INNER JOIN produto p
    ON v.id_produto = p.id_produto;


-- =====================================================
-- FIM DO PROJETO
-- =====================================================

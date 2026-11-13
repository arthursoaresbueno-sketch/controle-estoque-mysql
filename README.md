# Controle de Estoque — MySQL

Projeto de banco de dados relacional desenvolvido para praticar SQL e gerenciamento de estoque.

## Sobre o projeto

O sistema permite registrar produtos, categorias, fornecedores e movimentações de estoque, calculando automaticamente a quantidade disponível de cada produto por meio das entradas e saídas registradas.

## Tecnologias utilizadas

- MySQL
- SQL
- MySQL Workbench

## Estrutura do banco de dados

O projeto possui quatro tabelas principais:

| Tabela | Descrição |
|---|---|
| `categoria` | Armazena as categorias dos produtos |
| `fornecedor` | Armazena os dados dos fornecedores |
| `produto` | Registra os produtos, preços e relacionamentos |
| `movimentacao_estoque` | Registra entradas e saídas de produtos |

## Funcionalidades

- Cadastro de categorias, fornecedores e produtos.
- Registro de entradas e saídas de estoque.
- Cálculo automático do estoque atual.
- Identificação de produtos com estoque baixo.
- Consulta de produtos com suas categorias e fornecedores.
- Cálculo do valor total do estoque.
- Validação de preços e quantidades com restrições `CHECK`.

## Recursos SQL utilizados

- `CREATE DATABASE` e `CREATE TABLE`
- `INSERT INTO` e `SELECT`
- `PRIMARY KEY` e `FOREIGN KEY`
- `INNER JOIN` e `LEFT JOIN`
- `GROUP BY`, `HAVING` e `ORDER BY`
- `SUM`, `CASE` e `COALESCE`
- `CREATE VIEW`
- `ALTER TABLE` e `CHECK`

## Como executar

1. Instale o MySQL Server e o MySQL Workbench.
2. Abra o arquivo `controle_estoque.sql`.
3. Execute o script em uma instalação limpa do MySQL.
4. Consulte as tabelas e VIEWs para visualizar os resultados.

**Requisito:** MySQL 8.0.16 ou superior para aplicação das restrições `CHECK`.

Atenção: o script cria o banco `controle_estoque`. Execute-o em uma instalação na qual esse banco ainda não exista.

## Resultados esperados

O projeto utiliza seis produtos de exemplo.

O estoque é calculado considerando:

- Entradas: adicionam unidades ao estoque.
- Saídas: subtraem unidades do estoque.

O valor total do estoque calculado com os dados iniciais é de **R$ 67.744,50**.

## Aprendizados

Durante o desenvolvimento, foram praticados conceitos como criação de tabelas, relacionamentos entre elas por meio de chaves estrangeiras, consultas SQL, cálculos, criação de VIEWs e validação dos dados.

O desenvolvimento contou com apoio de ferramentas de inteligência artificial como recurso de estudo e orientação, com execução e testes práticos no MySQL Workbench.

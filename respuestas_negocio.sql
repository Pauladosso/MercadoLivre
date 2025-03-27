1-

SELECT
    usuario.id_usuario
  , usuario.nome
  , usuario.email
  , usuario.data_nascimento
  , SUM(fpi.preco_total) AS total_vendas
FROM dim_usuario AS usuario
JOIN fato_pedido_itens pedido_itens
  ON usuario.id_usuario = pedido_itens.id_usuario
JOIN fato_pagamentos fp
  ON pedido_itens.id_pedido = fp.id_pedido
WHERE MONTH(usuario.data_nascimento) = MONTH(CURRENT_DATE)  -- Filtra aniversariantes do dia
  AND DAY(usuario.data_nascimento) = DAY(CURRENT_DATE)
  AND pedido_itens.data_pedido BETWEEN '2020-01-01' AND '2020-01-31'
GROUP BY usuario.id_usuario, usuario.nome, usuario.email, usuario.data_nascimento
HAVING SUM(pedido_itens.preco_total) > 1500;

------------------------------------------------------------------------------------------

2-

SELECT 
      YEAR(pedido_itens.data_pedido) AS ano
    , MONTH(pedido_itens.data_pedido) AS mes
    , usuario.nome
    , usuario.sobrenome
    , COUNT(pedido_itens.id_pedido) AS num_vendas
    , SUM(pedido_itens.quantidade) AS num_produtos_vendidos
    , SUM(pedido_itens.preco_total) AS valor_total_transacionado
FROM fato_pedido_itens AS pedido_itens
JOIN dim_usuario AS usuario
  ON pedido_itens.id_usuario = usuario.id_usuario
JOIN dim_item AS item
  ON pedido_itens.id_item = item.id_item
JOIN dim_categoria AS categoria
  ON item.id_categoria = categoria.id_categoria
WHERE categoria.nome_categoria = 'Celulares'
  AND pedido_itens.data_pedido BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY YEAR(pedido_itens.data_pedido), MONTH(pedido_itens.data_pedido), usuario.id_usuario, usuario.nome, usuario.sobrenome
ORDER BY valor_total_transacionado DESC
LIMIT 5;

------------------------------------------------------------------------------------------

3-

--Criação da tabela de snapshot
CREATE TABLE snapshot_item_status (
    id_item BIGINT,
    data_snapshot DATE,
    preco DECIMAL(10, 2),
    status VARCHAR(50),
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_item, data_snapshot),
    FOREIGN KEY (id_item) REFERENCES dim_item(id_item)
);

--Criação da Stored Procedure
DELIMITER $$

CREATE PROCEDURE atualizar_snapshot_item_status()
BEGIN
    -- Excluir registros do dia atual, caso existam
    DELETE FROM snapshot_item_status WHERE data_snapshot = CURRENT_DATE;

    -- Inserir os dados do item (preço e status) para o final do dia atual
    INSERT INTO snapshot_item_status (id_item, data_snapshot, preco, status)
    SELECT 
        di.id_item,
        CURRENT_DATE AS data_snapshot,
        di.preco,
        di.status
    FROM dim_item di;
    
END $$

DELIMITER ;

-- Agendamento da Stored Procedure
CREATE EVENT atualizar_snapshot_diario
ON SCHEDULE EVERY 1 DAY
STARTS '2023-03-25 23:59:59'
DO
    CALL atualizar_snapshot_item_status();

------------------------------------------------------------------------------------------

3- (Versão BigQuery)

-- Criação da Stored Procedure

CREATE OR REPLACE PROCEDURE `meu_projeto.minha_base.atualizar_snapshot_item_status`()
BEGIN
  -- Excluir registros do snapshot do dia atual
  DELETE FROM `meu_projeto.minha_base.snapshot_item_status`
  WHERE data_snapshot = CURRENT_DATE();

  -- Inserir os dados do item (preço e status) na snapshot do dia atual
  INSERT INTO `meu_projeto.minha_base.snapshot_item_status` (id_item, data_snapshot, preco, status)
  SELECT 
      id_item,
      CURRENT_DATE() AS data_snapshot,
      preco,
      status
  FROM `meu_projeto.minha_base.dim_item`;
END;

-- Criação da tabela de snapshot 

CREATE TABLE IF NOT EXISTS `meu_projeto.minha_base.snapshot_item_status` (
    id_item INT64,
    data_snapshot DATE,
    preco FLOAT64,
    status STRING
);

-- Agendamento de execução automática

No BigQuery Console -> aba Scheduled Queries (Consultas Agendadas) ->
+ Create a new Scheduled Query -> Configure a Query Agendada
Query: CALL `meu_projeto.minha_base.atualizar_snapshot_item_status`();
Configurar a frequência para Diariamente às 23:59
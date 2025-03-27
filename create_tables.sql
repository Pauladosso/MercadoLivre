CREATE TABLE dim_cliente (
  id_cliente INT PRIMARY KEY,
  nome VARCHAR(128),
  sobrenome VARCHAR(128),
  nome_preferencia VARCHAR(128),
  email VARCHAR(128),
  sexo VARCHAR(128),
  data_nascimento DATE,
  ddd INT,
  telefone INT,
  cpf_cnpj BIGINT,
  id_endereco INT,
  mercado_pago BOOLEAN,
  identidade_validada BOOLEAN,
  celular_validado BOOLEAN,
  email_validado BOOLEAN,
  data_cadastro TIMESTAMP
);

CREATE TABLE dim_item (
  id_item INT PRIMARY KEY,
  id_vendedor INT,
  id_categoria INT,
  nome_item VARCHAR(128),
  descricao VARCHAR(128),
  status VARCHAR(128),
  valor FLOAT,
  data_insercao TIMESTAMP,
  data_exclusao TIMESTAMP,
  FOREIGN KEY (id_vendedor) REFERENCES dim_cliente(id_cliente),
  FOREIGN KEY (id_categoria) REFERENCES dim_categoria(id_categoria)
);

CREATE TABLE dim_categoria (
  id_categoria INT PRIMARY KEY,
  nome VARCHAR(128),
  descricao TEXT,
  caminho_categoria VARCHAR(128)
);

CREATE TABLE fato_pedidos (
  id_pedido INT PRIMARY KEY,
  id_cliente INT,
  id_pagamento INT,
  id_endereco INT,
  valor_frete FLOAT,
  tipo_frete VARCHAR(128),
  data_pedido TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente)
);

CREATE TABLE fato_pedido_itens (
  id_pedido_item INT PRIMARY KEY,
  id_pedido INT,
  id_item INT,
  id_vendedor INT,
  id_categoria INT,
  quantidade INT,
  valor_unitario FLOAT,
  valor_total FLOAT,
  FOREIGN KEY (id_pedido) REFERENCES fato_pedidos(id_pedido),
  FOREIGN KEY (id_item) REFERENCES dim_item(id_item),
  FOREIGN KEY (id_categoria) REFERENCES dim_categoria(id_categoria)
);

CREATE TABLE dim_cartao (
  id_cartao INT PRIMARY KEY,
  id_cliente INT,
  nome_titular VARCHAR(128),
  numero_cartao BIGINT,
  bandeira VARCHAR(128),
  data_validade DATE,
  cvv VARCHAR(10),
  data_cadastro TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente)
);

CREATE TABLE fato_pagamentos (
  id_pagamento INT PRIMARY KEY,
  id_pedido INT,
  id_cliente INT,
  id_cartao INT,
  metodo_pagamento VARCHAR(128),
  parcelas INT,
  valor_total FLOAT,
  status_pagamento VARCHAR(128),
  data_pagamento TIMESTAMP,
  FOREIGN KEY (id_pedido) REFERENCES fato_pedidos(id_pedido),
  FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
  FOREIGN KEY (id_cartao) REFERENCES dim_cartao(id_cartao)
);

CREATE TABLE dim_endereco (
  id_endereco INT PRIMARY KEY,
  id_cliente INT,
  tipo VARCHAR(128),
  logradouro VARCHAR(256),
  numero INT,
  complemento VARCHAR(128),
  cep INT,
  bairro VARCHAR(128),
  cidade VARCHAR(256),
  estado VARCHAR(128),
  pais VARCHAR(128),
  data_cadastro TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente)
);


------------------------------------------------------------------

-- Para uso no BigQuery:

-- CREATE TABLE `meu_projeto.minha_base.dim_cliente` (
--   id_cliente INT64,
--   nome STRING,
--   sobrenome STRING,
--   nome_preferencia STRING,
--   email STRING,
--   sexo STRING,
--   data_nascimento DATE,
--   ddd INT64,
--   telefone INT64,
--   cpf_cnpj INT64,
--   id_endereco INT64,
--   mercado_pago BOOL,
--   identidade_validada BOOL,
--   celular_validado BOOL,
--   email_validado BOOL,
--   data_cadastro TIMESTAMP
-- );

-- CREATE TABLE `meu_projeto.minha_base.dim_item` (
--   id_item INT64,
--   id_vendedor INT64,
--   id_categoria INT64,
--   nome_item STRING,
--   descricao STRING,
--   status STRING,
--   valor FLOAT64,
--   data_insercao TIMESTAMP,
--   data_exclusao TIMESTAMP
-- );

-- CREATE TABLE `meu_projeto.minha_base.dim_categoria` (
--   id_categoria INT64,
--   nome STRING,
--   descricao STRING,
--   caminho_categoria STRING
-- );

-- CREATE TABLE `meu_projeto.minha_base.fato_pedidos` (
--   id_pedido INT64,
--   id_cliente INT64,
--   id_pagamento INT64,
--   id_endereco INT64,
--   valor_frete FLOAT64,
--   tipo_frete STRING,
--   data_pedido TIMESTAMP
-- );

-- CREATE TABLE `meu_projeto.minha_base.fato_pedido_itens` (
--   id_pedido_item INT64,
--   id_pedido INT64,
--   id_item INT64,
--   id_vendedor INT64,
--   id_categoria INT64,
--   quantidade INT64,
--   valor_unitario FLOAT64,
--   valor_total FLOAT64
-- );

-- CREATE TABLE `meu_projeto.minha_base.dim_cartao` (
--   id_cartao INT64,
--   id_cliente INT64,
--   nome_titular STRING,
--   numero_cartao INT64,
--   bandeira STRING,
--   data_validade DATE,
--   cvv STRING,
--   data_cadastro TIMESTAMP
-- );

-- CREATE TABLE `meu_projeto.minha_base.fato_pagamentos` (
--   id_pagamento INT64,
--   id_pedido INT64,
--   id_cliente INT64,
--   id_cartao INT64,
--   metodo_pagamento STRING,
--   parcelas INT64,
--   valor_total FLOAT64,
--   status_pagamento STRING,
--   data_pagamento TIMESTAMP
-- );

-- CREATE TABLE `meu_projeto.minha_base.dim_endereco` (
--   id_endereco INT64,
--   id_cliente INT64,
--   tipo STRING,
--   logradouro STRING,
--   numero INT64,
--   complemento STRING,
--   cep INT64,
--   bairro STRING,
--   cidade STRING,
--   estado STRING,
--   pais STRING,
--   data_cadastro TIMESTAMP
-- );
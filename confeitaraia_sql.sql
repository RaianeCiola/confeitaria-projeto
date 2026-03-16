create table tb_cliente(
	id serial PRIMARY KEY,
	nome varchar (80),
	email varchar (80),
	telefone varchar (20)
);

--drop table tb_cliente;

insert into tb_cliente(nome, email,telefone) values
	('João da Silva', 'joao@gmail.com','(16)99123-4567'),
	('Maria De Souza', 'maria@gmail.com','(16)99112-3456'),
	('Jurandir lopes', 'juarandir@gmail.com','(16)99123-4567');

select * from tb_cliente;
-----------------------------------------------------------

create table tb_produto(
	id serial PRIMARY KEY,
	nome varchar (80),
	descricao varchar (80),
	preco NUMERIC(10,2),
	categoria varchar(50),
	disponibilidade varchar(12)
);

--drop table tb_produto;

insert into tb_produto(nome, descricao,preco, categoria,disponibilidade) values
	('Bolo de Fubá', 'Bolo de fuba simples','8','Bolo', 'true'),
	('Bolo de Banana', 'Bolo banana com calda caramelizada de banana','17','Bolo', 'true'),
	('Rocombole trufado', 'rocombone de chocolate com leite ninho','20','Bolo', 'true'),
	('Pão de mel', 'pão de mel simples','5','Pão', 'true');
	
select * from tb_produto;

--------------------------------------------------------------
create table tb_pedido(
	id serial PRIMARY KEY,
	id_cliente int,
	id_produto int,
	data_pedido varchar(12),
	status varchar(20),
	total NUMERIC(10,2),
	CONSTRAINT fk_cliente_id FOREIGN KEY (id_cliente)
		REFERENCES tb_cliente(id),
		
	CONSTRAINT fk_produto_id FOREIGN KEY (id_produto)
		REFERENCES tb_produto(id)
		
	
);

--drop table tb_pedido
insert into tb_pedido(id_cliente, id_produto, data_pedido,status, total) values
	(1, 1, '11/11/2024','Finalizado','8');
	
select * from tb_pedido;
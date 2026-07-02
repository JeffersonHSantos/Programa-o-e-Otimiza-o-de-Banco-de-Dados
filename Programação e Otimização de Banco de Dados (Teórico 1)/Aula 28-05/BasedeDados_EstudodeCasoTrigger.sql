--drop table produtos cascade constraints;    
create table produtos (
 codigo number not null,
 descricao varchar2(20),
 estoque number(7,2),
 precounitario number(7,2),
 primary key (codigo)
);

   insert into produtos values(1,'Computador',5,3700);
   insert into produtos values(2,'SmartPhone',2,1299);
   insert into produtos values(3,'MacBook',2,12000);
   insert into produtos values(4,'Impressora',10,499.89);

  --drop table vendas cascade constraints;  
  CREATE TABLE vendas(
   numero NUMBER PRIMARY KEY,
   valorProduto NUMBER NOT NULL,
   quantidade NUMBER,
   data DATE,
   parcelas NUMBER,   
   codigoProduto NUMBER,
   FOREIGN KEY (codigoProduto) REFERENCES produtos(codigo)
  );
 
 --  drop table parcelas cascade constraints; 
   CREATE TABLE parcelas(
   numero NUMBER,
   valorParcela NUMBER NOT NULL,
   dataVenc date NOT NULL,
   dataPagto date,
   nvenda NUMBER,
   FOREIGN KEY (nvenda) REFERENCES vendas(numero),
   PRIMARY KEY (numero,nvenda)
);
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


 -- criar um trigger que gera PARCELAS
 
 CREATE OR REPLACE TRIGGER t_geraParcela
    AFTER INSERT ON VENDAS FOR EACH ROW
  declare
    varValorParcela NUMBER(10,2);
    varData DATE;
  BEGIN
    varData := :NEW.data; 
    varValorParcela := (:NEW.valorProduto * :NEW.quantidade)/:NEW.Parcelas;
    for i in 1.. :NEW.Parcelas LOOP
      select add_months(varData,1) INTO varData From dual; -- acrescenta mês na data
      INSERT INTO Parcelas(numero,valorParcela,DataVenc, Nvenda) 
                  VALUES(i,varValorParcela,varData,:NEW.numero);
    END LOOP;
  END;
  
  
  
  INSERT INTO VENDAS VALUES(geraId.nextval,12000,1,current_date,6,3);
  
  SELECT * FROM vendas
  select * from Parcelas
  select * from produtos
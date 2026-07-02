Exercícios de Revisão

1-Listar procedimentos que contenham a palavra “Joelho”.
  SELECT nome_procd
  FROM   procedimento
  WHERE  UPPER(nome_procd) like '%JOELHO%'

2- Listar pagamentos feitos entre 01/02/2026 e 03/02/2026.
  SELECT id_consulta,valor,data_hora
  FROM   Consulta
  WHERE  data_hora >= '01/02/2026' and data_hora <= '03/02/2026'  

3- Listar quantas consultas foram realizadas no mês de fevereiro, 
independente do ano
   SELECT   count(*), count(id_consulta)
   FROM     consulta
   WHERE    extract (month from data_hora) = 2
   
4-Listar paciente e médico de cada consulta
  SELECT   c.id_consulta,p.nome as Paciente, m.nome as Médico
  FROM     paciente p inner join consulta c ON p.id_paciente = c.id_paciente
            inner join medico m ON m.id_medico = c.id_medico

  
5-Listar consultas realizadas (numero e status = 'realizada') e o paciente
  SELECT   c.id_consulta,p.nome as Paciente, c.status
  FROM     paciente p inner join consulta c ON p.id_paciente = c.id_paciente
  WHERE    c.status = 'realizada'

6-Listar procedimentos realizados com nome do paciente
SELECT   p.nome as Paciente, pd.nome_procd
  FROM     paciente p inner join consulta c ON p.id_paciente = c.id_paciente
           inner join procedimento pd ON pd.id_consulta = c.id_consulta
  order by 1 desc            
  
7- Listar médico e sua especialidade
 SELECT m.nome, e.nome as Especialidade
 FROM   medico m inner join medesp me ON m.id_medico = me.id_medico
        inner join especialidade e ON e.id_especialidade = me.id_especialidade

8- Total pago por paciente (mostrar apenas quem pagou 150 ou mais)
em consulta realizadas
SELECT   p.nome as Paciente, sum(c.valor)
  FROM   paciente p inner join consulta c ON p.id_paciente = c.id_paciente
  WHERE  c.status = 'realizada'
  group by p.nome
  having sum(c.valor) >=  150
    
9- Quantidade de consultas por médico (mostrar apenas quem realizou 
mais de 1 consulta)
SELECT    m.nome as Médico, count(c.id_consulta)
  FROM    medico m inner join consulta c ON m.id_medico = c.id_medico
  group by m.nome
  HAVING count(id_consulta) > 1
  
10 - Faturamento total por médico (mostrar acima de 300)
SELECT    m.nome as Médico, sum(c.id_consulta)+sum(p.valor_procd) as total
  FROM    medico m inner join consulta c ON m.id_medico = c.id_medico
          inner join procedimento p ON p.id_consulta = c.id_consulta
  group by m.nome
  having (sum(c.id_consulta)+sum(p.valor_procd)) > 300
  
  
  
  
  

-- criando a tabela
create table silver.trips (
  id int primary key, 
  cidade text,
  tipo_produto varchar,
  status_viagem varchar,
  data_requerimento date,
  hora_requerimento time,
  data_inicio_viagem date,
  hora_inicio_viagem time,
  rua_inicio varchar,
  bairro_inicio varchar,
  uf_cidade_inicio varchar,
  data_final date,
  hora_final time,
  rua_final varchar,
  bairro_final varchar,
  uf_cidade_final varchar,
  preco float8,
  distancia_km float8,
  tempo_medio_viagem time,
  tempo_medio_espera time)

-- importando os dados
copy silver.trips(id, cidade, tipo_produto, status_viagem, data_requerimento, hora_requerimento, data_inicio_viagem, hora_inicio_viagem, rua_inicio, bairro_inicio, uf_cidade_inicio, data_final, hora_final, rua_final, bairro_final, uf_cidade_final, preco, distancia_km, tempo_medio_viagem, tempo_medio_espera) from 'C:\Users\mycri\Desktop\uber\trips.csv' delimiter ';' csv header NULL 'NULL' ENCODING 'LATIN1';

-- alterando dados das coluna
update silver.trips
set tipo_produto = 'UberX'
where tipo_produto = 'uberX';

update silver.trips
set bairro_final = 'Senador Vasconcelos'
where bairro_final = 'Sen. Vasconcelos'

update silver.trips
set bairro_final = 'Senador Vasconcelos'
where bairro_final = ' Senador Vasconcelos'

update silver.trips
set bairro_final = 'Senador Camará'
where bairro_final = 'Senador Camará '

update silver.trips
set bairro_final = 'Campo Grande'
where bairro_final = 'Campo Grande '

update silver.trips
set bairro_final = 'Pavuna'
where bairro_final = 'Pavuna '

update silver.trips
set bairro_final = 'Botafogo'
where bairro_final = 'Botafogo '

update silver.trips
set hora_final = null 
where hora_final = '00:00:00'

update silver.trips
set hora_inicio_viagem  = null 
where hora_inicio_viagem = '00:00:00'

update silver.trips
set hora_inicio_viagem = null 
where id = '178'

-- QUERYS
-- Quantidade de viagens realizadas
select 
  count(id) as qtd_viagens
from silver.trips

-- quantidade de viagens por tipo de produto
select 
  count(*) as quantidade,
  tipo_produto
from silver.trips
group by tipo_produto

-- status da viagem
select 
  count(*) as quantidade,
  status_viagem
from silver.trips
group by status_viagem

-- média de km percorrido
select 
  avg (distancia_km) as média_km 
from silver.trips

-- média de valor gasto
select avg (preco)
  as média_gasto 
from silver.trips

-- bairros que mais aparecem como destino de viagem
select
  count (*) as qtd_viagem,
  bairro_final
from silver.trips
group by bairro_final
order by qtd_viagem desc
limit 3

-- quantidade de viagens por ano
with tab1 as (
  select 
    count (*),
    extract (year from data_requerimento) as ano
from silver.trips t
group by data_requerimento)

select 
  count(*),
  ano
from tab1
group by ano;

-- tempo médio de viagem e tempo médio de espera
select 
  avg (tempo_medio_viagem) as tempo_medio_viagem,
  avg(tempo_medio_espera) as tempo_medio_espera
from silver.trips t

-- quantidade de viagens por turno do dia
with tab1 as (
  select
    case
      when hora_inicio_viagem >= '00:00:00'and hora_inicio_viagem <= '05:59:59' then 'Madrugada'
      when hora_inicio_viagem >= '06:00:00'and hora_inicio_viagem <= '11:59:59' then 'Manhã'
      when hora_inicio_viagem >= '12:00:00'and hora_inicio_viagem <= '17:59:59' then 'Tarde'
      when hora_inicio_viagem >= '18:00:00'and hora_inicio_viagem <= '23:59:59' then 'Noite' end turno
  from silver.trips t)

select
  count(*) as qtd_viagem,
  turno
from tab1
where turno is not null
group by turno

-- viagem mais barata e viagem mais cara
select
  max(preco),
  min(preco)
from tab1
where preco != 0

-- maior e menor tempo de espera
select
  max(tempo_medio_espera),
  min(tempo_medio_espera)
from silver.trips t
where tempo_medio_espera != '00:00:00'

-- maior e menor tempo de viagem
select
  max(tempo_medio_viagem),
  min(tempo_medio_viagem)
from silver.trips t
where tempo_medio_viagem != '00:00:00'




 





{{ config(
    tags = ['ibge','demografia','população','povo originário'],
    s3_data_dir = bucket() ~ '/staging/ibge/parquet/'
) }}

with
----------------------------------Q    U   I   L   O   M   B   O---------------------------------------------------
--Main: BR,UF e MU
quilombola as (
select
    cod_ibge,
    nivel,
    total,
    em_territorio_quilombola,
    fora_territorio_quilombola
from {{ ref('rfn_demo_pop_quilo') }}
),

--Agrega Regiões
norte_quilo as (
select
    substring(cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    sum(total) as total,
    sum(em_territorio_quilombola) as em_territorio_quilombola,
    sum(fora_territorio_quilombola) as fora_territorio_quilombola
from quilombola
where cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
group by 1,2
),
nordeste_quilo as (
select
    substring(cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    sum(total) as total,
    sum(em_territorio_quilombola) as em_territorio_quilombola,
    sum(fora_territorio_quilombola) as fora_territorio_quilombola
from quilombola
where cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
group by 1,2
),
sudeste_quilo as (
select
    substring(cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    sum(total) as total,
    sum(em_territorio_quilombola) as em_territorio_quilombola,
    sum(fora_territorio_quilombola) as fora_territorio_quilombola
from quilombola
where cod_ibge in ('31', '32', '33', '35')
group by 1,2
),
sul_quilo as (
select
    substring(cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    sum(total) as total,
    sum(em_territorio_quilombola) as em_territorio_quilombola,
    sum(fora_territorio_quilombola) as fora_territorio_quilombola
from quilombola
where cod_ibge in ('41', '42', '43')
group by 1,2
),
centro_quilo as (
select
    substring(cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    sum(total) as total,
    sum(em_territorio_quilombola) as em_territorio_quilombola,
    sum(fora_territorio_quilombola) as fora_territorio_quilombola
from quilombola
where cod_ibge in ('50', '51', '52', '53')
group by 1,2
)

select * from quilombola union all
select * from norte_quilo union all
select * from nordeste_quilo union all
select * from sudeste_quilo union all
select * from sul_quilo union all
select * from centro_quilo
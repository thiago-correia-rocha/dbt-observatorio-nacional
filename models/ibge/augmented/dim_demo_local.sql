{{
    config(
        tags = ['ibge'],
        s3_data_dir = bucket() ~ '/augmented/'
    )
}}

with
norte as (
select
    '1'  as  cod_ibge,
    'REGIAO' as nivel,
    'Norte' as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'UF'
and sigla in ('AM','PA','RR','RO','AC','TO','AP')
),

nordeste as (
select
    '2'  as  cod_ibge,
    'REGIAO' as nivel,
    'Nordeste' as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'UF'
and sigla in ('AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE')
),

centro_oeste as (
select
    '5'  as  cod_ibge,
    'REGIAO' as nivel,
    'Centro-Oeste' as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'UF'
and sigla in ('DF', 'GO', 'MT', 'MS')
),

sudeste as (
select
    '3'  as  cod_ibge,
    'REGIAO' as nivel,
    'Sudeste' as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'UF'
and sigla in ('ES', 'MG', 'RJ', 'SP')
),

sul as (
select
    '4'  as  cod_ibge,
    'REGIAO' as nivel,
    'Sul' as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'UF'
and sigla in ('PR', 'RS', 'SC')
),

uf as (
select
    cod_ibge,
    nivel,
    sigla  as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'UF'
),

municipio as (
select
    cod_ibge,
    nivel,
    municipio  as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'MU'
),

brasil as (
select
    '76' as cod_ibge,
    'BR' as nivel,
    'Brasil'  as descricao
from {{ ref('rfn_demo_local') }}
where nivel = 'BR'
)

select * from uf union all
select distinct * from norte union all
select distinct * from nordeste union all
select distinct * from centro_oeste union all
select distinct * from sul union all
select distinct * from sudeste union all
select distinct * from brasil union all
select * from municipio


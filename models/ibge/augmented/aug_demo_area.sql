{{
    config(
        tags = ['ibge','demografia','área','densidade','população'],
        s3_data_dir = bucket() ~ '/augmented/ibge/parquet/',
    )
}}

with

--Força os dados do brasil para apenas uma linha
brasil as (
select
    '76' as cod_ibge,
    'BR' as nivel,
    'Brasil' as descricao,
    8510417.9 as area,
    23.86 as densidade
from {{ ref('rfn_demo_area') }}
limit 1
),

municipio as (
select
    cod_ibge,
    nivel,
    cep as descricao,
    area,
    densidade
from {{ ref('rfn_demo_area') }}
where nivel = 'MU'
and cod_ibge != '1'
),

uf as (
select
    cod_ibge,
    nivel,
    cep as descricao,
    area,
    densidade
from {{ ref('rfn_demo_area') }}
where nivel = 'UF'
),

norte as (
select
    substring(uf.cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    'Norte' as descricao,
    sum(area) as area,
    round(sum(pop_total) / sum(area),2) as densidade
from uf
inner join {{ ref('stg_demo_pop') }} pop
on uf.cod_ibge = pop.cod_ibge
and pop.nivel = 'UF'
and pop.faixa_etaria = 'Total'
where uf.cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
group by 1,2,3
),

nordeste as (
select
    substring(uf.cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    'Nordeste' as descricao,
    sum(area) as area,
    round(sum(pop_total) / sum(area),2) as densidade
from uf
inner join {{ ref('stg_demo_pop') }} pop
on uf.cod_ibge = pop.cod_ibge
and pop.nivel = 'UF'
and pop.faixa_etaria = 'Total'
where uf.cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
group by 1,2,3
),

sudeste as (
select
    substring(uf.cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    'Sudeste' as descricao,
    sum(area) as area,
    round(sum(pop_total) / sum(area),2) as densidade
from uf
inner join {{ ref('stg_demo_pop') }} pop
on uf.cod_ibge = pop.cod_ibge
and pop.nivel = 'UF'
and pop.faixa_etaria = 'Total'
where uf.cod_ibge in ('31', '32', '33', '35')
group by 1,2,3
),

sul as (
select
    substring(uf.cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    'Sul' as descricao,
    sum(area) as area,
    round(sum(pop_total) / sum(area),2) as densidade
from uf
inner join {{ ref('stg_demo_pop') }} pop
on uf.cod_ibge = pop.cod_ibge
and pop.nivel = 'UF'
and pop.faixa_etaria = 'Total'
where uf.cod_ibge in ('41', '42', '43')
group by 1,2,3
),

centro_oeste as (
select
    substring(uf.cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    'Centro-Oeste' as descricao,
    sum(area) as area,
    round(sum(pop_total) / sum(area),2) as densidade
from uf
inner join {{ ref('stg_demo_pop') }} pop
on uf.cod_ibge = pop.cod_ibge
and pop.nivel = 'UF'
and pop.faixa_etaria = 'Total'
where uf.cod_ibge in ('50', '51', '52', '53')
group by 1,2,3
),
cte_union as (
    select * from brasil union all
    select * from norte union all
    select * from nordeste union all
    select * from sul union all
    select * from sudeste union all
    select * from centro_oeste union all
    select * from uf union all
    select * from municipio
),
final as (
    select
        *,
        dense_rank() over (partition by nivel order by area desc) ranking_area
    from cte_union
)
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final



{{
    config(
        tags = ['master data','ibge'],
        s3_data_dir = bucket() ~ '/augmented/master_data/parquet/',
        post_hook =  ["{{ exporta_md_json(this,'territorios-geral',\"1=1\",'augmented') }}"]
    )
}}

with
main as (
select
    cod_ibge,
    nivel,
    descricao
from {{ source('master_data', 'raw_md_geo') }}
),

cte_municipios as (
    select distinct
        cod_ibge
    from main
    where nivel = 'MU'
),

municipios as (
select
    'BR' as nivel,
    '76' as cod_ibge,
    count(*) as qtd_municipios
from cte_municipios

union all

select
    'REGIAO' as nivel,
    substr(cod_ibge, 1, 1) as cod_ibge,
    count(*) as qtd_municipios
from cte_municipios
group by substr(cod_ibge, 1, 1)

union all

select
    'UF' as nivel,
    substr(cod_ibge, 1, 2) as cod_ibge,
    count(*) as qtd_municipios
from cte_municipios
group by substr(cod_ibge, 1, 2)
),

final as (
    select
        main.*,
        coalesce(mun.qtd_municipios, 1) as qtd_municipios
    from main
    left join municipios mun
    on main.cod_ibge = mun.cod_ibge
    and main.nivel = mun.nivel
)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
order by
case nivel
    when 'BR' then 1
    when 'REGIAO' then 2
    when 'UF' then 3
    when 'MU' then 4
    else 5
end,
descricao asc

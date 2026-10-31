{{  config(
    tags = ['ibge','demografia','habitação','favela'],
    s3_data_dir = bucket() ~ '/staging/ibge/parquet/',
    s3_data_naming = 'table'
) }}

with
municipios as (
select
    substring(cod_ibge,1,7) as cod_ibge,
    'MU' as nivel,
    count(favela_completa) as qtd_fav,
    sum(domicilios) as domicilios_fav,
    cast('1' as bigint) as qtd_mun_fav
from {{ ref('rfn_demo_hab_rel_fav') }} fav
group by 1,2

),

uf as (
select
    substring(cod_ibge,1,2) as cod_ibge,
    'UF' as nivel,
    cast(uf.qtd_favelas as int) as qtd_fav,
    sum(mun.domicilios) as domicilios_fav,
    count(cod_ibge) as qtd_mun_fav
from {{ ref('rfn_demo_hab_fav_uf') }} uf
inner join {{ ref('rfn_demo_hab_fav_mun') }} mun
on uf.sigla = mun.sigla
and mun.cod_ibge is not null
group by 1,2,3
),

regioes as (
select
    substring(cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    sum(qtd_fav) as qtd_fav,
    sum(domicilios_fav) as domicilios_fav,
    sum(qtd_mun_fav) as qtd_mun_fav
from uf
group by 1,2
),

brasil as (
select
    '76' as cod_ibge,
    'BR' as nivel,
    sum(qtd_fav) as qtd_fav,
    sum(domicilios_fav) as domicilios_fav,
    sum(qtd_mun_fav) as qtd_mun_fav
from regioes
),

cte_union as (
    select * from municipios union all
    select * from uf union all
    select * from regioes union all
    select * from brasil
),

final as (
    select
        *,
        dense_rank() over (partition by nivel order by qtd_fav,domicilios_fav) as ranking_qtd_fav
    from cte_union
)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
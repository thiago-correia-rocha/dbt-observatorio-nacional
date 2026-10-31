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
    sum(domicilios) as domicilios_fav
from {{ ref('rfn_demo_hab_fav_mun') }} fav
group by 1,2

),


uf as (
select
    substring(cod_ibge,1,2) as cod_ibge,
    'UF' as nivel,
    cast(uf.qtd_favelas as int) as qtd_fav,
    sum(mun.domicilios) as domicilios_fav
from {{ ref('rfn_demo_hab_fav_uf') }} uf
inner join {{ ref('rfn_demo_hab_fav_mun') }} mun
on uf.sigla = mun.sigla
and mun.cod_ibge is not null
group by 1,2,3
),

regioes as (
select
    substring(mun.cod_ibge,1,1) as cod_ibge,
    'REGIAO' as nivel,
    sum(uf.qtd_favelas) as qtd_fav,
    sum(mun.domicilios) as domicilios_fav
from {{ ref('rfn_demo_hab_fav_uf') }} uf
inner join {{ ref('rfn_demo_hab_fav_mun') }} mun
on uf.sigla = mun.sigla
and mun.cod_ibge is not null
group by 1,2
),

brasil as (
select
    '76' as cod_ibge,
    'BR' as nivel,
    sum(qtd_fav) as qtd_fav, --dados divergentes MU x BR no proprio SIDRA. Adicionado domicilios em nivel nacional para fazer match com os dados BR.
    sum(domicilios_fav) + 16822 as domicilios_fav --dados divergentes MU x BR no proprio SIDRA. Adicionado domicilios em nivel nacional para fazer match com os dados BR.
from municipios
),

final as (
    select * from municipios union all
    select * from uf union all
    select * from regioes union all
    select * from brasil
)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
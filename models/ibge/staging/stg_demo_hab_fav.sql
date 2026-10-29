{{  config(
    tags = ['ibge','demografia','habitação','favela'],
    s3_data_dir = bucket() ~ '/staging/ibge/parquet/',
    s3_data_naming = 'table'
) }}

with
cte_main as (
select
    cod_ibge,
    loc.nivel,
    fav.qtd_favelas
from {{ ref('rfn_demo_hab_fav') }} fav
inner join {{ ref('rfn_demo_local') }} loc
on fav.sigla = loc.sigla
and loc.nivel = 'UF'
),

norte as (
select
    '1' as cod_ibge,
    'REGIAO' as nivel,
    sum(qtd_favelas) as qtd_favelas
from cte_main
where
cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
),

nordeste as (
select
    '2' as cod_ibge,
    'REGIAO' as nivel,
    sum(qtd_favelas) as qtd_favelas
from cte_main
where
cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
),

centro_oeste as (
select
    '5' as cod_ibge,
    'REGIAO' as nivel,
    sum(qtd_favelas) as qtd_favelas
from cte_main
where
cod_ibge in ('50', '51', '52', '53')
),

sudeste as (
select
    '3' as cod_ibge,
    'REGIAO' as nivel,
    sum(qtd_favelas) as qtd_favelas
from cte_main
where
cod_ibge in ('31', '32', '33', '35')
),

sul as (
select
    '4' as cod_ibge,
    'REGIAO' as nivel,
    sum(qtd_favelas) as qtd_favelas
from cte_main
where
cod_ibge in ('41', '42', '43')
),

brasil as (
select
    '0' as cod_ibge,
    'BR' as nivel,
    sum(qtd_favelas) as qtd_favelas
from cte_main
),

final as (
    select * from cte_main union all
    select * from norte union all
    select * from nordeste union all
    select * from centro_oeste union all
    select * from sudeste union all
    select * from sul union all
    select * from brasil
)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
{{ config(
    tags = ['ibge','demografia','população','cor e raça'],
    s3_data_dir = bucket() ~ '/staging/demografia/ibge/parquet/'
) }}

with
-- Main: MU
cor_main as (
    select
        cod_ibge,
        nivel ,
        total,
        branca,
        preta,
        amarela,
        parda,
        indigena
    from {{ ref('rfn_ibge_pop_cor') }}
    where nivel = 'MU'
),

uf as (
    select
        substring(cod_ibge,1,2) as cod_ibge,
        'UF' nivel ,
        sum(total) as total,
        sum(branca) as branca,
        sum(preta) as preta,
        sum(amarela) as amarela,
        sum(parda) as parda,
        sum(indigena) as indigena
    from cor_main
    group by 1
),

-- Brasil
brasil as (
    select
        '76' as cod_ibge,
        'BR' as nivel,
        sum(total) as total,
        sum(branca) as branca,
        sum(preta) as preta,
        sum(amarela) as amarela,
        sum(parda) as parda,
        sum(indigena) as indigena
    from uf
    group by 1, 2
),

-- Região Norte
norte as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(branca) as branca,
        sum(preta) as preta,
        sum(amarela) as amarela,
        sum(parda) as parda,
        sum(indigena) as indigena
    from uf
    where cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
    group by 1, 2
),
-- Região Nordeste
nordeste as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(branca) as branca,
        sum(preta) as preta,
        sum(amarela) as amarela,
        sum(parda) as parda,
        sum(indigena) as indigena
    from uf
    where cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
    group by 1, 2
),
-- Região Sudeste
sudeste as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(branca) as branca,
        sum(preta) as preta,
        sum(amarela) as amarela,
        sum(parda) as parda,
        sum(indigena) as indigena
    from uf
    where cod_ibge in ('31', '32', '33', '35')
    group by 1, 2
),
-- Região Sul
sul as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(branca) as branca,
        sum(preta) as preta,
        sum(amarela) as amarela,
        sum(parda) as parda,
        sum(indigena) as indigena
    from uf
    where cod_ibge in ('41', '42', '43')
    group by 1, 2
),
-- Região Centro-Oeste
centro as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(branca) as branca,
        sum(preta) as preta,
        sum(amarela) as amarela,
        sum(parda) as parda,
        sum(indigena) as indigena
    from uf
    where cod_ibge in ('50', '51', '52', '53')
    group by 1, 2
),
-- Consolidação dos quatro níveis geográficos
final as (
    select * from cor_main
    union all
    select * from brasil
    union all
    select * from norte
    union all
    select * from nordeste
    union all
    select * from sudeste
    union all
    select * from sul
    union all
    select * from centro
    union all
    select * from uf
)
----
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
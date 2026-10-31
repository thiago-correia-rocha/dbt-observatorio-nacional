{{ config(
    tags = ['ibge','demografia','população','religião'],
    s3_data_dir = bucket() ~ '/staging/ibge/parquet/'
) }}

with
-- Main: BR, UF e MU
religiao_main as (
    select
        cod_ibge,
        nivel,
        total,
        totalcatolica,
        totalevangelica,
        totalcatolica + totalevangelica as total_cristao,
        totalespirita,
        totalumbanda,
        totaltradind,
        totaloutras,
        totalateu,
        totalnaosabe,
        totalsd
    from {{ ref('rfn_demo_pop_rel') }}
    where cod_ibge != '1'
),

-- Região Norte
norte as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(totalcatolica) as totalcatolica,
        sum(totalevangelica) as totalevangelica,
        sum(total_cristao) as total_cristao,
        sum(totalespirita) as totalespirita,
        sum(totalumbanda) as totalumbanda,
        sum(totaltradind) as totaltradind,
        sum(totaloutras) as totaloutras,
        sum(totalateu) as totalateu,
        sum(totalnaosabe) as totalnaosabe,
        sum(totalsd) as totalsd
    from religiao_main
    where nivel = 'UF'
    and cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
    group by 1, 2
),

-- Região Nordeste
nordeste as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(totalcatolica) as totalcatolica,
        sum(totalevangelica) as totalevangelica,
        sum(total_cristao) as total_cristao,
        sum(totalespirita) as totalespirita,
        sum(totalumbanda) as totalumbanda,
        sum(totaltradind) as totaltradind,
        sum(totaloutras) as totaloutras,
        sum(totalateu) as totalateu,
        sum(totalnaosabe) as totalnaosabe,
        sum(totalsd) as totalsd
    from religiao_main
    where nivel = 'UF'
    and cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
    group by 1, 2
),

-- Região Sudeste
sudeste as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(totalcatolica) as totalcatolica,
        sum(totalevangelica) as totalevangelica,
        sum(total_cristao) as total_cristao,
        sum(totalespirita) as totalespirita,
        sum(totalumbanda) as totalumbanda,
        sum(totaltradind) as totaltradind,
        sum(totaloutras) as totaloutras,
        sum(totalateu) as totalateu,
        sum(totalnaosabe) as totalnaosabe,
        sum(totalsd) as totalsd
    from religiao_main
    where nivel = 'UF'
    and cod_ibge in ('31', '32', '33', '35')
    group by 1, 2
),

-- Região Sul
sul as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(totalcatolica) as totalcatolica,
        sum(totalevangelica) as totalevangelica,
        sum(total_cristao) as total_cristao,
        sum(totalespirita) as totalespirita,
        sum(totalumbanda) as totalumbanda,
        sum(totaltradind) as totaltradind,
        sum(totaloutras) as totaloutras,
        sum(totalateu) as totalateu,
        sum(totalnaosabe) as totalnaosabe,
        sum(totalsd) as totalsd
    from religiao_main
    where nivel = 'UF'
    and cod_ibge in ('41', '42', '43')
    group by 1, 2
),

-- Região Centro-Oeste
centro as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(total) as total,
        sum(totalcatolica) as totalcatolica,
        sum(totalevangelica) as totalevangelica,
        sum(total_cristao) as total_cristao,
        sum(totalespirita) as totalespirita,
        sum(totalumbanda) as totalumbanda,
        sum(totaltradind) as totaltradind,
        sum(totaloutras) as totaloutras,
        sum(totalateu) as totalateu,
        sum(totalnaosabe) as totalnaosabe,
        sum(totalsd) as totalsd
    from religiao_main
    where nivel = 'UF'
    and cod_ibge in ('50', '51', '52', '53')
    group by 1, 2
),

-- Brasil
brasil as (
    select
        '76' as cod_ibge,
        'BR' as nivel,
        sum(total) as total,
        sum(totalcatolica) as totalcatolica,
        sum(totalevangelica) as totalevangelica,
        sum(total_cristao) as total_cristao,
        sum(totalespirita) as totalespirita,
        sum(totalumbanda) as totalumbanda,
        sum(totaltradind) as totaltradind,
        sum(totaloutras) as totaloutras,
        sum(totalateu) as totalateu,
        sum(totalnaosabe) as totalnaosabe,
        sum(totalsd) as totalsd
    from religiao_main
    where nivel = 'UF'
    group by 1, 2
),


-- Consolidação dos quatro níveis geográficos
union_religiao as (
    select * from religiao_main
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
),
final as (
    select
        cod_ibge,
        nivel,
        total,
        totalcatolica,
        round(cast(totalcatolica as double) / total,4) as totalcatolica_perct,
        totalevangelica,
        round(cast(totalevangelica as double) / total,4) as totalevangelica_perct,
        total_cristao,
        round(cast(total_cristao as double) / total,4) as total_cristao_perct,
        totalespirita,
        round(cast(totalespirita as double) / total,4) as totalespirita_perct,
        totalumbanda,
        round(cast(totalumbanda as double) / total,4) as totalumbanda_perct,
        totaltradind,
        round(cast(totaltradind as double) / total,4) as totaltradind_perct,
        totaloutras,
        round(cast(totaloutras as double) / total,4) as totaloutras_perct,
        totalateu,
        round(cast(totalateu as double) / total,4) as totalateu_perct,
        totalnaosabe,
        round(cast(totalnaosabe as double) / total,4) as totalnaosabe_perct,
        totalsd,
        round(cast(totalsd as double) / total,4) as totalsd_perct
    from union_religiao
)

----
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
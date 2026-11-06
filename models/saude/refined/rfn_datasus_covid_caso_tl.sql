{{
    config(
        tags=['datasus', 'saúde', 'covid-19','pandemia','caso e óbito'],
        s3_data_dir = bucket() ~ '/refined/saude/datasus/parquet/'
    )
}}

with
s1_2020 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202001') }}
),
s2_2020 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202002') }}
),
s1_2021 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202101') }}
),
s2_2021 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202102') }}
),
s1_2022 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202201') }}
),
s2_2022 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202202') }}
),
s1_2023 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202301') }}
),
s2_2023 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202302') }}
),
s1_2024 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202401') }}
),
s2_2024 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202402') }}
),
s1_2025 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202501') }}
),
s2_2025 as (
select
    *
from {{ source('saude', 'raw_datasus_covid_tl_202502') }}
),
main as (
    select * from s1_2020 union all
    select * from s2_2020 union all
    select * from s1_2021 union all
    select * from s2_2021 union all
    select * from s1_2022 union all
    select * from s2_2022 union all
    select * from s1_2023 union all
    select * from s2_2023 union all
    select * from s1_2024 union all
    select * from s2_2024 union all
    select * from s1_2025 union all
    select * from s2_2025
),
final as (
    select
        nullif(trim(regiao), '') as regiao,
        nullif(trim(estado), '') as estado,
        nullif(trim(municipio), '') as municipio,
        nullif(trim(coduf), '') as coduf,
        nullif(trim(codmun), '') as codmun,
        nullif(trim(codRegiaoSaude), '') as codRegiaoSaude,
        nullif(trim(nomeRegiaoSaude), '') as nomeRegiaoSaude,
        try_cast(nullif(trim("data"), '') as date) as data,
        try_cast(nullif(trim(semanaEpi), '') as integer) as semanaEpi,
        try_cast(nullif(trim(populacaoTCU2019), '') as double) as populacaoTCU2019,
        try_cast(nullif(trim(casosAcumulado), '') as double) as casosAcumulado,
        try_cast(nullif(trim(casosNovos), '') as double) as casosNovos,
        try_cast(nullif(trim(obitosAcumulado), '') as double) as obitosAcumulado,
        try_cast(nullif(trim(obitosNovos), '') as double) as obitosNovos,
        try_cast(nullif(trim(Recuperadosnovos), '') as double) as Recuperadosnovos,
        try_cast(nullif(trim(emAcompanhamentoNovos), '') as double) as emAcompanhamentoNovos
    from main
)
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
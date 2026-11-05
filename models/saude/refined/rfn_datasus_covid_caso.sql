{{
    config(
        tags=['datasus', 'saúde', 'covid-19','pandemia' ,'caso e óbito'],
        s3_data_dir = bucket() ~ '/refined/saude/datasus/parquet/'
    )
}}

select
    ibgeID as cod_ibge,
    country,
    state,
    city,
    cast(deaths as double) as deaths,
    cast(totalCases as double) as totalCases,
    cast(deaths_per_100k_inhabitants as double) as deaths_per_100k_inhabitants,
    cast(totalCases_per_100k_inhabitants as double) as totalCases_per_100k_inhabitants,
    cast(deaths_by_totalCases as date) as deaths_by_totalCases,
    _source,
    cast(date as date) date,
    cast(newCases  as double) as newCases,
    cast(newDeaths as double) as newDeaths,
    cast(last_info_date as date) as last_info_date,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('saude', 'raw_datasus_covid_caso') }}
{{ config(
    tags=['datasus', 'saúde', 'covid-19','pandemia' ,'caso e óbito'],
    s3_data_dir = bucket() ~ '/staging/demografia/ibge/parquet/'
) }}

with
-- MU
municipio as (
    select
        cod_ibge,
        'MU' nivel,
        deaths as covid_obit,
        totalCases  as covid_caso,
        deaths_per_100k_inhabitants  as covid_obit_100_mil,
        totalCases_per_100k_inhabitants as covid_caso_100_mil,
        deaths_by_totalCases as covid_obit_por_caso,
        date as covid_data,
        newCases as covid_novo_caso,
        newDeaths as covid_novo_obit,
        last_info_date as ultima_data
    from {{ ref('rfn_datasus_covid_caso') }}
    where upper(city) != 'CASO SEM LOCALIZAÇÃO DEFINIDA'
),

-- BR
brasil as (
    select
        '76' as cod_ibge,
        'BR' nivel,
        sum(deaths) as covid_obit,
        sum(totalCases) as covid_caso,
        sum(deaths_per_100k_inhabitants) as covid_obit_100_mil,
        sum(totalCases_per_100k_inhabitants) as covid_caso_100_mil,
        deaths_by_totalCases as covid_obit_por_caso,
        date as covid_data,
        sum(newCases) as covid_novo_caso,
        sum(newDeaths) as covid_novo_obit,
        last_info_date as ultima_data
    from {{ ref('rfn_datasus_covid_caso') }}
    group by 1, 2,7,8,11
),

-- UF
uf as (
    select
        substring(cod_ibge, 1, 2) as cod_ibge,
        'UF' nivel,
        sum(deaths) as covid_obit,
        sum(totalCases) as covid_caso,
        sum(deaths_per_100k_inhabitants) as covid_obit_100_mil,
        sum(totalCases_per_100k_inhabitants) as covid_caso_100_mil,
        deaths_by_totalCases as covid_obit_por_caso,
        date as covid_data,
        sum(newCases) as covid_novo_caso,
        sum(newDeaths) as covid_novo_obit,
        last_info_date as ultima_data
    from {{ ref('rfn_datasus_covid_caso') }}
    group by 1, 2,7,8,11
),

-- Região Norte
norte as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' nivel,
        sum(covid_obit) as covid_obit,
        sum(covid_caso) as covid_caso,
        sum(covid_obit_100_mil) as covid_obit_100_mil,
        sum(covid_caso_100_mil) as covid_caso_100_mil,
        covid_obit_por_caso,
        covid_data,
        sum(covid_novo_caso) as covid_novo_caso,
        sum(covid_novo_obit) as covid_novo_obit,
        ultima_data
    from uf
    where cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
    group by 1, 2,7,8,11
),

-- Região Nordeste
nordeste as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' nivel,
        sum(covid_obit) as covid_obit,
        sum(covid_caso) as covid_caso,
        sum(covid_obit_100_mil) as covid_obit_100_mil,
        sum(covid_caso_100_mil) as covid_caso_100_mil,
        covid_obit_por_caso,
        covid_data,
        sum(covid_novo_caso) as covid_novo_caso,
        sum(covid_novo_obit) as covid_novo_obit,
        ultima_data
    from uf
    where cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
    group by 1, 2,7,8,11
),

-- Região Sudeste
sudeste as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' nivel,
        sum(covid_obit) as covid_obit,
        sum(covid_caso) as covid_caso,
        sum(covid_obit_100_mil) as covid_obit_100_mil,
        sum(covid_caso_100_mil) as covid_caso_100_mil,
        covid_obit_por_caso,
        covid_data,
        sum(covid_novo_caso) as covid_novo_caso,
        sum(covid_novo_obit) as covid_novo_obit,
        ultima_data
    from uf
    where cod_ibge in ('31', '32', '33', '35')
    group by 1, 2,7,8,11
),

-- Região Sul
sul as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' nivel,
        sum(covid_obit) as covid_obit,
        sum(covid_caso) as covid_caso,
        sum(covid_obit_100_mil) as covid_obit_100_mil,
        sum(covid_caso_100_mil) as covid_caso_100_mil,
        covid_obit_por_caso,
        covid_data,
        sum(covid_novo_caso) as covid_novo_caso,
        sum(covid_novo_obit) as covid_novo_obit,
        ultima_data
    from uf
    where cod_ibge in ('41', '42', '43')
    group by 1, 2,7,8,11
),

-- Região Centro
centro as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' nivel,
        sum(covid_obit) as covid_obit,
        sum(covid_caso) as covid_caso,
        sum(covid_obit_100_mil) as covid_obit_100_mil,
        sum(covid_caso_100_mil) as covid_caso_100_mil,
        covid_obit_por_caso,
        covid_data,
        sum(covid_novo_caso) as covid_novo_caso,
        sum(covid_novo_obit) as covid_novo_obit,
        ultima_data
    from uf
    where cod_ibge in ('50', '51', '52', '53')
    group by 1, 2,7,8,11
),

-- Consolidação dos quatro níveis geográficos
final as (
    select * from municipio
    union all
    select * from brasil
    union all
    select * from uf
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
)

----
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
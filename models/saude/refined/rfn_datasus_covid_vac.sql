{{
    config(
        tags=['datasus', 'saúde', 'covid-19','pandemia' ,'vacinação'],
        s3_data_dir = bucket() ~ '/refined/saude/datasus/parquet/'
    )
}}

select
     country ,
     state ,
     cast(totalCases as double) as totalCases,
     cast(totalCasesMS  as double) as totalCasesMS,
     cast(notConfirmedByMS as double) as notConfirmedByMS,
     cast(deaths as double) as deaths,
     cast(deathsMS as double) as deathsMS,
     URL ,
     cast(deaths_per_100k_inhabitants as double) as deaths_per_100k_inhabitants,
     cast(totalCases_per_100k_inhabitants as double) as totalCases_per_100k_inhabitants,
     cast(deaths_by_totalCases  as double) as deaths_by_totalCases,
     cast(recovered as double) as recovered,
     cast(suspects  as double) as suspects,
     cast(tests as double) as tests,
     cast(tests_per_100k_inhabitants as double) as tests_per_100k_inhabitants,
     cast(vaccinated as double) as vaccinated,
     cast(vaccinated_per_100_inhabitants as double) as vaccinated_per_100_inhabitants,
     cast(vaccinated_second as double) as vaccinated_second,
     cast(vaccinated_second_per_100_inhabitants as double) as vaccinated_second_per_100_inhabitants,
     cast(vaccinated_single as double) as vaccinated_single,
     cast(vaccinated_single_per_100_inhabitants as double) as vaccinated_single_per_100_inhabitants,
     cast(vaccinated_third as double) as vaccinated_third,
     cast(vaccinated_third_per_100_inhabitants as double) as vaccinated_third_per_100_inhabitants,
     cast(date as date) as  date,
     cast(newCases as double) as newCases,
     cast(newDeaths  as double) as newDeaths,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ source('saude', 'raw_datasus_covid_vac') }}
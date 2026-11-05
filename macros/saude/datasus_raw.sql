{% macro datasus_raw() %}
    {% call statement() %}
        create database if not exists saude;
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_caso (
            country string,
            state string,
            city string,
            ibgeID string,
            deaths string,
            totalCases string,
            deaths_per_100k_inhabitants string,
            totalCases_per_100k_inhabitants string,
            deaths_by_totalCases string,
            `_source` string,
            `date` string,
            newCases string,
            newDeaths string,
            last_info_date string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/raw_datasus_covid_caso/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_vac (
                country string,
                state string,
                totalCases string,
                totalCasesMS string,
                notConfirmedByMS string,
                deaths string,
                deathsMS string,
                URL string,
                deaths_per_100k_inhabitants string,
                totalCases_per_100k_inhabitants string,
                deaths_by_totalCases string,
                recovered string,
                suspects string,
                tests string,
                tests_per_100k_inhabitants string,
                vaccinated string,
                vaccinated_per_100_inhabitants string,
                vaccinated_second string,
                vaccinated_second_per_100_inhabitants string,
                vaccinated_single string,
                vaccinated_single_per_100_inhabitants string,
                vaccinated_third string,
                vaccinated_third_per_100_inhabitants string,
                date string,
                newCases string,
                newDeaths string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/raw_datasus_covid_vac/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_cron (
               data string,
               manchete string,
               url
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/raw_datasus_covid_cron/'
    {% endcall %}

{% endmacro %}

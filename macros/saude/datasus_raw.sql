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
               url string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_cron/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202001 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202001/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202002 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202002/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202101 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202101/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202102 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202102/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202201 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202201/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202202 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202202/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202301 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202301/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202302 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202302/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202401 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202401/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202402 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202402/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202501 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202501/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists saude.raw_datasus_covid_tl_202502 (
            regiao string,
            estado string,
            municipio string,
            coduf string,
            codmun string,
            codRegiaoSaude string,
            nomeRegiaoSaude string,
            data string,
            semanaEpi string,
            populacaoTCU2019 string,
            casosAcumulado string,
            casosNovos string,
            obitosAcumulado string,
            obitosNovos string,
            Recuperadosnovos string,
            emAcompanhamentoNovos string
        )
        stored as parquet
        location '{{ bucket() }}/raw/saude/datasus/parquet/raw_datasus_covid_tl_202502/'
    {% endcall %}

{% endmacro %}

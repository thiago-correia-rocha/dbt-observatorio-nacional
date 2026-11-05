
{{ config(
    tags=['datasus', 'saúde', 'covid-19', 'pandemia', 'vacinação'],
    s3_data_dir=bucket() ~ '/staging/saude/parquet/'
) }}

WITH
-- Brasil
brasil AS (
    SELECT
        '76' AS cod_ibge,
        'BR' AS nivel,
        array_agg(url) AS url,

        vaccinated + vaccinated_single AS vacinados,
        vaccinated_second AS vacinados_2_dose,
        vaccinated_single AS vacinados_dose_unica,

        vaccinated_second + vaccinated_single AS imunizados,
        vaccinated_third AS vacinados_3_dose,

        vaccinated + vaccinated_second
            + vaccinated_single + vaccinated_third AS vacinas_aplicadas,

        recovered AS recuperados,
        tests AS testes

    FROM {{ ref('rfn_datasus_covid_vac') }}
    WHERE state = 'TOTAL'
    GROUP BY 1, 2, 4, 5, 6, 7, 8, 9, 10, 11
),

-- Unidades Federativas
uf AS (
    SELECT
        loc.cod_ibge,
        'UF' AS nivel,
        array_agg(vac.url) AS url,
        vac.vaccinated + vac.vaccinated_single AS vacinados,
        vac.vaccinated_second AS vacinados_2_dose,
        vac.vaccinated_single AS vacinados_dose_unica,
        vac.vaccinated_second + vac.vaccinated_single AS imunizados,
        vac.vaccinated_third AS vacinados_3_dose,
        vac.vaccinated + vac.vaccinated_second
            + vac.vaccinated_single + vac.vaccinated_third AS vacinas_aplicadas,
        vac.recovered AS recuperados,
        vac.tests AS testes

    FROM {{ ref('rfn_datasus_covid_vac') }} vac

    INNER JOIN {{ ref('dim_md_geo') }} loc
        ON upper(trim(vac.state)) = upper(trim(loc.descricao))
        AND loc.nivel = 'UF'

    WHERE vac.state <> 'TOTAL'
    GROUP BY 1, 2, 4, 5, 6, 7, 8, 9, 10, 11
),

-- Cinco regiões brasileiras
regioes AS (
    SELECT
        substring(cod_ibge, 1, 1) AS cod_ibge,
        'REGIAO' AS nivel,
        array_distinct(flatten(array_agg(url))) AS url,
        sum(vacinados) AS vacinados,
        sum(vacinados_2_dose) AS vacinados_2_dose,
        sum(vacinados_dose_unica) AS vacinados_dose_unica,
        sum(imunizados) AS imunizados,
        sum(vacinados_3_dose) AS vacinados_3_dose,
        sum(vacinas_aplicadas) AS vacinas_aplicadas,
        sum(recuperados) AS recuperados,
        sum(testes) AS testes
    FROM uf
    WHERE substring(cod_ibge, 1, 1) IN ('1', '2', '3', '4', '5')
    GROUP BY 1, 2
),


final AS (
    SELECT * FROM brasil
    UNION ALL
    SELECT * FROM uf
    UNION ALL
    SELECT * FROM regioes
)

SELECT
    *,
    cast(current_timestamp AS timestamp) AS refresh_dt
FROM final

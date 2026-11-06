{{
    config(
        tags=['datasus', 'saúde', 'covid-19', 'pandemia', 'vacinação', 'caso e óbito'],
        s3_data_dir = bucket() ~ '/augmented/saude/datasus/parquet/',
        post_hook =  ["{{ exporta_datasus_json(this,'covid-caso',\"1=1 order by data\", 'augmented') }}"]
    )
}}

with
vacina as (
    select
        cod_ibge,
        nivel,
        url,
        vacinados,
        vacinados_2_dose,
        vacinados_dose_unica,
        imunizados,
        vacinados_3_dose,
        vacinas_aplicadas,
        recuperados,
        testes
    from {{ ref('stg_datasus_covid_vac') }} vac
),
caso as (
    select
        cod_ibge,
        nivel,
        covid_obit,
        covid_caso,
        covid_obit_100_mil,
        covid_caso_100_mil,
        covid_obit_por_caso,
        covid_data,
        covid_novo_caso,
        covid_novo_obit,
        ultima_data
    from {{ ref('stg_datasus_covid_caso') }} caso
),
final as (
select
    caso.cod_ibge,
    caso.nivel,
    caso.covid_obit,
    round(cast(caso.covid_obit as double) / pop.pop_total, 4) as obit_perct,
    caso.covid_caso,
    round(cast(caso.covid_caso as double) / pop.pop_total, 4) as caso_perct,
    caso.covid_obit_100_mil,
    caso.covid_caso_100_mil,
    caso.covid_obit_por_caso,
    caso.covid_data,
    caso.covid_novo_caso,
    caso.covid_novo_obit,
    vac.url,
    vac.vacinados,
    round(cast(vac.vacinados as double) / pop.pop_total, 4) as vacinados_perct,
    vac.vacinados_2_dose,
    round(cast(vac.vacinados_2_dose as double) / pop.pop_total, 4) as vacinados_2_dose_perct,
    vac.vacinados_dose_unica,
    round(cast(vac.vacinados_dose_unica as double) / pop.pop_total, 4) as vacinados_dose_unica_perct,
    vac.imunizados,
    round(cast(vac.imunizados as double) / pop.pop_total, 4) as imunizados_perct,
    vac.vacinados_3_dose,
    round(cast(vac.vacinados_3_dose as double) / pop.pop_total, 4) as vacinados_3_dose_perct,
    vac.vacinas_aplicadas,
    vac.recuperados,
    vac.testes,
    caso.ultima_data
from caso
left join vacina vac
on vac.cod_ibge = caso.cod_ibge
left join {{ ref('stg_ibge_pop') }} pop
on caso.cod_ibge = pop.cod_ibge
and pop.faixa_etaria = 'Total'
)
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final


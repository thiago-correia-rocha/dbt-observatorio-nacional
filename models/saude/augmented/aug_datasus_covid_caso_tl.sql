{{
    config(
        tags=['datasus', 'saúde', 'covid-19', 'pandemia', 'vacinação'],
        s3_data_dir = bucket() ~ '/augmented/saude/datasus/parquet/',
        post_hook =  ["{{ exporta_datasus_json(this,'covid-caso-tl',\"1=1 order by data\", 'augmented') }}"]
    )
}}

with
final as (
select
     tl.cod_ibge,
     tl.nivel ,
     data,
     casosacumulado,
     round(casosacumulado / pop.pop_total,4) casosacumulado_perct,
     obitosacumulado ,
     round(obitosacumulado / pop.pop_total,4) obitosacumulado_perct,
     casosnovos ,
     obitosNovos ,
     Recuperadosnovos ,
     emAcompanhamentoNovos
from {{ ref('stg_datasus_covid_caso_tl') }} tl
left join {{ ref('stg_ibge_pop') }} pop
on tl.cod_ibge = pop.cod_ibge
and pop.faixa_etaria = 'Total'
)
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final


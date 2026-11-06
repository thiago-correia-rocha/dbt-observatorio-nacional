{{ config(
    tags=['datasus', 'saúde', 'covid-19','pandemia' ,'caso e óbito'],
    s3_data_dir = bucket() ~ '/staging/demografia/ibge/parquet/'
) }}

with
main as (
    select
        case
            when codmun is  null
            then coduf
            else codmun
        end as cod_ibge ,
        case
            when codmun is not null
            then 'MU'
            when lower(regiao) = 'brasil'
            then 'BR'
            else 'UF'
        end as nivel ,
        data ,
        casosAcumulado ,
        casosNovos ,
        obitosAcumulado ,
        obitosNovos ,
        Recuperadosnovos ,
        emAcompanhamentoNovos
    from {{ ref('rfn_datasus_covid_caso_tl') }}
),

regiao as (
    select
        substring(coduf,1,1) as cod_ibge,
        'REGIAO' as nivel ,
        data ,
        sum(casosAcumulado) as  casosAcumulado,
        sum(casosNovos) as  casosNovos,
        sum(obitosAcumulado) as  obitosAcumulado,
        sum(obitosNovos) as  obitosNovos,
        sum(Recuperadosnovos) as  Recuperadosnovos,
        sum(emAcompanhamentoNovos) as emAcompanhamentoNovos
    from {{ ref('rfn_datasus_covid_caso_tl') }}
    where codmun is null and lower(regiao) != 'brasil'
    group by 1,2,3
),

-- Consolidação dos quatro níveis geográficos
final as (
    select * from main union all
    select * from regiao
)

----
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
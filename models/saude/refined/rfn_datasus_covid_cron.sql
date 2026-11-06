{{
    config(
        tags=['datasus', 'saúde', 'covid-19','pandemia' ,'memorial'],
        s3_data_dir = bucket() ~ '/refined/saude/datasus/parquet/',
        post_hook =  ["{{ exporta_datasus_json(this,'covid-cronologia',\"1=1 order by data\", 'refined') }}"]
    )
}}

with
final as (
select
     cast(data as date) as data,
     manchete as titulo,
     array_agg(url) as url
from {{ source('saude', 'raw_datasus_covid_cron') }}
group by 1,2
)
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
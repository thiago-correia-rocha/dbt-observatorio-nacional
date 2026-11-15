{{
    config(
        tags = ['master data'],
        s3_data_dir = bucket() ~ '/refined/master_data/parquet/',
        post_hook =  ["{{ exporta_md_json(this,'portal-geral',\"1=1\",'refined') }}"]
    )
}}

with source as (
    select *
    from {{ source('master_data', 'raw_md_portal') }}

),

refined as (
    select
        nullif(trim(id_conteudo), '') as id_conteudo,
        nullif(trim(tema), '') as tema,
        nullif(trim(indicador), '') as indicador,

        nullif(trim(titulo_principal), '') as titulo_principal,
        nullif(trim(texto_principal), '') as texto_principal,

        nullif(trim(titulo_ajuda), '') as titulo_ajuda,
        nullif(trim(texto_ajuda), '') as texto_ajuda,

        nullif(trim(titulo_importancia), '') as titulo_importancia,
        nullif(trim(texto_importancia), '') as texto_importancia,

        nullif(trim(fonte), '') as fonte,
        nullif(trim(url_fonte), '') as url_fonte,
        nullif(trim(url_wiki), '') as url_wiki,
        nullif(trim(url_dashboard), '') as url_dashboard,

        cast(
            nullif(trim(cast(ano_referencia as varchar)), '')
            as integer
        ) as ano_referencia

    from source

)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from refined


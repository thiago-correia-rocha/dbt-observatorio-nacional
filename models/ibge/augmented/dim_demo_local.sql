{{
    config(
        tags = ['ibge','unidade federativa','municipios'],
        s3_data_dir = bucket() ~ '/augmented/'
    )
}}

select
    cod             as cod_ibge,
    sigla           as uf,
    municipio       as municipio,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ ref('rfn_demo_local') }}
where nivel = 'MU'
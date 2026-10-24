{{  config(
    tags = ['ibge','demografia','alfabetização'],
    s3_data_dir = bucket() ~ '/staging/'
) }}

select
    cod as cod_ibge,
    idade as faixa_etaria,
    mulheres_alfabetizadas as mulheres_alfa,
    homens_alfabetizados as homens_alfa,
    cast(current_timestamp as timestamp) as refresh_dt
from {{ ref('rfn_demo_alfa') }}
where nivel = 'MU'
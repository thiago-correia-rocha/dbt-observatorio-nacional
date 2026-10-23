{{  config(
    materialized='table',
        tags = ['ibge','demografia','alfabetização']
) }}

select
    cod as cod_ibge,
    idade as faixa_etaria,
    mulheres_alfabetizadas,
from {{ ref('rfn_demo_alfa') }}
where nivel = 'MU'
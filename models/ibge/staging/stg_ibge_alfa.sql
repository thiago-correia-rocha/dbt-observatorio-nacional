{{  config(
    materialized='table',
        tags = ['ibge','alfabetização']
) }}

select
    cod as cod_ibge,
    idade as faixa_etaria,
    mulheres_alfabetizadas,
from {{ ref('rfn_ibge_alfa') }}
where nivel = 'MU'
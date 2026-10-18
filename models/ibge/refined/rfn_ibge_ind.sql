{{  config(
    materialized='table',
        tags = ['ibge','povos originários','indígenas']
) }}

select
    cep	,
    sigla,
    regiao,
    nivel,
    localizacao,
    total,
    homens,
    mulheres
from {{ source('ibge', 'raw_ibge_ind') }}
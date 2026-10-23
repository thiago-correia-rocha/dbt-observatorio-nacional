{{  config(
    materialized='table',
    tags = ['ibge','demografia','povos originários','indígenas'],
    location = '{{ bucket() }}/refined/ibge/demografia/'
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
from {{ source('ibge', 'raw_demo_ind') }}
{{ config(materialized='table') }}

select
    cod             as cod_ibge,
    sigla           as uf,
    municipio       as municipio
from {{ source('ibge', 'raw_ibge_populacao') }}
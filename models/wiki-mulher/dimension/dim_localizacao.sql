{{ config(materialized='table') }}

select
    cod_ibge        as cod_ibge,
    sigla           as uf,
    municipio       as municipio
from {{ ref('rfn_ibge_populacao') }}
where nivel = 'MU'
{{ config(materialized='table') }}

select
    cod             as cod_ibge,
    sigla           as uf,
    municipio       as municipio
from {{ ref('rfn_demo_loc') }}
where nivel = 'MU'
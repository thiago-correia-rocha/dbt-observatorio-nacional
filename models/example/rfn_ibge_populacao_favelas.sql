
{{ config(materialized='table') }}


select * from {{ source('ibge','raw_ibge_populacao_favelas') }}

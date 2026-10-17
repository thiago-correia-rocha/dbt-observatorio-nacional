{{ config(materialized='table') }}


select
    Cod         as cod_ibge,
    M_1         as faixa_etaria_1 ,
    M_2         as faixa_etaria_2 ,
    M_3         as faixa_etaria_3 ,
    M_4         as faixa_etaria_4 ,
    M_5         as faixa_etaria_5 ,
    M_6         as faixa_etaria_6 ,
    M_7         as faixa_etaria_7 ,
    M_8         as faixa_etaria_8 ,
    M_9         as faixa_etaria_9 ,
    M_10        as faixa_etaria_10,
    M_11        as faixa_etaria_11,
    M_12        as faixa_etaria_12,
    M_13        as faixa_etaria_13,
    M_14        as faixa_etaria_14,
    M_15        as faixa_etaria_15,
    M_16        as faixa_etaria_16,
    M_17        as faixa_etaria_17,
    M_18        as faixa_etaria_18,
    M_19        as faixa_etaria_19,
    M_20        as faixa_etaria_20,
    M_21        as faixa_etaria_21,
    M_22        as faixa_etaria_22
from {{ source('ibge','raw_ibge_populacao_favelas') }}

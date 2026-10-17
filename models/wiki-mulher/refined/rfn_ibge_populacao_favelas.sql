{{ config(materialized='table') }}

select
    Cod   as cod_ibge,
    M_22  as mulheres_total
    M_1   as mulheres_0_4_anos,
    M_2   as mulheres_5_9_anos,
    M_3   as mulheres_10_14_anos,
    M_4   as mulheres_15_19_anos,
    M_5   as mulheres_20_24_anos,
    M_6   as mulheres_25_29_anos,
    M_7   as mulheres_30_34_anos,
    M_8   as mulheres_35_39_anos,
    M_9   as mulheres_40_44_anos,
    M_10  as mulheres_45_49_anos,
    M_11  as mulheres_50_54_anos,
    M_12  as mulheres_55_59_anos,
    M_13  as mulheres_60_64_anos,
    M_14  as mulheres_65_69_anos,
    M_15  as mulheres_70_74_anos,
    M_16  as mulheres_75_79_anos,
    M_17  as mulheres_80_84_anos,
    M_18  as mulheres_85_89_anos,
    M_19  as mulheres_90_94_anos,
    M_20  as mulheres_95_99_anos,
    M_21  as mulheres_100_mais_anos

from {{ source('ibge', 'raw_ibge_populacao_favelas') }}
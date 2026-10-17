{{ config(materialized='table') }}

select
    Cod   as cod_ibge,
    TotalMulher  as mulheres_total,
    Nivel  as nivel,
    "41"   as mulheres_0_4_anos,
    "42"   as mulheres_5_9_anos,
    "43"   as mulheres_10_14_anos,
    "44"   as mulheres_20_24_anos,
    "45"   as mulheres_25_29_anos,
    "46"   as mulheres_30_34_anos,
    "47"   as mulheres_35_39_anos,
    "48"   as mulheres_40_44_anos,
    "49"   as mulheres_45_49_anos,
    "50"   as mulheres_50_54_anos,
    "51"   as mulheres_55_59_anos,
    "52"   as mulheres_60_64_anos,
    "53"   as mulheres_65_69_anos,
    "54"   as mulheres_70_74_anos,
    "55"   as mulheres_75_79_anos,
    "56"   as mulheres_80_84_anos,
    "57"   as mulheres_85_89_anos,
    "58"   as mulheres_90_94_anos,
    "59"   as mulheres_95_99_anos,
    "60"   mulheres_100_mais_anos

from {{ source('ibge', 'raw_ibge_populacao') }}
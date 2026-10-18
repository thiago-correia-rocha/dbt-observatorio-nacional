{{ config(
    materialized='table',
    tags = ['ibge','população','favela']
) }}

with
----------------------------------F     A   V   E   L   A ---------------------------------------------------------------
---MAIN CTE
cte_favela as (
select
*
from {{ ref('rfn_ibge_pop_fav') }}
),

---UNPIVOT DAS MULHERES
mulheres_favela as (
    select
        cod_ibge,
        faixa_etaria,
        mulheres_fav

    from cte_favela

    unpivot include nulls (
            mulheres_fav  for faixa_etaria in (
            mulheres_total         as "Total",
            mulheres_0_4_anos      as "0-4",
            mulheres_5_9_anos      as "5-9",
            mulheres_10_14_anos    as "10-14",
            mulheres_15_19_anos    as "15-19",
            mulheres_20_24_anos    as "20-24",
            mulheres_25_29_anos    as "25-29",
            mulheres_30_34_anos    as "30-34",
            mulheres_35_39_anos    as "35-39",
            mulheres_40_44_anos    as "40-44",
            mulheres_45_49_anos    as "45-49",
            mulheres_50_54_anos    as "50-54",
            mulheres_55_59_anos    as "55-59",
            mulheres_60_64_anos    as "60-64",
            mulheres_65_69_anos    as "65-69",
            mulheres_70_74_anos    as "70-74",
            mulheres_75_79_anos    as "75-79",
            mulheres_80_84_anos    as "80-84",
            mulheres_85_89_anos    as "85-89",
            mulheres_90_94_anos    as "90-94",
            mulheres_95_99_anos    as "95-99",
            mulheres_100_mais_anos as "100-mais"
        )
    )

),

---UNPIVOT DAS MULHERES
homens_favela as (
    select
        cod_ibge,
        faixa_etaria,
        homens_fav

    from cte_favela

    unpivot include nulls (
            homens_fav  for faixa_etaria in (
            homens_total         as "Total",
            homens_0_4_anos      as "0-4",
            homens_5_9_anos      as "5-9",
            homens_10_14_anos    as "10-14",
            homens_15_19_anos    as "15-19",
            homens_20_24_anos    as "20-24",
            homens_25_29_anos    as "25-29",
            homens_30_34_anos    as "30-34",
            homens_35_39_anos    as "35-39",
            homens_40_44_anos    as "40-44",
            homens_45_49_anos    as "45-49",
            homens_50_54_anos    as "50-54",
            homens_55_59_anos    as "55-59",
            homens_60_64_anos    as "60-64",
            homens_65_69_anos    as "65-69",
            homens_70_74_anos    as "70-74",
            homens_75_79_anos    as "75-79",
            homens_80_84_anos    as "80-84",
            homens_85_89_anos    as "85-89",
            homens_90_94_anos    as "90-94",
            homens_95_99_anos    as "95-99",
            homens_100_mais_anos as "100-mais"
        )
    )

),
----CTE FINAL DOS DADOS DE FAVELA
favela as (
select
    m.cod_ibge,
    m.faixa_etaria,
    h.homens_fav + m.mulheres_fav as pop_fav,
    m.mulheres_fav as mulheres_pop_fav,
    case
        when h.homens_fav != 0 and m.mulheres_fav != 0
        then round(m.mulheres_fav / (h.homens_fav + m.mulheres_fav),4)
        else 0
    end    as mulheres_pop_fav_perct
from mulheres_favela m
inner join homens_favela h
on  m.cod_ibge =  h.cod_ibge
and m.faixa_etaria = h.faixa_etaria
)

select * from favela

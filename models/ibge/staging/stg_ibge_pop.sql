{{ config(
    materialized='table',
    tags = ['ibge','população']
) }}

with
----------------------------------P     O   P   U   L   A   Ç   Ã   O---------------------------------------------------
---MAIN CTE
main_cte as (
select
*
from {{ ref('rfn_ibge_pop') }}
where nivel = 'MU'
),

----OS DADOS NÃO POSSUEM FAIXA ETÁRIA 15-19 ANOS. ESSA CTE CALCULA
cte_faixa_faltante as (
    select
        *,

        mulheres_total - (
            mulheres_0_4_anos +
            mulheres_5_9_anos +
            mulheres_10_14_anos +
            mulheres_20_24_anos +
            mulheres_25_29_anos +
            mulheres_30_34_anos +
            mulheres_35_39_anos +
            mulheres_40_44_anos +
            mulheres_45_49_anos +
            mulheres_50_54_anos +
            mulheres_55_59_anos +
            mulheres_60_64_anos +
            mulheres_65_69_anos +
            mulheres_70_74_anos +
            mulheres_75_79_anos +
            mulheres_80_84_anos +
            mulheres_85_89_anos +
            mulheres_90_94_anos +
            mulheres_95_99_anos +
            mulheres_100_mais_anos
        ) as mulheres_15_19_anos,

        homens_total - (
            homens_0_4_anos +
            homens_5_9_anos +
            homens_10_14_anos +
            homens_20_24_anos +
            homens_25_29_anos +
            homens_30_34_anos +
            homens_35_39_anos +
            homens_40_44_anos +
            homens_45_49_anos +
            homens_50_54_anos +
            homens_55_59_anos +
            homens_60_64_anos +
            homens_65_69_anos +
            homens_70_74_anos +
            homens_75_79_anos +
            homens_80_84_anos +
            homens_85_89_anos +
            homens_90_94_anos +
            homens_95_99_anos +
            homens_100_mais_anos
        ) as homens_15_19_anos

    from main_cte
),

---UNPIVOT DAS MULHERES
mulheres as (
    select
        cod_ibge,
        faixa_etaria,
        mulheres

    from cte_faixa_faltante

    unpivot include nulls (
            mulheres  for faixa_etaria in (
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
homens as (
    select
        cod_ibge,
        faixa_etaria,
        homens

    from cte_faixa_faltante

    unpivot include nulls (
            homens  for faixa_etaria in (
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
----CTE FINAL DOS DADOS
populcao as (
select
    m.cod_ibge,
    m.faixa_etaria,
    h.homens + m.mulheres as pop_total,
    m.mulheres as mulheres_pop,
    case
        when h.homens != 0 and m.mulheres != 0
        then round(m.mulheres / (h.homens + m.mulheres),4)
        else 0
    end    as mulheres_pop_perct
from mulheres m
inner join homens h
on  m.cod_ibge =  h.cod_ibge
and m.faixa_etaria = h.faixa_etaria
),


----POVOS ORIGIÁRIOS
indigena as (
    select
        *,
        'Total' as faixa_etaria,
    from {{ ref('rfn_ibge_ind') }}
)

select
    *
from populcao

{{ config(
    tags = ['ibge','demografia','população'],
    s3_data_dir = bucket() ~ '/staging/'
) }}

with
----------------------------------P     O   P   U   L   A   Ç   Ã   O---------------------------------------------------
---MAIN CTE
main_cte as (
select
    *
from {{ ref('rfn_demo_pop') }}
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
        faixa.cod_ibge,
        unpivot.faixa_etaria,
        unpivot.mulheres

    from cte_faixa_faltante faixa
    cross join unnest (
        array [
               'Total',
               '0-4',
               '5-9',
               '10-14',
               '15-19',
               '20-24',
               '25-29',
               '30-34',
               '35-39',
               '40-44',
               '45-49',
               '50-54',
               '55-59',
               '60-64',
               '65-69',
               '70-74',
               '75-79',
               '80-84',
               '85-89',
               '90-94',
               '95-99',
               '100-mais'
        ],
        array [
                mulheres_total,
                mulheres_0_4_anos,
                mulheres_5_9_anos,
                mulheres_10_14_anos,
                mulheres_15_19_anos,
                mulheres_20_24_anos,
                mulheres_25_29_anos,
                mulheres_30_34_anos,
                mulheres_35_39_anos,
                mulheres_40_44_anos,
                mulheres_45_49_anos,
                mulheres_50_54_anos,
                mulheres_55_59_anos,
                mulheres_60_64_anos,
                mulheres_65_69_anos,
                mulheres_70_74_anos,
                mulheres_75_79_anos,
                mulheres_80_84_anos,
                mulheres_85_89_anos,
                mulheres_90_94_anos,
                mulheres_95_99_anos,
                mulheres_100_mais_anos
        ]
    ) as unpivot (faixa_etaria,mulheres)

),

---UNPIVOT DAS HOMENS
homens as (
    select
        faixa.cod_ibge,
        unpivot.faixa_etaria,
        unpivot.homens

    from cte_faixa_faltante faixa
    cross join unnest (
        array [
               'Total',
               '0-4',
               '5-9',
               '10-14',
               '15-19',
               '20-24',
               '25-29',
               '30-34',
               '35-39',
               '40-44',
               '45-49',
               '50-54',
               '55-59',
               '60-64',
               '65-69',
               '70-74',
               '75-79',
               '80-84',
               '85-89',
               '90-94',
               '95-99',
               '100-mais'
        ],
        array [
                homens_total,
                homens_0_4_anos,
                homens_5_9_anos,
                homens_10_14_anos,
                homens_15_19_anos,
                homens_20_24_anos,
                homens_25_29_anos,
                homens_30_34_anos,
                homens_35_39_anos,
                homens_40_44_anos,
                homens_45_49_anos,
                homens_50_54_anos,
                homens_55_59_anos,
                homens_60_64_anos,
                homens_65_69_anos,
                homens_70_74_anos,
                homens_75_79_anos,
                homens_80_84_anos,
                homens_85_89_anos,
                homens_90_94_anos,
                homens_95_99_anos,
                homens_100_mais_anos
        ]
    ) as unpivot (faixa_etaria,homens)

),

----CTE FINAL DOS DADOS
populcao as (
select
    m.cod_ibge,
    m.faixa_etaria,
    h.homens + m.mulheres as pop_total,
    h.homens as homens_pop,
    m.mulheres as mulheres_pop,
    case
        when h.homens != 0 and m.mulheres != 0
        then round( cast(m.mulheres as double) / (h.homens + m.mulheres),4)
        else 0
    end    as mulheres_pop_perct,
    case
        when h.homens != 0 and m.mulheres != 0
        then round( cast(h.homens as double) / (h.homens + m.mulheres),4)
        else 0
    end    as homens_pop_perct
from mulheres m
inner join homens h
on  m.cod_ibge =  h.cod_ibge
and m.faixa_etaria = h.faixa_etaria
)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from populcao

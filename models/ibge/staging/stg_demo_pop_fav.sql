{{ config(
    tags = ['ibge','demografia','população','favela'],
    s3_data_dir = bucket() ~ '/staging/'
) }}

with
----------------------------------F     A   V   E   L   A ---------------------------------------------------------------
---MAIN CTE
cte_favela as (
select
*
from {{ ref('rfn_demo_pop_fav') }}
),

---UNPIVOT DAS MULHERES
mulheres_favela as (
    select
        cod_ibge,
        unpivot.faixa_etaria,
        unpivot.mulheres_fav

    from cte_favela
    cross join unnest(
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
        array[
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
    ) as unpivot(faixa_etaria,mulheres_fav)
),

---UNPIVOT DAS HOMENS
homens_favela as (
    select
        cod_ibge,
        unpivot.faixa_etaria,
        unpivot.homens_fav

    from cte_favela
    cross join unnest(
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
        array[
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
    ) as unpivot(faixa_etaria,homens_fav)
),


----CTE FINAL DOS DADOS DE FAVELA
favela as (
select
    m.cod_ibge,
    'MU' as nivel,
    m.faixa_etaria,
    h.homens_fav + m.mulheres_fav as pop_fav,
    h.homens_fav as homens_pop_fav,
    m.mulheres_fav as mulheres_pop_fav
from mulheres_favela m
inner join homens_favela h
on  m.cod_ibge =  h.cod_ibge
and m.faixa_etaria = h.faixa_etaria
),

uf as (
select
    substring(cod_ibge, 1,2) as cod_ibge,
    'UF' as nivel,
    fav.faixa_etaria,
    sum(fav.pop_fav) as pop_fav,
    sum(fav.mulheres_pop_fav) as mulheres_pop_fav,
    sum(fav.homens_pop_fav) as homens_pop_fav
from favela fav
group by 1,3
),

regiao as (
select
    substring(cod_ibge, 1,1) as cod_ibge,
    'REGIAO' as nivel,
    fav.faixa_etaria,
    sum(fav.pop_fav) as pop_fav,
    sum(fav.mulheres_pop_fav) as mulheres_pop_fav,
    sum(fav.homens_pop_fav) as homens_pop_fav
from favela fav
group by 1,3
)

select * from uf union all
select * from regiao union all
select * from favela


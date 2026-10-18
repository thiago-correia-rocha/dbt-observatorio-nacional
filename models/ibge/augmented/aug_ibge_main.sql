{{ config(
    materialized='table',
    tags = ['ibge','população','alfabetização','faixa etária']
) }}
select
    pop.cod_ibge,
    pop.faixa_etaria,
    pop.mulheres_pop,
    fav.mulheres_pop_fav,
    round(fav.mulheres_pop_fav/nullif(pop.mulheres_pop, 0),4) as mulheres_pop_total_fav_perct
    fav.mulheres_pop_fav_perct,
    alfa.mulheres_alfabetizadas as mulheres_alfa,
    round((alfa.mulheres_alfabetizadas/pop.mulheres_pop),4)   as mulheres_alfa_perct
from {{ ref('stg_ibge_pop') }} pop
inner join {{ ref('stg_ibge_pop_fav') }} fav
on pop.cod_ibge = fav.cod_ibge
and pop.faixa_etaria = fav.faixa_etaria
left join {{ ref('stg_ibge_alfa') }} alfa
on pop.cod_ibge = alfa.cod_ibge
and pop.faixa_etaria = alfa.faixa_etaria

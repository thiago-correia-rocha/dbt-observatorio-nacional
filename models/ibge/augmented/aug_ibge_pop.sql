{{ config(
    materialized='table',
    tags = ['ibge','população','faixa etária']
) }}
select
    pop.cod_ibge,
    pop.faixa_etaria,
    pop.mulheres_pop,
    fav.mulheres_pop_fav,
    case
        when fav.pop_fav != 0
        then round( (fav.mulheres_pop_fav/pop.mulheres_pop) , 4)
        else 0
    end as mulheres_pop_total_fav_perct,
    fav.mulheres_pop_fav_perct
from {{ ref('stg_ibge_pop') }} pop
inner join {{ ref('stg_ibge_pop_fav') }} fav
on pop.cod_ibge = fav.cod_ibge
and pop.faixa_etaria = fav.faixa_etaria

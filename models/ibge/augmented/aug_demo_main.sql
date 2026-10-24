{{
    config(
        tags = ['ibge','população','alfabetização','favela','faixa etária'],
        s3_data_dir = bucket() ~ '/augmented/'
    )
}}

select
    pop.cod_ibge,
    pop.faixa_etaria,
    pop.pop_total,
    cast(fav.homens_pop_fav as double) + cast(fav.mulheres_pop_fav as double) as pop_fav,
    (cast(fav.homens_pop_fav as double) + cast(fav.mulheres_pop_fav as double)) / cast(pop_total as double) as pop_fav_perc,
    cast(homens_alfa as double) + cast(mulheres_alfa as double) as pop_alfa,
    (cast(homens_alfa as double) + cast(mulheres_alfa as double)) / cast(pop_total as double) as pop_alfa_perc,
    pop.homens_pop,
    fav.homens_pop_fav,
    round(cast(fav.homens_pop_fav as double)/nullif(pop.homens_pop, 0),4) as homens_pop_total_fav_perct,
    fav.homens_pop_fav_perct,
    alfa.homens_alfa as homens_alfa,
    round((cast(alfa.homens_alfa as double)/pop.mulheres_pop),4)   as homens_alfa_perct,
    pop.mulheres_pop,
    fav.mulheres_pop_fav,
    round(cast(fav.mulheres_pop_fav as double)/nullif(pop.mulheres_pop, 0),4) as mulheres_pop_total_fav_perct,
    fav.mulheres_pop_fav_perct,
    alfa.mulheres_alfa as mulheres_alfa,
    round((cast(alfa.mulheres_alfa as double)/pop.mulheres_pop),4)   as mulheres_alfa_perct,
    cast(current_timestamp as timestamp) as refresh_dt

from {{ ref('stg_demo_pop') }} pop

inner join {{ ref('stg_demo_pop_fav') }} fav
on pop.cod_ibge = fav.cod_ibge
and pop.faixa_etaria = fav.faixa_etaria

left join {{ ref('stg_demo_alfa') }} alfa
on pop.cod_ibge = alfa.cod_ibge
and pop.faixa_etaria = alfa.faixa_etaria

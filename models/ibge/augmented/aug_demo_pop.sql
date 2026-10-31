{{
    config(
        tags = ['ibge','população','alfabetização','favela','faixa etária'],
        s3_data_dir = bucket() ~ '/augmented/ibge/parquet/'
    )
}}


select
    --Localização e Faixa etária
    loc.cod_ibge,
    loc.nivel,
    loc.descricao,
    pop.faixa_etaria,

    --Demografia Principal
    pop.pop_total,
    pop.mulheres_pop,
    pop.mulheres_pop_perct,
    pop.homens_pop,
    pop.homens_pop_perct,
    pop.ranking as pop_ranking,
    case
        when pop.pop_total != 0
        then round(cast(pop.pop_total  as double) / cast(hab.col_total as double),2)
        else 0
    end as pop_per_dom,

    --Alfabetização
    cast(alfa.total_alfa as double) as pop_alfa,
    alfa.total_alfa_perct as pop_alfa_perc,
    alfa.mulheres_alfa as mulheres_alfa,
    alfa.mulheres_alfa_perct as mulheres_alfa_perct,
    alfa.homens_alfa as homens_alfa,
    alfa.homens_alfa_perct as homens_alfa_perct,
    alfa.ranking as alfa_ranking,


    --Favela
    fav.pop_fav,
    round(cast(pop_fav as double) / cast(pop_total as double),5) as pop_fav_perct,
    fav.mulheres_pop_fav,
    round(cast(mulheres_pop_fav as double) / cast(pop_total as double),4) as mulheres_pop_fav_perct,
    fav.homens_pop_fav,
    round(cast(homens_pop_fav as double) / cast(pop_total as double),4) as homens_pop_fav_perct,
    case
        when fav.pop_fav != 0
        then round(cast(fav.pop_fav  as double) / cast(hab_fav.domicilios_fav as double),2)
        else 0
    end as fav_pop_per_dom,
    cast(current_timestamp as timestamp) as refresh_dt

from {{ ref('stg_demo_pop') }} pop

left join {{ ref('stg_demo_pop_fav') }} fav
on pop.cod_ibge = fav.cod_ibge
and pop.nivel = fav.nivel
and pop.faixa_etaria = fav.faixa_etaria

left join {{ ref('stg_demo_alfa') }} alfa
on pop.cod_ibge = alfa.cod_ibge
and pop.nivel = alfa.nivel
and pop.faixa_etaria = alfa.faixa_etaria

left join {{ ref('dim_demo_local') }} loc
on  pop.cod_ibge = loc.cod_ibge
and pop.nivel = loc.nivel

left join {{ ref('stg_demo_hab') }} hab
on pop.cod_ibge = hab.cod_ibge
and pop.nivel = hab.nivel
and pop.faixa_etaria = 'Total'

left join {{ ref('stg_demo_hab_fav') }} hab_fav
on pop.cod_ibge = hab_fav.cod_ibge
and pop.nivel = hab_fav.nivel
and pop.faixa_etaria = 'Total'

{{
    config(
        tags = ['ibge','população','alfabetização','cor e raça','favela','faixa etária', 'povo originário','religião'],
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

    --Cor e Raça
    round(cast(cor.branca as double) / pop.pop_total, 4) as branca_perct,
    round(cast(cor.preta as double) / pop.pop_total, 4) as preta_perct,
    round(cast(cor.amarela as double) / pop.pop_total, 4) as amarela_perct,
    round(cast(cor.parda as double) / pop.pop_total, 4) as parda_perct,
    round(cast(cor.indigena as double) / pop.pop_total, 4) as indigena_perct,


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

    --Povos Originários
	ind_total,
	ind_em_terras_total,
    ind_em_terras_total_perct,
    ind_fora_terras_total,
    ind_fora_terras_total_perct,
    ind_homens,
    ind_homens_perct,
    ind_em_terras_homens,
    ind_fora_terras_homens,
    ind_mulheres,
    ind_mulheres_perct,
    ind_em_terras_mulheres,
    ind_fora_terras_mulheres,
    quilo_total,
    quilo_em_terras,
    quilo_em_terras_perct,
    quilo_fora_terras,
    quilo_fora_terras_perct,

    --Religiões
    rel.total as rel_total,
    rel.totalcatolica_perct as rel_totalcatolica_perct,
    rel.totalevangelica_perct as rel_totalevangelica_perct,
    rel.total_cristao_perct as rel_total_cristao_perct,
    rel.totalespirita_perct as rel_totalespirita_perct,
    rel.totalumbanda_perct as rel_totalumbanda_perct,
    rel.totaltradind_perct as rel_totaltradind_perct,
    rel.totaloutras_perct as rel_totaloutras_perct,
    rel.totalateu_perct as rel_totalateu_perct,
    rel.totalnaosabe_perct as rel_totalnaosabe_perct,
    rel.totalsd_perct as rel_totalsd_perct,


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

left join {{ ref('stg_demo_pop_pov') }} pov
on pop.cod_ibge = pov.cod_ibge
and pop.nivel = pov.nivel
and pop.faixa_etaria = 'Total'

left join {{ ref('stg_demo_pop_rel') }} rel
on pop.cod_ibge = rel.cod_ibge
and pop.nivel = rel.nivel
and pop.faixa_etaria = 'Total'

left join {{ ref('stg_demo_pop_cor') }} cor
on pop.cod_ibge = cor.cod_ibge
and pop.nivel = cor.nivel
and pop.faixa_etaria = 'Total'
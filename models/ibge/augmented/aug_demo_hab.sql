{{
    config(
        tags = ['ibge','demografia','habitação','saneamento','favela'],
        s3_data_dir = bucket() ~ '/augmented/ibge/parquet/'
    )
}}

with
final as (
select
     stg.cod_ibge ,
     stg.nivel,
     loc.descricao,

     -- Coleta de lixo
     round(cast(stg.col_coletado as double) / cast(stg.col_total as double) , 5) as col_coletado_perct,
     stg.col_total,
     stg.col_coletado,
     stg.col_queimado,
     stg.col_enterrado,
     stg.col_jogado,
     stg.col_outro_destino,

     -- Esgotamento sanitário
     round(cast(stg.esg_rede_geral as double) / cast(stg.esg_total as double) , 5) as esg_rede_geral_perct,
     stg.esg_total,
     stg.esg_rede_geral,
     stg.esg_fossa_septica,
     stg.esg_fossa_rudimentar_buraco,
     stg.esg_vala,
     stg.esg_rio_lago_corrego_mar,
     stg.esg_outra_forma,
     stg.esg_sem_banheiro,

     -- Abastecimento de água
     round(cast(stg.abas_rede_geral as double) / cast(stg.abas_total as double) , 5) as abas_rede_geral_perct,
     stg.abas_total,
     stg.abas_rede_geral,
     stg.abas_poco_artesiano,
     stg.abas_poco_raso,
     stg.abas_fonte_nascente,
     stg.abas_carro_pipa,
     stg.abas_agua_chuva,
     stg.abas_rios_acudes,
     stg.abas_outra,
     --stg.abas_abastecimento,
     --stg.abas_ranking,

     -- Banheiros e sanitários
     round(cast(stg.ban_banheiro_exclusivo as double) / cast(stg.ban_total as double) , 5) as ban_banheiro_exclusivo_perct,
     stg.ban_total,
     stg.ban_banheiro_exclusivo,
     stg.ban_banheiro_uso_comum,
     stg.ban_apenas_sanitario,
     stg.ban_sem_banheiro,

     -- Qtde. Favelas (apenas UFs)
     fav.qtd_fav as fav_qtd_fav,
     fav.domicilios_fav as fav_dom,
     fav.qtd_mun_fav as fav_qtd_mun,
     ranking_qtd_fav as fav_ranking_qtd_fav

from {{ ref('stg_demo_hab') }} stg
left join {{ ref('stg_demo_hab_fav') }} fav
on stg.cod_ibge = fav.cod_ibge
and stg.nivel = fav.nivel
left join {{ ref('dim_demo_local') }} loc
on  stg.cod_ibge = loc.cod_ibge
and stg.nivel = loc.nivel
)
select
    *,
    dense_rank() over (partition by nivel order by col_coletado_perct desc) as col_ranking,
    dense_rank() over (partition by nivel order by esg_rede_geral_perct desc) as esg_ranking,
    dense_rank() over (partition by nivel order by abas_rede_geral_perct desc) as abas_ranking,
    dense_rank() over (partition by nivel order by ban_banheiro_exclusivo_perct desc) as  ban_ranking,
    ( col_coletado_perct + esg_rede_geral_perct + abas_rede_geral_perct + ban_banheiro_exclusivo_perct) / 4 as ranking_total,
    cast(current_timestamp as timestamp) as refresh_dt
from final

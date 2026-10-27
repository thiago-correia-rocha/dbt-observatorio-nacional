{{
    config(
        tags = ['ibge','demografia','habitação','saneamento','favela'],
        s3_data_dir = bucket() ~ '/augmented/'
    )
}}

select
     cast(stg.cod_ibge as int) as cod_ibge,
     stg.nivel,

     -- Coleta de lixo
     stg.col_total,
     stg.col_coletado,
     stg.col_queimado,
     stg.col_enterrado,
     stg.col_jogado,
     stg.col_outro_destino,

     -- Esgotamento sanitário
     stg.esg_total,
     stg.esg_rede_geral,
     stg.esg_fossa_septica,
     stg.esg_fossa_rudimentar_buraco,
     stg.esg_vala,
     stg.esg_rio_lago_corrego_mar,
     stg.esg_outra_forma,
     stg.esg_sem_banheiro,
     stg.esg_esgoto_perct,
     stg.esg_ranking,

     -- Abastecimento de água
     stg.abas_total,
     stg.abas_rede_geral,
     stg.abas_poco_artesiano,
     stg.abas_poco_raso,
     stg.abas_fonte_nascente,
     stg.abas_carro_pipa,
     stg.abas_agua_chuva,
     stg.abas_rios_acudes,
     stg.abas_outra,
     stg.abas_abastecimento,
     stg.abas_ranking,

     -- Banheiros e sanitários
     stg.ban_total,
     stg.ban_banheiro_exclusivo,
     stg.ban_banheiro_uso_comum,
     stg.ban_apenas_sanitario,
     stg.ban_sem_banheiro,

     -- Qtde. Favelas (apenas UFs)
     fav.qtd_favelas,

     cast(current_timestamp as timestamp) as refresh_dt

from {{ ref('stg_demo_hab') }} stg
left join {{ ref('stg_demo_hab_fav') }} fav
on stg.cod_ibge = fav.cod_ibge

{{ config(
    tags = ['ibge','demografia','habitação','saneamento'],
    s3_data_dir = bucket() ~ '/staging/'
) }}

with
coleta as (
select
    cod_ibge,
    nivel,
    total as col_total,
    coletado as col_coletado,
    queimado as col_queimado,
    enterrado as col_enterrado,
    jogado as col_jogado,
    outro_destino as col_outro_destino
from {{ ref('rfn_demo_hab_col') }}
),
esgoto as (
select
    cod_ibge,
    nivel,
    total as esg_total,
    rede_geral as esg_rede_geral,
    fossa_septica as esg_fossa_septica,
    fossa_rudimentar_buraco as esg_fossa_rudimentar_buraco,
    vala as esg_vala ,
    rio_lago_corrego_mar as esg_rio_lago_corrego_mar,
    outra_forma as esg_outra_forma,
    sem_banheiro as esg_sem_banheiro,
    esgoto_perct as esg_esgoto_perct,
    ranking as esg_ranking
from {{ ref('rfn_demo_hab_esg') }}
),
abastecimento as (
select
    cod_ibge,
    nivel,
    total as abas_total,
    rede_geral as abas_rede_geral,
    poco_artesiano as abas_poco_artesiano,
    poco_raso as abas_poco_raso,
    fonte_nascente as abas_fonte_nascente,
    carro_pipa as abas_carro_pipa,
    agua_chuva as abas_agua_chuva,
    rios_acudes as abas_rios_acudes,
    outra as abas_outra,
    abastecimento as abas_abastecimento,
    ranking as abas_ranking
from {{ ref('rfn_demo_hab_abas') }}
),
banheiro as (
select
    cod_ibge,
    nivel,
    total as ban_total,
    banheiro_exclusivo as ban_banheiro_exclusivo,
    banheiro_uso_comum as ban_banheiro_uso_comum,
    apenas_sanitario as ban_apenas_sanitario,
    sem_banheiro as ban_sem_banheiro
from {{ ref('rfn_demo_hab_ban') }}
),
--Tabela main com BR,UF e Municipios
saneamento as(
select
     col.cod_ibge,
     col.nivel,
     -- Coleta de lixo
     col.col_total,
     col.col_coletado,
     col.col_queimado,
     col.col_enterrado,
     col.col_jogado,
     col.col_outro_destino,

     -- Esgotamento sanitário
     esg.esg_total,
     esg.esg_rede_geral,
     esg.esg_fossa_septica,
     esg.esg_fossa_rudimentar_buraco,
     esg.esg_vala,
     esg.esg_rio_lago_corrego_mar,
     esg.esg_outra_forma,
     esg.esg_sem_banheiro,

     -- Abastecimento de água
     abas.abas_total,
     abas.abas_rede_geral,
     abas.abas_poco_artesiano,
     abas.abas_poco_raso,
     abas.abas_fonte_nascente,
     abas.abas_carro_pipa,
     abas.abas_agua_chuva,
     abas.abas_rios_acudes,
     abas.abas_outra,

     -- Banheiros e sanitários
     ban.ban_total,
     ban.ban_banheiro_exclusivo,
     ban.ban_banheiro_uso_comum,
     ban.ban_apenas_sanitario,
     ban.ban_sem_banheiro

from coleta col
inner join esgoto esg
on col.cod_ibge = esg.cod_ibge
inner join abastecimento abas
on col.cod_ibge = abas.cod_ibge
inner join banheiro ban
on col.cod_ibge = ban.cod_ibge
),

--Acrescenta as Regioes
regioes_base as (
    select
        case
            when cast(cod_ibge as varchar) in ('11', '12', '13', '14', '15', '16', '17')
            then '1'
            when cast(cod_ibge as varchar) in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
            then '2'
            when cast(cod_ibge as varchar) in ('31', '32', '33', '35')
            then '3'
            when cast(cod_ibge as varchar) in ('41', '42', '43')
            then '4'
            when cast(cod_ibge as varchar) in ('50', '51', '52', '53')
            then '5'
        end as cod_ibge,

        -- Coleta de lixo
        col_total,
        col_coletado,
        col_queimado,
        col_enterrado,
        col_jogado,
        col_outro_destino,

        -- Esgotamento sanitário
        esg_total,
        esg_rede_geral,
        esg_fossa_septica,
        esg_fossa_rudimentar_buraco,
        esg_vala,
        esg_rio_lago_corrego_mar,
        esg_outra_forma,
        esg_sem_banheiro,

        -- Abastecimento de água
        abas_total,
        abas_rede_geral,
        abas_poco_artesiano,
        abas_poco_raso,
        abas_fonte_nascente,
        abas_carro_pipa,
        abas_agua_chuva,
        abas_rios_acudes,
        abas_outra,

        -- Banheiros e sanitários
        ban_total,
        ban_banheiro_exclusivo,
        ban_banheiro_uso_comum,
        ban_apenas_sanitario,
        ban_sem_banheiro

    from saneamento
    where nivel = 'UF'
),

regioes as (
    select
        cod_ibge ,
        'REGIAO' as nivel,
        -- Coleta de lixo
        sum(cast(col_total as bigint)) as col_total,
        sum(cast(col_coletado as bigint)) as col_coletado,
        sum(cast(col_queimado as bigint)) as col_queimado,
        sum(cast(col_enterrado as bigint)) as col_enterrado,
        sum(cast(col_jogado as bigint)) as col_jogado,
        sum(cast(col_outro_destino as bigint)) as col_outro_destino,

        -- Esgotamento sanitário
        sum(cast(esg_total as bigint)) as esg_total,
        sum(cast(esg_rede_geral as bigint)) as esg_rede_geral,
        sum(cast(esg_fossa_septica as bigint)) as esg_fossa_septica,
        sum(cast(esg_fossa_rudimentar_buraco as bigint)) as esg_fossa_rudimentar_buraco,
        sum(cast(esg_vala as bigint)) as esg_vala,
        sum(cast(esg_rio_lago_corrego_mar as bigint)) as esg_rio_lago_corrego_mar,
        sum(cast(esg_outra_forma as bigint)) as esg_outra_forma,
        sum(cast(esg_sem_banheiro as bigint)) as esg_sem_banheiro,


        -- Abastecimento de água
        sum(cast(abas_total as bigint)) as abas_total,
        sum(cast(abas_rede_geral as bigint)) as abas_rede_geral,
        sum(cast(abas_poco_artesiano as bigint)) as abas_poco_artesiano,
        sum(cast(abas_poco_raso as bigint)) as abas_poco_raso,
        sum(cast(abas_fonte_nascente as bigint)) as abas_fonte_nascente,
        sum(cast(abas_carro_pipa as bigint)) as abas_carro_pipa,
        sum(cast(abas_agua_chuva as bigint)) as abas_agua_chuva,
        sum(cast(abas_rios_acudes as bigint)) as abas_rios_acudes,
        sum(cast(abas_outra as bigint)) as abas_outra,

        -- Banheiros e sanitários
        sum(cast(ban_total as bigint)) as ban_total,
        sum(cast(ban_banheiro_exclusivo as bigint)) as ban_banheiro_exclusivo,
        sum(cast(ban_banheiro_uso_comum as bigint)) as ban_banheiro_uso_comum,
        sum(cast(ban_apenas_sanitario as bigint)) as ban_apenas_sanitario,
        sum(cast(ban_sem_banheiro as bigint)) as ban_sem_banheiro

    from regioes_base
    where cod_ibge is not null
    group by cod_ibge
),
final as (
    select * from saneamento union all
    select * from regioes
)
select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
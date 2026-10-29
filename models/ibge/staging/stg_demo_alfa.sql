{{  config(
    tags = ['ibge','demografia','alfabetização'],
    s3_data_dir = bucket() ~ '/staging/'
) }}

with
cte_rfn as (
select
    cod as cod_ibge,
    idade as faixa_etaria,
    nivel,
    total_alfabetizadas as total_alfa,
    total_nao_alfabetizadas as total_n_alfa,
    round( cast(total_alfabetizadas as double) / (total_alfabetizadas + total_nao_alfabetizadas),5) as total_alfa_perct,
    mulheres_alfabetizadas as mulheres_alfa,
    mulheres_nao_alfabetizadas as mulheres_n_alfa,
    round( cast(mulheres_alfabetizadas  as double) / (mulheres_alfabetizadas + mulheres_nao_alfabetizadas),4)  as mulheres_alfa_perct,
    homens_alfabetizados as homens_alfa,
    homens_nao_alfabetizados as homens_n_alfa,
    round( cast(homens_alfabetizados  as double) / (homens_alfabetizados + homens_nao_alfabetizados),4)  as homens_alfa_perct
from {{ ref('rfn_demo_alfa') }}
),

norte as (
    select
        '1' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(total_alfa) as total_alfa,
        sum(total_n_alfa) as total_n_alfa,
        round(cast(sum(total_alfa) as double) / (sum(total_alfa) + sum(total_n_alfa)),5) as total_alfa_perct,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(mulheres_n_alfa) as mulheres_n_alfa,
        round(cast(sum(mulheres_alfa) as double) / (sum(mulheres_alfa) + sum(mulheres_n_alfa)),4) as mulheres_alfa_perct,
        sum(homens_alfa) as homens_alfa,
        sum(homens_n_alfa) as homens_n_alfa,
        round(cast(sum(homens_alfa) as double) / (sum(homens_alfa) + sum(homens_n_alfa)),4) as homens_alfa_perct
    from cte_rfn
    where nivel = 'UF'
      and cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
    group by faixa_etaria
),

nordeste as (
    select
        '2' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(total_alfa) as total_alfa,
        sum(total_n_alfa) as total_n_alfa,
        round(cast(sum(total_alfa) as double) / (sum(total_alfa) + sum(total_n_alfa)),5) as total_alfa_perct,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(mulheres_n_alfa) as mulheres_n_alfa,
        round(cast(sum(mulheres_alfa) as double) / (sum(mulheres_alfa) + sum(mulheres_n_alfa)),4) as mulheres_alfa_perct,
        sum(homens_alfa) as homens_alfa,
        sum(homens_n_alfa) as homens_n_alfa,
        round(cast(sum(homens_alfa) as double) / (sum(homens_alfa) + sum(homens_n_alfa)),4) as homens_alfa_perct
    from cte_rfn
    where nivel = 'UF'
      and cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
    group by faixa_etaria
),

sudeste as (
    select
        '3' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(total_alfa) as total_alfa,
        sum(total_n_alfa) as total_n_alfa,
        round(cast(sum(total_alfa) as double) / (sum(total_alfa) + sum(total_n_alfa)),5) as total_alfa_perct,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(mulheres_n_alfa) as mulheres_n_alfa,
        round(cast(sum(mulheres_alfa) as double) / (sum(mulheres_alfa) + sum(mulheres_n_alfa)),4) as mulheres_alfa_perct,
        sum(homens_alfa) as homens_alfa,
        sum(homens_n_alfa) as homens_n_alfa,
        round(cast(sum(homens_alfa) as double) / (sum(homens_alfa) + sum(homens_n_alfa)),4) as homens_alfa_perct
    from cte_rfn
    where nivel = 'UF'
    and cod_ibge in ('31', '32', '33', '35')
    group by faixa_etaria
),

sul as (
    select
        '4' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(total_alfa) as total_alfa,
        sum(total_n_alfa) as total_n_alfa,
        round(cast(sum(total_alfa) as double) / (sum(total_alfa) + sum(total_n_alfa)),5) as total_alfa_perct,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(mulheres_n_alfa) as mulheres_n_alfa,
        round(cast(sum(mulheres_alfa) as double) / (sum(mulheres_alfa) + sum(mulheres_n_alfa)),4) as mulheres_alfa_perct,
        sum(homens_alfa) as homens_alfa,
        sum(homens_n_alfa) as homens_n_alfa,
        round(cast(sum(homens_alfa) as double) / (sum(homens_alfa) + sum(homens_n_alfa)),4) as homens_alfa_perct
    from cte_rfn
    where nivel = 'UF'
    and cod_ibge in ('41', '42', '43')
    group by faixa_etaria
),

centro_oeste as (
    select
        '5' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(total_alfa) as total_alfa,
        sum(total_n_alfa) as total_n_alfa,
        round(cast(sum(total_alfa) as double) / (sum(total_alfa) + sum(total_n_alfa)),5) as total_alfa_perct,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(mulheres_n_alfa) as mulheres_n_alfa,
        round(cast(sum(mulheres_alfa) as double) / (sum(mulheres_alfa) + sum(mulheres_n_alfa)),4) as mulheres_alfa_perct,
        sum(homens_alfa) as homens_alfa,
        sum(homens_n_alfa) as homens_n_alfa,
        round(cast(sum(homens_alfa) as double) / (sum(homens_alfa) + sum(homens_n_alfa)),4) as homens_alfa_perct
    from cte_rfn
    where nivel = 'UF'
      and cod_ibge in ('50', '51', '52', '53')
    group by faixa_etaria
),

cte_main as (
    select * from cte_rfn union all
    select * from norte union all
    select * from nordeste union all
    select * from centro_oeste union all
    select * from sudeste union all
    select * from sul
),

final as (
    select
        *,
        dense_rank() over (partition by nivel order by total_alfa_perct desc) as ranking
    from cte_main
)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
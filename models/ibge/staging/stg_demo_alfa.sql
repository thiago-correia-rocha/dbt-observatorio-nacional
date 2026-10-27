{{  config(
    tags = ['ibge','demografia','alfabetização'],
    s3_data_dir = bucket() ~ '/staging/'
) }}

with
cte_main as (
select
    cod as cod_ibge,
    idade as faixa_etaria,
    nivel,
    mulheres_alfabetizadas as mulheres_alfa,
    homens_alfabetizados as homens_alfa
from {{ ref('rfn_demo_alfa') }}
),

norte as (
    select
        '1' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(homens_alfa) as homens_alfa
    from cte_main
    where nivel = 'UF'
      and cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
    group by faixa_etaria
),

nordeste as (
    select
        '2' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(homens_alfa) as homens_alfa
    from cte_main
    where nivel = 'UF'
      and cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
    group by faixa_etaria
),

sudeste as (
    select
        '3' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(homens_alfa) as homens_alfa
    from cte_main
    where nivel = 'UF'
    and cod_ibge in ('31', '32', '33', '35')
    group by faixa_etaria
),

sul as (
    select
        '4' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(homens_alfa) as homens_alfa
    from cte_main
    where nivel = 'UF'
    and cod_ibge in ('41', '42', '43')
    group by faixa_etaria
),

centro_oeste as (
    select
        '5' as cod_ibge,
        faixa_etaria,
        'REGIAO' as nivel,
        sum(mulheres_alfa) as mulheres_alfa,
        sum(homens_alfa) as homens_alfa
    from cte_main
    where nivel = 'UF'
      and cod_ibge in ('50', '51', '52', '53')
    group by faixa_etaria
),

final as (
    select * from cte_main union all
    select * from norte union all
    select * from nordeste union all
    select * from centro_oeste union all
    select * from sudeste union all
    select * from sul
)

select
    *,
    cast(current_timestamp as timestamp) as refresh_dt
from final
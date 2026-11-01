{{ config(
    tags = ['ibge','demografia','população','povo originário'],
    s3_data_dir = bucket() ~ '/staging/demografia/ibge/parquet/'
) }}

with
----------------------------------Q    U   I   L   O   M   B   O---------------------------------------------------
-- Main: UF e MU
quilombola as (
    select
        cod_ibge,
        nivel,
        total as quilo_total,
        em_territorio_quilombola as quilo_em_terras,
        round(cast(em_territorio_quilombola as double)/ nullif(total, 0),4) as quilo_em_terras_perct,
        fora_territorio_quilombola as quilo_fora_terras,
        round(cast(fora_territorio_quilombola as double)/ nullif(total, 0),4) as quilo_fora_terras_perct

    from {{ ref('rfn_ibge_pop_quilo') }}
),

-- Região Norte
norte_quilo as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(quilo_total) as quilo_total,
        sum(quilo_em_terras) as quilo_em_terras,
        round(cast(sum(quilo_em_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_em_terras_perct,
        sum(quilo_fora_terras) as quilo_fora_terras,
        round(cast(sum(quilo_fora_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_fora_terras_perct

    from quilombola
    where nivel = 'UF'
    and cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
    group by 1, 2
),

-- Região Nordeste
nordeste_quilo as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(quilo_total) as quilo_total,
        sum(quilo_em_terras) as quilo_em_terras,
        round(cast(sum(quilo_em_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_em_terras_perct,
        sum(quilo_fora_terras) as quilo_fora_terras,
        round(cast(sum(quilo_fora_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_fora_terras_perct

    from quilombola
    where nivel = 'UF'
    and cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
    group by 1, 2
),

-- Região Sudeste
sudeste_quilo as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(quilo_total) as quilo_total,
        sum(quilo_em_terras) as quilo_em_terras,
        round(cast(sum(quilo_em_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_em_terras_perct,
        sum(quilo_fora_terras) as quilo_fora_terras,
        round(cast(sum(quilo_fora_terras) as double) / nullif(sum(quilo_total), 0),4) as quilo_fora_terras_perct
    from quilombola
    where nivel = 'UF'
    and cod_ibge in ('31', '32', '33', '35')
    group by 1, 2
),

-- Região Sul
sul_quilo as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(quilo_total) as quilo_total,
        sum(quilo_em_terras) as quilo_em_terras,
        round(cast(sum(quilo_em_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_em_terras_perct,
        sum(quilo_fora_terras) as quilo_fora_terras,
        round(cast(sum(quilo_fora_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_fora_terras_perct
    from quilombola
    where nivel = 'UF'
      and cod_ibge in ('41', '42', '43')
    group by 1, 2
),

-- Região Centro-Oeste
centro_quilo as (
    select
        substring(cod_ibge, 1, 1) as cod_ibge,
        'REGIAO' as nivel,
        sum(quilo_total) as quilo_total,
        sum(quilo_em_terras) as quilo_em_terras,
        round(cast(sum(quilo_em_terras) as double)/nullif(sum(quilo_total), 0), 4) as quilo_em_terras_perct,
        sum(quilo_fora_terras) as quilo_fora_terras,
        round(cast(sum(quilo_fora_terras) as double)/ nullif(sum(quilo_total), 0),4) as quilo_fora_terras_perct
    from quilombola
    where nivel = 'UF'
    and cod_ibge in ('50', '51', '52', '53')
    group by 1, 2
),

-- Consolidação dos quatro níveis geográficos
quilo_final as (
    select * from quilombola
    union all
    select * from norte_quilo
    union all
    select * from nordeste_quilo
    union all
    select * from sudeste_quilo
    union all
    select * from sul_quilo
    union all
    select * from centro_quilo
),
----------------------------------I   N    D    I   G   E   N   A---------------------------------------------------
--Main: BR,UF e MU
indigena_main as (
    select
        loc.cod_ibge,
        ind.nivel,
        sum(case
                when ind.localizacao = 'Total'
                then ind.total
                else 0
            end
        )   as ind_total,
        sum(case
                when ind.localizacao = 'Em terras indígenas'
                then ind.total
                else 0
            end
        )   as ind_em_terras_total,
        sum(case
                when ind.localizacao = 'Fora de terras indígenas'
                then ind.total
                else 0
            end
        )   as ind_fora_terras_total,
        sum(case
                when ind.localizacao = 'Total'
                then ind.homens
                else 0
            end
        )   as ind_homens,
        sum(case
                when ind.localizacao = 'Em terras indígenas'
                then ind.homens
                else 0
            end
        )   as ind_em_terras_homens,
        sum(case
                when ind.localizacao = 'Fora de terras indígenas'
                then ind.homens
                else 0
            end
        )   as ind_fora_terras_homens,
        sum(case
                when ind.localizacao = 'Total'
                then ind.mulheres
                else 0
            end
        )   as ind_mulheres,
        sum(case
                when ind.localizacao = 'Em terras indígenas'
                then ind.mulheres
                else 0
            end
        )   as ind_em_terras_mulheres,
        sum(case
                when ind.localizacao = 'Fora de terras indígenas'
                then ind.mulheres
                else 0
            end
        )   as ind_fora_terras_mulheres

    from {{ ref('rfn_ibge_pop_ind') }} ind
    left join {{ ref('rfn_ibge_local') }} loc
    on ind.cep = loc.municipio
    and ind.nivel = loc.nivel
    group by 1,2
),
indigena as (
    select
        cod_ibge,
        nivel,
        ind_total,
        ind_em_terras_total,
        case
            when ind_total != 0
            then round(cast(ind_em_terras_total as double) / ind_total, 4)
            else 0
        end as ind_em_terras_total_perct,
        ind_fora_terras_total,
        case
            when ind_total != 0
            then round(cast(ind_fora_terras_total as double) / ind_total, 4)
            else 0
        end as ind_fora_terras_total_perct,
        ind_homens,
        case
            when ind_total != 0
            then round(cast(ind_homens as double) / ind_total, 4)
            else 0
        end as ind_homens_perct,
        ind_em_terras_homens,
        ind_fora_terras_homens,
        ind_mulheres,
        case
            when ind_total != 0
            then round(cast(ind_mulheres as double) / ind_total, 4)
            else 0
        end as ind_mulheres_perct,
        ind_em_terras_mulheres,
        ind_fora_terras_mulheres
    from indigena_main
),
-- Região Norte
norte_ind as (
    select
        substring(cod_ibge,1,1) as cod_ibge,
        'REGIAO' as nivel,
		sum(ind_total) as ind_total,
		sum(ind_em_terras_total) as ind_em_terras_total,
        round(cast(sum(ind_em_terras_total) as double) / sum(ind_total),4) as ind_em_terras_total_perct,
        sum(ind_fora_terras_total) as ind_fora_terras_total,
        round(cast(sum(ind_fora_terras_total) as double) / sum(ind_total),4) as ind_fora_terras_total_perct,
        sum(ind_homens) as ind_homens,
        round(cast(sum(ind_homens) as double) / sum(ind_total),4) as ind_homens_perct,
        sum(ind_em_terras_homens) as ind_em_terras_homens,
        sum(ind_fora_terras_homens) as ind_fora_terras_homens,
        sum(ind_mulheres) as ind_mulheres,
        round(cast(sum(ind_mulheres) as double) / sum(ind_total),4) as ind_mulheres_perct,
        sum(ind_em_terras_mulheres) as ind_em_terras_mulheres,
        sum(ind_fora_terras_mulheres) as ind_fora_terras_mulheres
    from indigena
    where nivel = 'UF'
    and cod_ibge in ('11', '12', '13', '14', '15', '16', '17')
    group by 1, 2
),
-- Região Nordeste
nordeste_ind as (
    select
        substring(cod_ibge,1,1) as cod_ibge,
        'REGIAO' as nivel,
		sum(ind_total) as ind_total,
		sum(ind_em_terras_total) as ind_em_terras_total,
        round(cast(sum(ind_em_terras_total) as double) / sum(ind_total),4) as ind_em_terras_total_perct,
        sum(ind_fora_terras_total) as ind_fora_terras_total,
        round(cast(sum(ind_fora_terras_total) as double) / sum(ind_total),4) as ind_fora_terras_total_perct,
        sum(ind_homens) as ind_homens,
        round(cast(sum(ind_homens) as double) / sum(ind_total),4) as ind_homens_perct,
        sum(ind_em_terras_homens) as ind_em_terras_homens,
        sum(ind_fora_terras_homens) as ind_fora_terras_homens,
        sum(ind_mulheres) as ind_mulheres,
        round(cast(sum(ind_mulheres) as double) / sum(ind_total),4) as ind_mulheres_perct,
        sum(ind_em_terras_mulheres) as ind_em_terras_mulheres,
        sum(ind_fora_terras_mulheres) as ind_fora_terras_mulheres
    from indigena
    where nivel = 'UF'
    and cod_ibge in ('21', '22', '23', '24', '25', '26', '27', '28', '29')
    group by 1, 2
),
-- Região Centro-Oeste
centro_ind as (
    select
        substring(cod_ibge,1,1) as cod_ibge,
        'REGIAO' as nivel,
		sum(ind_total) as ind_total,
		sum(ind_em_terras_total) as ind_em_terras_total,
        round(cast(sum(ind_em_terras_total) as double) / sum(ind_total),4) as ind_em_terras_total_perct,
        sum(ind_fora_terras_total) as ind_fora_terras_total,
        round(cast(sum(ind_fora_terras_total) as double) / sum(ind_total),4) as ind_fora_terras_total_perct,
        sum(ind_homens) as ind_homens,
        round(cast(sum(ind_homens) as double) / sum(ind_total),4) as ind_homens_perct,
        sum(ind_em_terras_homens) as ind_em_terras_homens,
        sum(ind_fora_terras_homens) as ind_fora_terras_homens,
        sum(ind_mulheres) as ind_mulheres,
        round(cast(sum(ind_mulheres) as double) / sum(ind_total),4) as ind_mulheres_perct,
        sum(ind_em_terras_mulheres) as ind_em_terras_mulheres,
        sum(ind_fora_terras_mulheres) as ind_fora_terras_mulheres
    from indigena
    where nivel = 'UF'
    and cod_ibge in ('50', '51', '52', '53')
    group by 1, 2
),
-- Região Sudeste
sudeste_ind as (
    select
        substring(cod_ibge,1,1) as cod_ibge,
        'REGIAO' as nivel,
		sum(ind_total) as ind_total,
		sum(ind_em_terras_total) as ind_em_terras_total,
        round(cast(sum(ind_em_terras_total) as double) / sum(ind_total),4) as ind_em_terras_total_perct,
        sum(ind_fora_terras_total) as ind_fora_terras_total,
        round(cast(sum(ind_fora_terras_total) as double) / sum(ind_total),4) as ind_fora_terras_total_perct,
        sum(ind_homens) as ind_homens,
        round(cast(sum(ind_homens) as double) / sum(ind_total),4) as ind_homens_perct,
        sum(ind_em_terras_homens) as ind_em_terras_homens,
        sum(ind_fora_terras_homens) as ind_fora_terras_homens,
        sum(ind_mulheres) as ind_mulheres,
        round(cast(sum(ind_mulheres) as double) / sum(ind_total),4) as ind_mulheres_perct,
        sum(ind_em_terras_mulheres) as ind_em_terras_mulheres,
        sum(ind_fora_terras_mulheres) as ind_fora_terras_mulheres
    from indigena
    where nivel = 'UF'
    and cod_ibge in ('31', '32', '33', '35')
    group by 1, 2
),
-- Região Sul
sul_ind as (
    select
        substring(cod_ibge,1,1) as cod_ibge,
        'REGIAO' as nivel,
		sum(ind_total) as ind_total,
		sum(ind_em_terras_total) as ind_em_terras_total,
        round(cast(sum(ind_em_terras_total) as double) / sum(ind_total),4) as ind_em_terras_total_perct,
        sum(ind_fora_terras_total) as ind_fora_terras_total,
        round(cast(sum(ind_fora_terras_total) as double) / sum(ind_total),4) as ind_fora_terras_total_perct,
        sum(ind_homens) as ind_homens,
        round(cast(sum(ind_homens) as double) / sum(ind_total),4) as ind_homens_perct,
        sum(ind_em_terras_homens) as ind_em_terras_homens,
        sum(ind_fora_terras_homens) as ind_fora_terras_homens,
        sum(ind_mulheres) as ind_mulheres,
        round(cast(sum(ind_mulheres) as double) / sum(ind_total),4) as ind_mulheres_perct,
        sum(ind_em_terras_mulheres) as ind_em_terras_mulheres,
        sum(ind_fora_terras_mulheres) as ind_fora_terras_mulheres
    from indigena
    where nivel = 'UF'
    and cod_ibge in ('41', '42', '43')
    group by 1, 2
),
brasil as (
    select
        '76' as cod_ibge,
        'BR' as nivel,
		sum(ind_total) as ind_total,
		sum(ind_em_terras_total) as ind_em_terras_total,
        round(cast(sum(ind_em_terras_total) as double) / sum(ind_total),4) as ind_em_terras_total_perct,
        sum(ind_fora_terras_total) as ind_fora_terras_total,
        round(cast(sum(ind_fora_terras_total) as double) / sum(ind_total),4) as ind_fora_terras_total_perct,
        sum(ind_homens) as ind_homens,
        round(cast(sum(ind_homens) as double) / sum(ind_total),4) as ind_homens_perct,
        sum(ind_em_terras_homens) as ind_em_terras_homens,
        sum(ind_fora_terras_homens) as ind_fora_terras_homens,
        sum(ind_mulheres) as ind_mulheres,
        round(cast(sum(ind_mulheres) as double) / sum(ind_total),4) as ind_mulheres_perct,
        sum(ind_em_terras_mulheres) as ind_em_terras_mulheres,
        sum(ind_fora_terras_mulheres) as ind_fora_terras_mulheres
    from indigena
    where nivel = 'UF'
    group by 1, 2
),
ind_final as (
    select * from indigena
    union all
    select * from norte_ind
    union all
    select * from nordeste_ind
    union all
    select * from sudeste_ind
    union all
    select * from sul_ind
    union all
    select * from centro_ind
    union all
    select * from brasil
)
select
        quilo.cod_ibge,
        quilo.nivel,
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
        quilo_fora_terras_perct
from  quilo_final quilo
inner join ind_final  ind
on  quilo.cod_ibge = ind.cod_ibge
and quilo.nivel = ind.nivel
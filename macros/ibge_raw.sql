{% macro ibge_raw() %}
    {% call statement() %}
        create database if not exists ibge;
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_pop (
            `nivel` string,
            `cod` string,
            `municipio_c_uf` string,
            `municipio` string,
            `sigla` string,
            `declaracaoidade` string,
            `total` string,
            `1` string,
            `2` string,
            `3` string,
            `4` string,
            `5` string,
            `6` string,
            `7` string,
            `8` string,
            `9` string,
            `10` string,
            `11` string,
            `12` string,
            `13` string,
            `14` string,
            `15` string,
            `16` string,
            `17` string,
            `18` string,
            `19` string,
            `20` string,
            `totalhomem` string,
            `21` string,
            `22` string,
            `23` string,
            `24` string,
            `25` string,
            `26` string,
            `27` string,
            `28` string,
            `29` string,
            `30` string,
            `31` string,
            `32` string,
            `33` string,
            `34` string,
            `35` string,
            `36` string,
            `37` string,
            `38` string,
            `39` string,
            `40` string,
            `totalmulher` string,
            `41` string,
            `42` string,
            `43` string,
            `44` string,
            `45` string,
            `46` string,
            `47` string,
            `48` string,
            `49` string,
            `50` string,
            `51` string,
            `52` string,
            `53` string,
            `54` string,
            `55` string,
            `56` string,
            `57` string,
            `58` string,
            `59` string,
            `60` string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_pop/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_alfa (
            `cod` string,
            `cep` string,
            `nivel` string,
            `sigla` string,
            `idade` string,
            `total` string,
            `homens_total` string,
            `mulheres_total` string,
            `branca_total` string,
            `branca_homens` string,
            `branca_mulheres` string,
            `preta_total` string,
            `preta_homens` string,
            `preta_mulheres` string,
            `amarela_total` string,
            `amarela_homens` string,
            `amarela_mulheres` string,
            `parda_total` string,
            `parda_homens` string,
            `parda_mulheres` string,
            `indigena_total` string,
            `indigena_homens` string,
            `indigena_mulheres` string,
            `total_alfabetizadas` string,
            `homens_alfabetizadas` string,
            `mulheres_alfabetizadas` string,
            `branca_total_alfabetizadas` string,
            `branca_homens_alfabetizadas` string,
            `branca_mulheres_alfabetizadas` string,
            `preta_total_alfabetizadas` string,
            `preta_homens_alfabetizadas` string,
            `preta_mulheres_alfabetizadas` string,
            `amarela_total_alfabetizadas` string,
            `amarela_homens_alfabetizadas` string,
            `amarela_mulheres_alfabetizadas` string,
            `parda_total_alfabetizadas` string,
            `parda_homens_alfabetizadas` string,
            `parda_mulheres_alfabetizadas` string,
            `indigena_total__alfabetizadas` string,
            `indigena_homens_alfabetizadas` string,
            `indigena_mulheres_alfabetizadas` string,
            `total_nao_alfabetizadas` string,
            `homens_nao_alfabetizadas` string,
            `mulheres_nao_alfabetizadas` string,
            `branca_total_nao_alfabetizadas` string,
            `branca_homens_nao_alfabetizadas` string,
            `branca_mulheres_nao_alfabetizadas` string,
            `preta_total_nao_alfabetizadas` string,
            `preta_homens_nao_alfabetizadas` string,
            `preta_mulheres_nao_alfabetizadas` string,
            `amarela_total_nao_alfabetizadas` string,
            `amarela_homens_nao_alfabetizadas` string,
            `amarela_mulheres_nao_alfabetizadas` string,
            `parda_total_nao_alfabetizadas` string,
            `parda_homens_nao_alfabetizadas` string,
            `parda_mulheres_nao_alfabetizadas` string,
            `indigena_total__nao_alfabetizadas` string,
            `indigena_homens_nao_alfabetizadas` string,
            `indigena_mulheres_nao_alfabetizadas` string,
            `total_alfabetizados_perct` string,
            `ranking` string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_alfa/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_ind (
            `cep` string,
            `sigla` string,
            `regiao` string,
            `nivel` string,
            `localizacao` string,
            `total` string,
            `homens` string,
            `mulheres` string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_ind/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_local (
            nivel string,
            cod string,
            municipio_c_uf string,
            municipio string,
            sigla string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_local/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_pop_fav (
            `cod` string,
            `municipio` string,
            `sigla` string,
            `h_1` string,
            `h_10` string,
            `h_11` string,
            `h_12` string,
            `h_13` string,
            `h_14` string,
            `h_15` string,
            `h_16` string,
            `h_17` string,
            `h_18` string,
            `h_19` string,
            `h_2` string,
            `h_20` string,
            `h_21` string,
            `h_22` string,
            `h_3` string,
            `h_4` string,
            `h_5` string,
            `h_6` string,
            `h_7` string,
            `h_8` string,
            `h_9` string,
            `m_1` string,
            `m_10` string,
            `m_11` string,
            `m_12` string,
            `m_13` string,
            `m_14` string,
            `m_15` string,
            `m_16` string,
            `m_17` string,
            `m_18` string,
            `m_19` string,
            `m_2` string,
            `m_20` string,
            `m_21` string,
            `m_22` string,
            `m_3` string,
            `m_4` string,
            `m_5` string,
            `m_6` string,
            `m_7` string,
            `m_8` string,
            `m_9` string,
            `branca_1` string,
            `branca_10` string,
            `branca_11` string,
            `branca_12` string,
            `branca_13` string,
            `branca_14` string,
            `branca_15` string,
            `branca_16` string,
            `branca_17` string,
            `branca_18` string,
            `branca_19` string,
            `branca_2` string,
            `branca_20` string,
            `branca_21` string,
            `branca_22` string,
            `branca_3` string,
            `branca_4` string,
            `branca_5` string,
            `branca_6` string,
            `branca_7` string,
            `branca_8` string,
            `branca_9` string,
            `parda_1` string,
            `parda_10` string,
            `parda_11` string,
            `parda_12` string,
            `parda_13` string,
            `parda_14` string,
            `parda_15` string,
            `parda_16` string,
            `parda_17` string,
            `parda_18` string,
            `parda_19` string,
            `parda_2` string,
            `parda_20` string,
            `parda_21` string,
            `parda_22` string,
            `parda_3` string,
            `parda_4` string,
            `parda_5` string,
            `parda_6` string,
            `parda_7` string,
            `parda_8` string,
            `parda_9` string,
            `preta_1` string,
            `preta_10` string,
            `preta_11` string,
            `preta_12` string,
            `preta_13` string,
            `preta_14` string,
            `preta_15` string,
            `preta_16` string,
            `preta_17` string,
            `preta_18` string,
            `preta_19` string,
            `preta_2` string,
            `preta_20` string,
            `preta_21` string,
            `preta_22` string,
            `preta_3` string,
            `preta_4` string,
            `preta_5` string,
            `preta_6` string,
            `preta_7` string,
            `preta_8` string,
            `preta_9` string,
            `amarela_1` string,
            `amarela_10` string,
            `amarela_11` string,
            `amarela_12` string,
            `amarela_13` string,
            `amarela_14` string,
            `amarela_15` string,
            `amarela_16` string,
            `amarela_17` string,
            `amarela_18` string,
            `amarela_19` string,
            `amarela_2` string,
            `amarela_20` string,
            `amarela_21` string,
            `amarela_22` string,
            `amarela_3` string,
            `amarela_4` string,
            `amarela_5` string,
            `amarela_6` string,
            `amarela_7` string,
            `amarela_8` string,
            `amarela_9` string,
            `indigena_1` string,
            `indigena_10` string,
            `indigena_11` string,
            `indigena_12` string,
            `indigena_13` string,
            `indigena_14` string,
            `indigena_15` string,
            `indigena_16` string,
            `indigena_17` string,
            `indigena_18` string,
            `indigena_19` string,
            `indigena_2` string,
            `indigena_20` string,
            `indigena_21` string,
            `indigena_22` string,
            `indigena_3` string,
            `indigena_4` string,
            `indigena_5` string,
            `indigena_6` string,
            `indigena_7` string,
            `indigena_8` string,
            `indigena_9` string,
            `sd_1` string,
            `sd_10` string,
            `sd_11` string,
            `sd_12` string,
            `sd_13` string,
            `sd_14` string,
            `sd_15` string,
            `sd_16` string,
            `sd_17` string,
            `sd_18` string,
            `sd_19` string,
            `sd_2` string,
            `sd_20` string,
            `sd_21` string,
            `sd_22` string,
            `sd_3` string,
            `sd_4` string,
            `sd_5` string,
            `sd_6` string,
            `sd_7` string,
            `sd_8` string,
            `sd_9` string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_pop_fav/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_hab_esg (
                cod string,
                cep string,
                nivel string,
                sigla string,
                total string,
                rede_geral string,
                fossa_septica string,
                fossa_rudimentar_buraco string,
                vala string,
                rio_lago_corrego_mar string,
                outra_forma string,
                sem_banheiro string,
                esgoto_perct string,
                ranking string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_hab_esg/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_hab_abas (
            cod string,
            cep string,
            nivel string,
            sigla string,
            existencia string,
            total string,
            rede_geral string,
            poco_artesiano string,
            poco_raso string,
            fonte_nascente string,
            carro_pipa string,
            agua_chuva string,
            rios_acudes string,
            outra string,
            abastecimento string,
            ranking string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_hab_abas/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_hab_col (
            cod string,
            cep string,
            nivel string,
            sigla string,
            total string,
            coletado string,
            queimado string,
            enterrado string,
            jogado string,
            outro_destino string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_hab_col/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_hab_ban (
            cod string,
            cep string,
            nivel string,
            sigla string,
            tipo_esgoto string,
            total string,
            banheiro_exclusivo string,
            banheiro_uso_comum string,
            apenas_sanitario string,
            sem_banheiro string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_hab_ban/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_hab_fav_uf (
            cep string,
            nivel string,
            sigla string,
            qtd_favelas string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_hab_fav_uf/'
    {% endcall %}

    {% call statement() %}
        create external table if not exists ibge.raw_demo_hab_fav_mun (
            cod string,
            municipio_c_uf string,
            municipio string,
            sigla string,
            domicilios string
        )
        stored as parquet
        location '{{ bucket() }}/raw/ibge/demografia/raw_demo_hab_fav_mun/'
    {% endcall %}

{% endmacro %}

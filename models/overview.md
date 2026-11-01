
{% docs __overview__ %}

# Observatório Nacional

### Plataforma Aberta de Dados sobre o Brasil

O **Observatório Nacional** é uma iniciativa independente dedicada à organização, integração e disponibilização de dados públicos sobre o Brasil.

O projeto tem como objetivo democratizar o acesso à informação, transformando dados oficiais em indicadores acessíveis, contextualizados e confiáveis, que permitam compreender diferentes dimensões da realidade brasileira.

A plataforma foi concebida para atender a dois públicos principais:

- **Cidadãos:** acesso simplificado a indicadores, visualizações e informações sobre o Brasil.
- **Investigadores, estudantes e profissionais de dados:** acesso a conjuntos de dados estruturados, documentados e preparados para análises aprofundadas.

O Observatório procura estabelecer uma ponte entre os dados públicos e a sociedade, promovendo transparência, conhecimento e decisões fundamentadas em evidências.

---

## Arquitetura de Dados

O projeto utiliza uma arquitetura de processamento em camadas, desde a ingestão dos dados originais até à sua disponibilização para análise e visualização.

| Camada | Responsabilidade |
|---|---|
| **RAW** | Armazenamento dos dados originais provenientes das fontes oficiais, preservando a estrutura de origem. |
| **REFINED** | Padronização de nomes, conversão de tipos, tratamento e organização dos dados. |
| **STAGING** | Integração entre fontes, transformação de estruturas e agregação dos indicadores. |
| **AUGMENTED** | Consolidação dos indicadores analíticos utilizados pelo portal e por outros consumidores de dados. |

### Tecnologias

| Tecnologia | Função |
|---|---|
| **Apache Airflow** | Orquestração dos processos de ingestão e transformação. |
| **Amazon S3** | Armazenamento dos dados nas diferentes camadas. |
| **Amazon Athena** | Consulta e processamento SQL dos dados armazenados no S3. |
| **dbt Core** | Transformação, testes, documentação e gestão das dependências entre modelos. |
| **Python** | Processamento, ingestão e exportação dos dados. |
| **Next.js / React** | Desenvolvimento do portal público e das interfaces de exploração. |

---

## Domínios de Dados

### Demografia e População

Indicadores relativos à distribuição e às características da população brasileira.

- **População (pop):** população residente por território, sexo e faixa etária.
- **Alfabetização (alfa):** população alfabetizada e não alfabetizada, com indicadores por sexo e faixa etária.
- **Cor e raça:** distribuição populacional segundo as categorias de cor ou raça disponibilizadas pelo IBGE.
- **Favelas e comunidades urbanas (fav):** população residente, distribuição demográfica e indicadores territoriais.
- **Povos indígenas (ind):** população indígena, distribuição por sexo e residência dentro ou fora de terras indígenas.
- **População quilombola (quilo):** distribuição da população quilombola dentro e fora de territórios quilombolas.
- **Religiões (rel):** distribuição da população por religião ou crença, conforme as categorias disponibilizadas pela fonte.

### Habitação e Saneamento

Indicadores sobre as condições habitacionais e o acesso a infraestruturas básicas.

- **Abastecimento de água (abas):** distribuição dos domicílios por fonte de abastecimento.
- **Esgotamento sanitário (esg):** formas de escoamento e tratamento do esgoto doméstico.
- **Coleta de lixo (col):** formas de coleta e destinação dos resíduos domésticos.
- **Banheiros e sanitários (ban):** condições de acesso e utilização de instalações sanitárias.
- **Habitação em favelas:** quantidade de comunidades urbanas e domicílios identificados nas fontes disponíveis.

### Território e Geografia

Indicadores e estruturas de referência para análise territorial.

- **Localização (loc):** identificação e organização dos territórios através dos códigos geográficos do IBGE.
- **Área territorial (area):** extensão dos territórios em quilómetros quadrados.
- **Densidade demográfica:** número de habitantes por quilómetro quadrado.
- **Rankings territoriais:** classificação comparativa de indicadores dentro do mesmo nível geográfico.

---

## Organização Geográfica

Os modelos analíticos utilizam identificadores geográficos padronizados, permitindo explorar os indicadores em diferentes níveis territoriais.

| Nível | Identificador | Abrangência |
|---|---|---|
| **BR** | 76 | Brasil |
| **REGIAO** | 1 a 5 | Cinco grandes regiões brasileiras |
| **UF** | Códigos de dois dígitos | 26 estados e Distrito Federal |
| **MU** | Códigos municipais do IBGE | Municípios brasileiros |

A combinação das colunas `cod_ibge` e `nivel` permite identificar o recorte territorial dos indicadores.

Alguns conjuntos de dados apresentam dimensões adicionais, como `faixa_etaria`, que devem ser consideradas na interpretação e integração dos registos.

Os níveis geográficos representam diferentes agregações de uma mesma realidade territorial e não devem ser somados indiscriminadamente, evitando duplicação de valores.

---

## Modelos Analíticos

A camada **AUGMENTED** constitui a principal interface de dados entre os processos analíticos e o portal público.

Entre os modelos desenvolvidos encontram-se:

| Modelo | Descrição |
|---|---|
| `aug_demo_pop` | Consolidação de indicadores populacionais, alfabetização, favelas, povos indígenas, quilombolas e religiões. |
| `aug_demo_hab` | Indicadores de habitação, saneamento básico, abastecimento de água e destinação de resíduos. |
| `aug_demo_area` | Área territorial, densidade demográfica e rankings de extensão territorial. |

Os modelos mantêm indicadores absolutos e derivados, incluindo proporções, médias e rankings, conforme a disponibilidade e a granularidade das fontes.

---

## Disponibilização dos Dados

O Observatório adota uma estratégia de separação entre processamento analítico e disponibilização para consumo.

Os modelos AUGMENTED são armazenados em formato **Apache Parquet**, permitindo consultas eficientes através do Amazon Athena.

Para o portal, os dados são exportados em **JSON**, com seleção das colunas relevantes e organização temática.

Esta abordagem permite:

- Preservar modelos analíticos completos e reutilizáveis.
- Reduzir o volume de dados transferidos para as interfaces.
- Disponibilizar conjuntos específicos para diferentes visualizações.
- Manter uma estrutura consistente de indicadores e identificadores geográficos.
- Preparar a plataforma para futuras formas de acesso aos dados.

A disponibilização de uma API pública está prevista como uma evolução posterior do projeto.

---

## Qualidade, Documentação e Rastreabilidade

A transformação dos dados é gerida através do dbt Core, permitindo documentar a origem, as dependências e as regras aplicadas aos indicadores.

O projeto utiliza:

- **Testes de qualidade:** validações de integridade, valores nulos e consistência dos dados.
- **Documentação de modelos:** descrições das tabelas, colunas e indicadores.
- **Data Lineage:** visualização das dependências entre fontes e modelos.
- **Padronização:** utilização de convenções de nomenclatura, tipos e identificadores.
- **Rastreabilidade:** identificação das fontes e transformações utilizadas na construção dos indicadores.

Os indicadores derivados devem respeitar as regras de agregação adequadas. Contagens absolutas podem ser agregadas quando os recortes são compatíveis, enquanto percentagens, médias e densidades devem ser recalculadas a partir dos valores correspondentes.

---

## Fontes de Dados

### IBGE — Instituto Brasileiro de Geografia e Estatística

O **Censo Demográfico 2022** constitui a principal fonte de dados utilizada na fase inicial do Observatório Nacional.

Os dados são organizados e transformados para facilitar análises demográficas, sociais, habitacionais e territoriais.

**Fonte oficial:** https://www.ibge.gov.br/

A integração de outras fontes públicas e domínios temáticos está prevista na evolução da plataforma.

---

## Explorar o Catálogo

Utiliza o menu lateral do dbt Docs para:

- Consultar os modelos das camadas REFINED, STAGING e AUGMENTED.
- Explorar os dicionários de colunas e as definições dos indicadores.
- Visualizar as dependências entre modelos através do Data Lineage.
- Identificar as fontes de origem dos dados.
- Compreender as transformações realizadas até à disponibilização dos indicadores.

---

**Observatório Nacional · Catálogo e Documentação de Dados**

*Dados públicos, conhecimento acessível.*

{% enddocs %}

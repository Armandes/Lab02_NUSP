# Lab02 — Transformação de Dados com DBT

**Aluno:** João Armandes Vieira Costa  
**Disciplina:** Engenharia de Dados — Pós-Graduação  
**Dataset:** Gaming and Mental Health — 1.000.000 linhas × 39 colunas

---

## Arquitetura

```
CSV Original → Bronze → Silver (Parquet) → Postgres (schema silver)
                                                    ↓
                                              DBT (transformações)
                                                    ↓
                                           Postgres (schema gold)
                                                    ↓
                                           Metabase (dashboard)
```

| Camada | Objetivo | Saída |
|--------|----------|-------|
| Bronze | Ingestão as-is | `data/raw/` + log |
| Silver | Limpeza e padronização | `data/silver/*.parquet` |
| Postgres Silver | Fonte para o DBT | schema `silver` no banco `lab01` |
| DBT Gold | Transformações e modelagem | schema `gold` no banco `lab01` |
| BI | Dashboard | Metabase em `localhost:3000` |

---

## Estrutura do Projeto

```
Lab02_NUSP/
├── data/
│   ├── raw/                          # CSV original + log
│   └── silver/
│       ├── dataset_clean.parquet     # Dataset limpo
│       └── graficos/                 # Gráficos exploratórios
├── dbt_lab02/
│   ├── models/
│   │   ├── staging/
│   │   │   ├── sources.yml           # Declara a fonte Silver
│   │   │   ├── stg_gaming_mental_health.sql
│   │   │   └── stg_gaming_mental_health.yml
│   │   └── marts/
│   │       ├── mart_saude_mental.sql
│   │       ├── mart_perfil_jogador.sql
│   │       └── marts.yml
│   ├── macros/
│   │   └── classificar_horas_jogo.sql
│   ├── tests/
│   │   ├── test_horas_jogo_invalidas.sql
│   │   └── test_addiction_fora_do_intervalo.sql
│   ├── packages.yml
│   └── dbt_project.yml
├── carregar_silver.py                # Carrega Parquet no Postgres
├── docs/
│   ├── print1.png                    # Print da documentação DBT
│   └── print2.png                    # Print do lineage DBT
├── requirements.txt
└── README.md
```

---

## Pré-requisitos

- Python 3.11+
- PostgreSQL 18 instalado localmente
- DBT instalado (`pip install dbt-postgres`)

### Instalar dependências

```bash
pip install -r requirements.txt
```

---

## Como Reproduzir o Ambiente

### 1. Clonar o repositório

```bash
git clone https://github.com/Armandes/Lab02_NUSP.git
cd Lab02_NUSP
```

### 2. Criar o usuário no PostgreSQL

```sql
CREATE USER lab02 WITH PASSWORD 'lab02';
GRANT ALL PRIVILEGES ON DATABASE lab01 TO lab02;
```

### 3. Carregar o Parquet no schema silver

```bash
python carregar_silver.py
```

### 4. Instalar dependências do DBT

```bash
cd dbt_lab02
dbt deps
```

### 5. Executar os models

```bash
dbt run
```

### 6. Executar os testes

```bash
dbt test
```

### 7. Gerar e visualizar a documentação

```bash
dbt docs generate
dbt docs serve
```

Acessa em: `http://localhost:8080`

---

## DBT — Detalhes

### Models

| Model | Camada | Descrição |
|-------|--------|-----------|
| `stg_gaming_mental_health` | Staging | Padroniza e gera surrogate key |
| `mart_saude_mental` | Marts | Métricas de saúde mental com classificação de horas |
| `mart_perfil_jogador` | Marts | Perfil demográfico e hábitos dos jogadores |

### Macro

`classificar_horas_jogo(coluna)` — classifica horas de jogo diárias em faixas:

| Faixa | Intervalo |
|-------|-----------|
| < 2h | menos de 2 horas |
| 2-4h | entre 2 e 4 horas |
| 4-6h | entre 4 e 6 horas |
| 6-8h | entre 6 e 8 horas |
| > 8h | mais de 8 horas |

### Testes

**Genéricos** (definidos no YAML):

| Teste | Coluna | Model |
|-------|--------|-------|
| unique | player_id | stg, marts |
| not_null | player_id, gender, anxiety_score, depression_score | stg |
| accepted_values | gender | stg |

**Singulares** (queries SQL):

| Arquivo | Descrição |
|---------|-----------|
| `test_horas_jogo_invalidas.sql` | Busca jogadores com mais de 24h de jogo diárias |
| `test_addiction_fora_do_intervalo.sql` | Busca addiction_level fora do intervalo 0-10 |

### Qualidade dos Dados Identificada

| Problema | Teste | Resultado |
|----------|-------|-----------|
| 54 jogadores com `daily_gaming_hours` > 24h | `test_horas_jogo_invalidas` | Reprovado — dado inconsistente identificado |

---

## Documentação DBT

### Tela principal

![Documentação DBT](docs/print1.png)

### Lineage graph

![Lineage DBT](docs/print2.png)

---

## Dashboard — Metabase

Conecta o Metabase no schema `gold` do banco `lab01` e acessa os marts gerados pelo DBT.

### Visualizações criadas

1. Distribuição de horas de jogo por faixa
2. Score médio de ansiedade por gênero
3. Horas de sono vs score de felicidade

---

## Dificuldades Encontradas

- Surrogate key com poucas colunas gerava duplicatas — resolvido adicionando mais colunas à chave
- PATH do DBT não configurado automaticamente no Windows — resolvido manualmente
- Macro criada na pasta errada (`models/`) em vez de `macros/` — movida corretamente
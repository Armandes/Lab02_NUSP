"""
carregar_silver.py — Carrega o Parquet da Silver no PostgreSQL

Objetivo:
    Ler o dataset limpo em Parquet e carregar no schema 'silver'
    do PostgreSQL para que o DBT possa consumi-lo.

Entrada:
    - data/silver/dataset_clean.parquet

Saída:
    - Tabela silver.gaming_mental_health no PostgreSQL
"""

import pandas as pd
from sqlalchemy import create_engine, text

# ── Configuração ──────────────────────────────────────────────────
PARQUET  = "data/silver/dataset_clean.parquet"
DB_URL   = "postgresql://lab02:lab02@localhost:5432/lab01"

def carregar():
    print("Lendo Parquet...")
    df = pd.read_parquet(PARQUET)
    print(f"Shape: {df.shape[0]:,} linhas × {df.shape[1]} colunas")

    engine = create_engine(DB_URL)

    # Cria o schema silver se não existir
    with engine.connect() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS silver"))
        conn.commit()

    # Carrega a tabela
    print("Carregando no PostgreSQL (schema silver)...")
    df.to_sql(
        name="gaming_mental_health",
        con=engine,
        schema="silver",
        if_exists="replace",
        index=False,
        method="multi",
        chunksize=10000
    )
    print("Tabela silver.gaming_mental_health carregada com sucesso!")

if __name__ == "__main__":
    carregar()
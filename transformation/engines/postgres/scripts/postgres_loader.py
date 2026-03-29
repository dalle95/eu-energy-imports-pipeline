from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text


DB_URL = "postgresql+psycopg://root:root@localhost:5432/ue_energy"
RAW_SCHEMA = "raw"


def get_engine():
    return create_engine(DB_URL)

def ensure_schema_exists(engine, schema_name: str):
    with engine.begin() as conn:
        conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{schema_name}"'))
    print(f"Schema '{schema_name}' ready")

def drop_table_if_exists(engine, schema_name: str, table_name: str):
    with engine.begin() as conn:
        conn.execute(text(f'DROP TABLE IF EXISTS "{schema_name}"."{table_name}" CASCADE'))
    print(f"Table '{schema_name}.{table_name}' dropped if it existed")

def load_multiple_files_to_postgres(
    data_path: Path,
    extension: str,
    table_name: str,
    schema_name: str = RAW_SCHEMA
):
    print(f"Loading data into PostgreSQL table: {schema_name}.{table_name}")

    engine = get_engine()
    ensure_schema_exists(engine, schema_name)

    drop_table_if_exists(engine, schema_name, table_name)

    first_file = True
    files = list(data_path.glob(f"*.{extension}"))

    if not files:
        print(f"No .{extension} files found in {data_path}")
        return

    for file in files:
        print(f"Processing file: {file}")

        if extension == "csv":
            df = pd.read_csv(file)
        elif extension == "parquet":
            df = pd.read_parquet(file)
        else:
            raise ValueError(f"Unsupported extension: {extension}")

        if first_file:
            df.head(0).to_sql(
                name=table_name,
                schema=schema_name,
                con=engine,
                if_exists="replace",
                index=False
            )
            print(f"Table created: {schema_name}.{table_name}")
            first_file = False

        df.to_sql(
            name=table_name,
            schema=schema_name,
            con=engine,
            if_exists="append",
            index=False,
            method="multi",
            chunksize=10000
        )

        print(f"Loaded {len(df)} rows into PostgreSQL table: {schema_name}.{table_name}")


def load_single_file_to_postgres(
    data_path: Path,
    extension: str,
    table_name: str,
    schema_name: str = RAW_SCHEMA
):
    print(f"Loading data into PostgreSQL table: {schema_name}.{table_name}")

    engine = get_engine()
    ensure_schema_exists(engine, schema_name)

    drop_table_if_exists(engine, schema_name, table_name)

    if not data_path.exists():
        print(f"File not found: {data_path}")
        return

    print(f"Processing file: {data_path}")

    if extension == "csv":
        df = pd.read_csv(data_path)
    elif extension == "parquet":
        df = pd.read_parquet(data_path)
    else:
        raise ValueError(f"Unsupported extension: {extension}")

    df.to_sql(
        name=table_name,
        schema=schema_name,
        con=engine,
        if_exists="replace",
        index=False,
        method="multi",
        chunksize=10000
    )

    print(f"Loaded {len(df)} rows into PostgreSQL table: {schema_name}.{table_name}")


def load_comext_oil_data():
    load_multiple_files_to_postgres(
        data_path=Path("data/processed/comext/facts/oil_imports/quantity"),
        extension="parquet",
        table_name="comext_oil_imports_quantity"
    )

    load_multiple_files_to_postgres(
        data_path=Path("data/processed/comext/facts/oil_imports/value"),
        extension="parquet",
        table_name="comext_oil_imports_value"
    )


def load_comext_gas_data():
    load_multiple_files_to_postgres(
        data_path=Path("data/processed/comext/facts/gas_imports/quantity"),
        extension="parquet",
        table_name="comext_gas_imports_quantity"
    )

    load_multiple_files_to_postgres(
        data_path=Path("data/processed/comext/facts/gas_imports/value"),
        extension="parquet",
        table_name="comext_gas_imports_value"
    )


def load_eurostat_dimensions_data():
    load_single_file_to_postgres(
        data_path=Path("data/processed/eurostat/dimensions/FREQ.csv"),
        extension="csv",
        table_name="eurostat_dimensions_freq"
    )

    load_single_file_to_postgres(
        data_path=Path("data/processed/eurostat/dimensions/GEO.csv"),
        extension="csv",
        table_name="eurostat_dimensions_geo"
    )

    load_single_file_to_postgres(
        data_path=Path("data/processed/eurostat/dimensions/PARTNER.csv"),
        extension="csv",
        table_name="eurostat_dimensions_partner"
    )

    load_single_file_to_postgres(
        data_path=Path("data/processed/eurostat/dimensions/SIEC.csv"),
        extension="csv",
        table_name="eurostat_dimensions_siec"
    )

    load_single_file_to_postgres(
        data_path=Path("data/processed/eurostat/dimensions/UNIT.csv"),
        extension="csv",
        table_name="eurostat_dimensions_unit"
    )


if __name__ == "__main__":
    load_comext_oil_data()
    load_comext_gas_data()
    load_eurostat_dimensions_data()
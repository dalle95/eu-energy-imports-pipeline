from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine


def load_multiple_files_to_postgres(data_path: Path, extension: str, table_name: str):
    print(f"Loading data into PostgreSQL table: {table_name}")

    engine = create_engine("postgresql+psycopg://root:root@localhost:5432/ue_energy")

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
                con=engine,
                if_exists="replace",
                index=False
            )
            print("Table created")
            first_file = False

        df.to_sql(
            name=table_name,
            con=engine,
            if_exists="append",
            index=False,
            method="multi",
            chunksize=10000
        )

        print(f"Loaded {len(df)} rows into PostgreSQL table: {table_name}")

def load_single_file_to_postgres(data_path: Path, extension: str, table_name: str):
    print(f"Loading data into PostgreSQL table: {table_name}")

    engine = create_engine("postgresql+psycopg://root:root@localhost:5432/ue_energy")

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
        con=engine,
        if_exists="replace",
        index=False,
        method="multi",
        chunksize=10000
    )

    print(f"Loaded {len(df)} rows into PostgreSQL table: {table_name}")

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
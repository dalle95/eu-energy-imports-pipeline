from pathlib import Path
import duckdb

DUCKDB_DIR = Path(__file__).resolve().parents[1]          # transformation/engines/duckdb
PROJECT_ROOT = Path(__file__).resolve().parents[4]        # repo root

db_path = DUCKDB_DIR / "data" / "ue_energy.duckdb"
sql_path = DUCKDB_DIR / "scripts" / "create_raw_views.sql"
data_path = (PROJECT_ROOT / "data").as_posix()

print(f"Creating database at {db_path}...")
print(f"Creating views with script at {sql_path}...")
print(f"Using data path: {data_path}")

con = duckdb.connect(str(db_path))

sql = sql_path.read_text(encoding="utf-8")
sql = sql.replace("__DATA_PATH__", data_path)

con.execute(sql)
con.close()

print("DuckDB raw views created successfully.")
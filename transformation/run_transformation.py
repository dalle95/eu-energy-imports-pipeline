import subprocess
from pathlib import Path


DBT_PROJECT_DIR = Path("transformation/dbt/ue_energy_analytics")
DBT_PROFILES_DIR = Path("..")
POSTGRES_LOADER_SCRIPT = Path("transformation/engines/postgres/scripts/postgres_loader.py")


def run_command(command: list[str], step_name: str, cwd: Path | None = None):
    print(f"Starting: {step_name}")
    subprocess.run(command, check=True, cwd=cwd)
    print(f"Completed: {step_name}")


def run_transformation(env: str = "dev"):
    print(f"Transformation phase started (env={env})")

    run_command(
        ["uv", "run", str(POSTGRES_LOADER_SCRIPT)],
        "Postgres loader"
    )

    run_command(
        ["dbt", "deps", "--profiles-dir", str(DBT_PROFILES_DIR)],
        "dbt deps",
        cwd=DBT_PROJECT_DIR
    )

    run_command(
        ["dbt", "build", "--target", env, "--profiles-dir", str(DBT_PROFILES_DIR)],
        f"dbt build ({env})",
        cwd=DBT_PROJECT_DIR
    )

    print("Transformation phase completed")


if __name__ == "__main__":
    run_transformation()
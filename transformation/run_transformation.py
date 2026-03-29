import subprocess
from pathlib import Path


DBT_PROJECT_DIR = Path("transformation/dbt/ue_energy_analytics")

def run_command(command: list[str], step_name: str, cwd: Path | None = None):
    print(f"Starting: {step_name}")
    subprocess.run(command, check=True, cwd=cwd)
    print(f"Completed: {step_name}")


def run_transformation(env: str = "dev"):
    print(f"Transformation phase started (env={env})")

    run_command(
        ["uv", "run", ".\\transformation\\engines\\postgres\\scripts\\postgres_loader.py"],
        "Postgres loader"
    )

    run_command(
        ["dbt", "deps"],
        "dbt deps",
        cwd=DBT_PROJECT_DIR
    )

    run_command(
        ["dbt", "build", "--target", env],
        f"dbt build ({env})",
        cwd=DBT_PROJECT_DIR
    )

    print("Transformation phase completed")


if __name__ == "__main__":
    run_transformation()
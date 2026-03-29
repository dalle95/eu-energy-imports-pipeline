import argparse
import sys

from ingestion.run_ingestion import run_ingestion
from processing.run_processing import run_processing
from transformation.run_transformation import run_transformation


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Main orchestrator for the EU energy pipeline"
    )

    parser.add_argument(
        "--phase",
        required=True,
        choices=["ingestion", "processing", "transformation", "all"],
        help="Pipeline phase to execute"
    )

    parser.add_argument(
        "--env",
        required=False,
        default="dev",
        choices=["dev", "prod"],
        help="Environment for transformation phase"
    )

    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        print("Pipeline started")

        if args.phase == "ingestion":
            run_ingestion()

        elif args.phase == "processing":
            run_processing()

        elif args.phase == "transformation":
            run_transformation(env=args.env)

        elif args.phase == "all":
            run_ingestion()
            run_processing()
            run_transformation()

        print("Pipeline completed successfully")
        return 0

    except Exception as exc:
        print(f"Pipeline failed during phase '{args.phase}': {exc}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
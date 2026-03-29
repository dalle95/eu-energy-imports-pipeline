import subprocess


def run_processing():
    print("Processing phase started")

    command = [
        "docker",
        "exec",
        "-i",
        "spark-client",
        "/opt/spark/bin/spark-submit",
        "--master",
        "spark://spark-master:7077",
        "/processing/spark/jobs/run_processing_job.py",
    ]

    subprocess.run(command, check=True)

    print("Processing phase completed")


if __name__ == "__main__":
    run_processing()
# 🚀 Run Processing Phase (Spark)

This guide explains how to execute the **processing phase** of the data pipeline using Apache Spark.

---

## 📌 What is the Processing Phase?

The processing phase is responsible for:

- Reading raw data produced during ingestion
- Applying transformations using PySpark
- Preparing data for the next layers (e.g. storage or analytics)

The entrypoint of this phase is:

```
/processing/run_processing.py
```

---

## ▶️ How to Run

Run the following command:

```bash
docker exec -it spark-client /opt/spark/bin/spark-submit --master spark://spark-master:7077 /processing/run_processing.py
```

---

## ⚙️ Requirements

Before running the command, make sure that:

- Docker containers are up and running (from the project root, run: `docker compose up --build -d`)
- The `spark-client`, `spark-master`, and `spark-worker` services are active
- The `processing` folder is correctly mounted inside the container

To start the environment:

```bash
docker compose up -d --build
```

---

## 🔍 What Happens When You Run It

- The command executes the processing script inside the Spark cluster
- A Spark job is submitted to the master node
- The script runs all defined processing tasks (e.g. oil and gas data transformations)


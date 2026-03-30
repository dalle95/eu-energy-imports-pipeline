# Infrastructure Layer

This document describes the local infrastructure used by the project, defined through Docker Compose.

The goal of this setup is to provide a reproducible local environment for processing, warehousing and dashboarding, so the full pipeline can be developed and validated end-to-end.

---

## Overview

The project relies on Docker Compose to run the core infrastructure services required by the pipeline.

The current local infrastructure includes:

- a Spark cluster for distributed processing
- a Spark client container for job submission and notebooks
- a PostgreSQL database for the analytical warehouse
- pgAdmin for database inspection
- Metabase for dashboarding

The infrastructure is defined in:

docker-compose.yml

---

## Services

### spark-master

The `spark-master` service is the coordinator of the local Spark cluster.

Image:
apache/spark:4.1.1-python3

Configuration highlights:

- container name: spark-master
- hostname: spark-master
- ports:
  - 8080:8080 (Spark UI)
  - 7077:7077 (cluster endpoint)
- volumes:
  - ./data:/data
  - ./processing/spark:/processing/spark

Startup command:
/opt/spark/sbin/start-master.sh

Cluster endpoint:
spark://spark-master:7077

---

### spark-worker

The `spark-worker` service provides execution resources.

Image:
apache/spark:4.1.1-python3

Configuration highlights:

- container name: spark-worker
- depends on: spark-master
- environment:
  - SPARK_WORKER_CORES=2
  - SPARK_WORKER_MEMORY=2g
- volumes:
  - ./data:/data
  - ./processing/spark:/processing/spark

Startup command:
/opt/spark/sbin/start-worker.sh spark://spark-master:7077

---

### spark-client

The `spark-client` service is used to submit jobs and run notebooks.

Built from:
processing/spark/Dockerfile.spark-client

Configuration highlights:

- container name: spark-client
- depends on: spark-master
- ports:
  - 8888:8888 (notebook)
  - 4040:4040 (Spark UI)
- working directory:
  - /home/spark/work/notebooks

Volumes:

- ./data:/data
- ./processing:/processing
- ./processing/spark/notebook:/home/spark/work/notebooks
- ./processing/spark:/processing/spark

---

### pgdatabase

PostgreSQL data warehouse.

Image:
postgres:18

Configuration:

- database: ue_energy
- user: root
- password: root
- port: 5432:5432

Volume:
ue_energy_postgres_data → /var/lib/postgresql

---

### pgadmin

Database management UI.

Image:
dpage/pgadmin4

Configuration:

- email: admin@admin.com
- password: root
- port: 8085:80

Volume:
pgadmin_data → /var/lib/pgadmin

---

### metabase

Dashboarding service.

Image:
metabase/metabase:latest

Configuration:

- port: 3000:3000
- depends on: pgdatabase

Volume:
metabase_data → /metabase-data

Environment:
MB_DB_FILE=/metabase-data/metabase.db

---

## Network

Spark services use:

spark-network (bridge)

This allows communication via service names like:

- spark-master
- spark-worker

Other services use the default Docker network.

---

## Volumes

Named volumes:

- ue_energy_postgres_data
- pgadmin_data
- metabase_data

Bind mounts:

- ./data:/data
- ./processing:/processing
- ./processing/spark:/processing/spark
- ./processing/spark/notebook:/home/spark/work/notebooks

---

## Ports

| Service | Port | Purpose |
|--------|------|--------|
| spark-master | 8080 | UI |
| spark-master | 7077 | cluster |
| spark-client | 8888 | notebook |
| spark-client | 4040 | Spark UI |
| postgres | 5432 | DB |
| pgadmin | 8085 | UI |
| metabase | 3000 | UI |

---

## Start Infrastructure

docker compose up -d --build

Stop:

docker compose down

---

## Pipeline Integration

Ingestion:
- runs locally
- produces raw data

Processing:
- uses Spark cluster

Transformation:
- uses PostgreSQL

Dashboard:
- uses PostgreSQL + Metabase

---

## Design Principles

- reproducible
- modular
- local-first
- easy debugging

---

## Future Improvements

- Kestra orchestration
- unified network
- production metadata DB
- cloud migration

---

## Final Note

The infrastructure layer enables the entire pipeline to run locally in a consistent and reproducible way.

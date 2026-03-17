# 📁 Project Structure

This document describes the **high-level folder structure** of the project.

The goal is to keep a **clear separation of responsibilities** across the data pipeline layers.  
While internal files may evolve, this structure should remain stable.

---

## 🗂️ Overview

```
project-root/

├── dashboard/
├── data/
├── docs/
├── orchestration/
├── ingestion/
├── processing/
├── transformation/
├── docker-compose.yml
├── main.py
└── README.md
```

---

## 🔹 Ingestion

Responsible for extracting data from external sources.

```
ingestion/
├── comext/
├── eurostat/
└── run_ingestion.py
```

- `run_ingestion.py` is the entrypoint that handles API calls and raw data extraction
- Organizes logic by data source (e.g. Comext, Eurostat)
- Outputs data to the **raw layer**

---

## 🔹 Processing

Handles data transformation using **Apache Spark**.

```
processing/
├── run_processing.py
└── spark/
    ├── jobs/
    ├── notebook/
    └── Dockerfile.spark-client
```

- `run_processing.py` is the entrypoint for Spark jobs
- `jobs/` contains modular processing scripts
- `notebook/` is used for exploration and debugging
- Outputs data to the **processed layer**

---

## 🔹 Transformation

Applies business logic and prepares data for analytics.

```
transformation/
├── dbt/
├── loaders/
└── run_transformation.py
```

- `run_transformation.py` is the entrypoint that loads data into PostgreSQL and transforms it using dbt
- `loaders/` handles loading data into storage systems (e.g. PostgreSQL)
- `dbt/` contains transformation models (staging, marts)
- Outputs data to the **curated layer**

---

## 🔹 Data

Stores data across different pipeline stages.

```
data/
├── raw/
├── processed/
└── curated/
```

- `raw/`: data from ingestion
- `processed/`: data transformed by Spark
- `curated/`: final data ready for analytics

---

## 🔹 Docs

Project documentation.

```
docs/
├── ingestion/
├── processing/
├── transformation/
└── ...
```

- Contains usage guides and architecture notes

---
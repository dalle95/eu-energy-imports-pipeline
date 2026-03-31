# EU Energy Imports Pipeline

## Project Overview

This project builds an end-to-end **data engineering pipeline** to analyze **European Union energy imports**, focusing on:

* Natural Gas
* Oil

The main objective is to understand how the EU energy supply changed **before and after the sanctions against the Russian Federation**, analyzing:

* import volumes
* import costs
* supplier countries
* dependency shifts

---

## Key Insight

The analysis shows that:

* EU dependency on Russian energy **dropped dramatically after 2022**
* Total import volumes remained relatively stable
* The main impact of sanctions was a **price shock**, especially in gas markets
* The EU rapidly **restructured its supplier network** (US, Norway, LNG)

---

## Dashboard Preview

Below is an example of the final analytical dashboard built in Metabase:

![Dashboard Preview](/docs/dashboard/metabase/images/dashboard_overview.png)

> The dashboard is structured to compare **pre- and post-sanctions periods**, allowing clear visualization of structural changes in the EU energy market.

---

## Dashboard Analysis

The dashboard answers key analytical questions:

1. How have EU imports evolved over time?
2. How significant was Russia compared to other suppliers?
3. How did the supplier mix change after sanctions?
4. How did prices and volumes evolve?
5. LNG vs pipeline: how did gas supply change?

Each question is supported by a dedicated visualization.

Full dashboard explanation:
-> `docs/dashboard/metabase/dashboard_setup.md`

---

## Data Sources

This project integrates multiple **official and authoritative data sources** to ensure analytical accuracy :

### Core Sources

* **Eurostat (Comext / ITGS)**

  * EU imports by partner and product
  * value and quantity data
  * main source for cost analysis

* **Eurostat Energy Statistics (nrg datasets)**

  * energy-specific trade datasets
  * harmonized classifications

---

## Architecture

The pipeline follows a modern data engineering architecture:

```
Data Sources
    ↓
Kestra Orchestration
    ↓
Python Ingestion
    ↓
Raw Data Lake (CSV/XML)
    ↓
Spark Processing
    ↓
Processed Data (Parquet)
    ↓
PostgreSQL Data Warehouse
    ↓
dbt Transformation (Star Schema)
    ↓
Metabase Dashboard
```

---

## Technology Stack

| Layer            | Technology      |
| ---------------- | --------------- |
| Orchestration    | Kestra          |
| Ingestion        | Python          |
| Processing       | Spark / PySpark |
| Storage          | Local Data Lake |
| Warehouse        | PostgreSQL      |
| Transformation   | dbt             |
| Visualization    | Metabase        |
| Containerization | Docker          |

---

## Project Structure

The project is organized to separate responsibilities across pipeline layers :

```
data/
docs/
ingestion/
processing/
transformation/
orchestration/
```

---

## Single Entrypoint

The project uses a single entrypoint:

```bash
python main.py
```

Available commands:

```bash
python main.py ingestion
python main.py processing
python main.py transformation
python main.py all
```

---

## Dashboard Setup

The Metabase dashboard is fully reproducible.

### Setup

-> `docs/dashboard/metabase/setup.md`

### Dashboard Logic

-> `docs/dashboard/metabase/dashboard_setup.md`

---

## How to Run

Start the full environment:

```bash
git clone https://github.com/dalle95/eu-energy-imports-pipeline.git
cd eu-energy-imports-pipeline

docker compose up -d --build
python main.py all
```

Then access:

-> http://localhost:3000

---

## Pipeline Phases

### Ingestion

* Extract data from APIs
* Store in `data/raw/`

### Processing

* Spark transformations
* Output in `data/processed/`

### Transformation

* Load into PostgreSQL
* Run dbt models

### Dashboard

* Metabase visualization layer

---

## Key Design Principles

* Separation of ingestion, processing and transformation
* dbt models independent from execution engine (DuckDB → PostgreSQL)
* Reproducible local environment with Docker
* BI layer fully documented

---

## Future Improvements

* Cloud migration (GCP / BigQuery)

---

## Documentation

Additional documentation:

* General → `docs/project/`
* Ingestion layer → `docs/ingestion/`
* Processing layer → `docs/processing/`
* Transformation layer → `docs/transformation/`
* Dashboard → `docs/dashboard/`

---

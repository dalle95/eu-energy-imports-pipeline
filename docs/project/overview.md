# Project Overview

This document provides a high-level overview of the project and guides you through the structure and execution flow.

It is the recommended starting point for understanding how the pipeline works.

---

## Project Goal

The project builds a complete **data engineering pipeline** to analyze European Union energy imports, focusing on:

- gas
- oil
- electricity

The objective is to understand how energy supply changed over time, especially after geopolitical events such as sanctions.

---

## Pipeline Architecture

The project follows a layered data engineering architecture:

Ingestion → Processing → Transformation → Dashboard

### 🔹 Ingestion

- extracts data from external APIs (Eurostat, Comext, etc.)
- stores raw datasets locally

### 🔹 Processing

- standardizes raw datasets using Spark
- converts data into structured formats (Parquet)

### 🔹 Transformation

- applies business logic using dbt
- builds analytical models (facts and dimensions)

### 🔹 Dashboard

- exposes final data through Metabase
- enables analysis and visualization

---

## 📁 Project Structure

project-root/

├── ingestion/
├── processing/
├── transformation/
├── dashboard/
├── data/
├── docs/
├── main.py

Each folder represents a specific responsibility in the pipeline.

For more details:

-> see docs/project/project_structure.md

---

## How to Run the Project

The project is executed through a **single entrypoint**:

python main.py --phase <phase> --env <env>

-> Full execution guide:

-> see docs/project/how_to_run.md

---

## End-to-End Flow

ingestion → processing → transformation

- raw data is downloaded
- data is processed and standardized
- analytical models are built

---

## Environments

The project supports two environments:

### dev

- uses DuckDB
- fast and lightweight
- ideal for development

### prod

- uses PostgreSQL
- simulates real data warehouse behavior
- used for final validation

---

## Output

The final output of the project includes:

- curated datasets (dbt models)
- analytical tables
- dashboards in Metabase

---

## Reproducibility

To reproduce the project from scratch:

1. Start infrastructure

docker compose up -d --build

2. Run the full pipeline

python main.py --phase all --env dev

3. Open Metabase

http://localhost:3000

---

## Next Steps

To explore the project in detail:

1. docs/project/how_to_run.md
2. docs/ingestion/
3. docs/processing/
4. docs/transformation/
5. docs/dashboard/

---

## Design Principles

This project is built following key data engineering principles:

- modular architecture
- separation of concerns
- environment portability (DuckDB → PostgreSQL)
- reproducibility
- clear data flow across layers

---

## Final Note

This project is designed not only to produce data, but to demonstrate:

- end-to-end pipeline design
- real-world data integration challenges
- analytical modeling best practices

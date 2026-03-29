# Data Processing Layer

This document describes the processing layer of the project, responsible for transforming raw data into structured datasets ready for analytical modeling.

---

## Purpose

The processing layer is responsible for:

- reading raw data produced during ingestion
- standardizing heterogeneous datasets
- applying schema harmonization
- converting data into optimized formats (Parquet)

This layer acts as a bridge between raw data and the analytical transformation layer.

---

## Architecture Overview

The processing phase follows this flow:

Raw data (CSV/XML) → PySpark transformations → Processed data (Parquet)

The entrypoint of this phase is:

processing/run_processing.py

---

## Role in the Pipeline

The processing layer sits between:

- ingestion (data extraction)
- transformation (dbt modeling)

Ingestion → Processing → Transformation

It ensures that all datasets:

- have consistent schema
- use standardized units
- are ready for efficient querying

---

## Execution Model

Processing is executed using Apache Spark in a Dockerized environment.

Spark is used to:

- handle large datasets
- perform distributed transformations
- efficiently convert CSV to Parquet

---

## Data Input

The processing layer reads data from:

data/raw/

Example:

data/raw/comext/facts/gas_imports/  
data/raw/comext/facts/oil_imports/

These datasets are produced during the ingestion phase.

---

## Data Output

Processed datasets are stored in:

data/processed/

Example:

data/processed/comext/facts/gas_imports/  
data/processed/comext/facts/oil_imports/

The output format is typically:

- Parquet

---

## Key Transformations

Typical transformations performed in this layer include:

- schema normalization
- column renaming
- type casting
- unit standardization
- filtering invalid or inconsistent records

---

## Why Parquet

The processing layer converts datasets into Parquet because:

- columnar storage improves query performance
- smaller file size compared to CSV
- optimized for analytical engines (Spark, DuckDB, PostgreSQL ingestion)

---

## Design Principles

The processing layer is designed following these principles:

- separation from ingestion logic
- independence from transformation (dbt)
- reproducibility through deterministic transformations
- scalability via Spark

---

## Challenges and Solutions

### Large Input Files

Problem:
- raw datasets can be large and fragmented

Solution:
- Spark handles distributed reading and processing

---

### Heterogeneous Data

Problem:
- multiple formats and schemas (CSV, XML-derived data)

Solution:
- standardize schema before writing processed output

---

### Performance

Problem:
- CSV processing can be slow

Solution:
- convert early to Parquet for downstream efficiency

---

## Integration with Other Layers

### Upstream (Ingestion)

- consumes raw datasets produced by ingestion
- assumes data is correctly partitioned

---

### Downstream (Transformation)

- provides clean, structured datasets for dbt
- ensures compatibility with both DuckDB and PostgreSQL

---

## Execution

To run the processing phase, see:

docs/processing/run_processing_spark.md

---

## Final Note

The processing layer is a critical step that ensures data quality and consistency before analytical modeling.

It transforms raw, heterogeneous data into a structured and optimized format, enabling efficient downstream transformations and analytics.

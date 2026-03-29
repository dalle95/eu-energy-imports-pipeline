# Data Ingestion Layer

This document describes the ingestion layer of the project, responsible for extracting raw data from external sources and storing it in a structured format.

The ingestion layer is designed to be:

- modular
- configurable
- extensible
- resilient to large datasets

---

## Purpose

The ingestion layer is responsible for:

- extracting data from external APIs (Eurostat, Comext)
- organizing raw datasets into a structured data lake
- preparing data for downstream processing (Spark) and transformation (dbt)

---

## Architecture Overview

The ingestion phase follows this flow:

External APIs → Python extraction scripts → Raw data storage

The entrypoint of the ingestion phase is:

ingestion/run_ingestion.py

This script orchestrates the execution of all ingestion tasks.

---

## Execution Flow

The ingestion runner executes multiple steps sequentially:

1. Download Eurostat dimensions
2. Download Eurostat datasets (prepared for future use)
3. Download Comext gas imports
4. Download Comext oil imports

This design ensures:

- separation between dimensions and facts
- ability to extend ingestion without modifying existing logic

---

## Data Sources

The ingestion layer integrates multiple sources:

### Eurostat

Used for:

- dimension tables (countries, partners, classifications)
- energy datasets (future extension)

Data is retrieved via:

- SDMX API
- XML structure endpoints

---

### Comext (Eurostat Trade Database)

Used for:

- detailed trade data (imports)
- value and quantity metrics
- partner-level granularity

This is the core dataset currently used end-to-end in the project.

---

## Configuration-Driven Design

Datasets are defined in configuration files:

ingestion/comext/config/datasets.py  
ingestion/eurostat/config/datasets.py

This allows:

- separation of logic and configuration
- easy extension of datasets
- centralized control of filters and parameters

Example configuration elements:

- dataset_id
- filters (geo, unit, frequency)
- time ranges

---

## Key Design Choice

Instead of hardcoding API parameters inside scripts, datasets are:

defined in config  
consumed by extraction scripts  

This makes the ingestion layer flexible and reusable.

---

## Data Storage Structure

Raw data is stored in the local data lake:

data/

├── raw/  
│   ├── comext/  
│   │   └── facts/  
│   │       ├── gas_imports/  
│   │       └── oil_imports/  
│   │  
│   └── eurostat/  
│       ├── dimensions/  
│       └── facts/  
│  
├── processed/  
│   └── eurostat/  
│       └── dimensions/  

---

## Comext Data Extraction Strategy

Comext datasets are very large, so extraction is designed to avoid API limits.

### Partitioning Strategy

Data is downloaded:

- by year
- by product (gas: LNG vs pipeline)

This prevents errors such as:

- request size limits
- timeouts
- API failures

---

### Output Format

Each extraction produces:

- one file per partition (e.g. year)
- CSV format

Example:

data/raw/comext/facts/gas_imports/  
    ├── gas_271111_imports_1990.csv  
    ├── gas_271111_imports_1995.csv
    ├── gas_271121_imports_2025.csv

---

## Eurostat Dimensions

Eurostat dimensions are handled differently from facts.

### Extraction

- downloaded as XML (SDMX structure)
- parsed using Python

### Output

- transformed into CSV
- stored in:

data/processed/eurostat/dimensions/

---

### Why This Matters

Dimensions are essential for:

- enriching fact tables
- building analytical models (dbt)
- providing readable labels (countries, partners)

---

## Current Scope vs Future Extension

### Currently Implemented End-to-End

- Comext facts (gas and oil imports)
- Eurostat dimensions

---

### Prepared but Not Yet Integrated

- Eurostat energy datasets (oil, gas, electricity)

These datasets are already:

- defined in configuration
- downloadable via ingestion

But they are not yet used in:

- processing (Spark)
- transformation (dbt)

---

## Design Philosophy

The ingestion layer is designed with future scalability in mind.

Key principles:

- modular extraction scripts
- configuration-driven datasets
- separation between sources
- extendable without breaking existing logic

---

## Challenges and Solutions

### Large Dataset Size (Comext)

Problem:
- API returns very large datasets
- risk of request failure

Solution:
- partition extraction by year and product
- split requests into smaller chunks

---

### API Limitations

Problem:
- timeouts
- extraction limits

Solution:
- smaller queries
- structured iteration over parameters

---

### Heterogeneous Data Formats

Problem:
- CSV (Comext)
- XML (Eurostat)

Solution:
- normalize outputs into structured CSV
- prepare data for downstream processing

---

## Integration with Next Layers

The ingestion layer feeds:

### Processing (Spark)

- reads raw CSV files
- standardizes datasets
- converts to Parquet

### Transformation (dbt)

- consumes processed data
- builds analytical models

---

## Final Note

The ingestion layer is not just about downloading data.

It is designed to:

- handle real-world API constraints
- structure data for analytics
- enable scalable data processing

This makes it a critical foundation of the entire pipeline.

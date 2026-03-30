# Data Transformation Layer with dbt

This document describes the full **transformation process** implemented in this project using **dbt**.

The transformation layer is designed to be:

- portable across environments
- modular and layered
- independent from the execution engine
- ready for analytics and dashboarding

A key part of this design is the ability to work in **development** with **DuckDB** and move to **production** with **PostgreSQL** **without changing dbt models**.

---

## Overview

The transformation workflow follows a layered approach:

```text
raw → staging → intermediate → marts → reporting
```

Each layer has a specific responsibility:

- **raw**: exposes the source data to dbt
- **staging**: standardizes and lightly cleans the raw data
- **intermediate**: combines and prepares datasets with business logic
- **marts**: builds reusable analytical facts and dimensions
- **reporting**: creates final datasets ready for BI tools and dashboards

---

## Core Design Principle

The most important architectural choice is the use of a **dbt source abstraction layer**.

All dbt models read data through `source()` definitions, for example:

```sql
select *
from {{ source('raw_energy', 'comext_gas_imports_quantity') }}
```

This means the transformation logic does **not** depend on:

- direct file access
- DuckDB-specific functions
- PostgreSQL-specific table names inside models

Because of this, the same dbt models can run in both environments.

---

## Transformation Layers

### 1. Raw Layer

The raw layer is the entry point of data into dbt.

It is defined in `sources.yml` and includes datasets such as:

- COMEXT oil imports value
- COMEXT oil imports quantity
- COMEXT gas imports value
- COMEXT gas imports quantity
- Eurostat dimension tables

Example source definition:

```yml
version: 2

sources:
  - name: raw_energy
    schema: raw
    tables:
      - name: comext_oil_imports_value
      - name: comext_oil_imports_quantity
      - name: comext_gas_imports_value
      - name: comext_gas_imports_quantity
```

The important point is that dbt always reads from the same logical source names, regardless of the underlying engine.

---

### 2. Staging Layer

The staging layer standardizes the raw data.

Typical operations include:

- renaming columns
- normalizing data types
- applying light cleaning
- preparing fields for downstream joins and calculations

Example:

```sql
{{ config(materialized='view') }}

with 
dataset_comext_gas_imports_quantity as (
    select
        reporter,
        partner,
        product as product_code,
        time_period,
        cast(obs_value as decimal(38,2)) as quantity_100kg,
        '100kg' as quantity_unit
    from {{ source('raw_energy', 'comext_gas_imports_quantity') }}
)

select *
from dataset_comext_gas_imports_quantity
```

This layer should stay close to the source data while making it easier to use downstream.

---

### 3. Intermediate Layer

The intermediate layer applies more meaningful transformation logic.

Typical operations include:

- joining value and quantity datasets
- unit conversions
- deriving business fields
- standardizing analytical structures before facts and dimensions

This is where source-level datasets start becoming analysis-ready.

---

### 4. Marts Layer

The marts layer contains the core analytical model.

Typical outputs include:

- fact tables
- dimension tables

Examples from this project include models such as:

- `ftc_energy_imports`
- partner dimensions
- reporter dimensions
- other reusable analytical entities

This layer is the foundation used by reporting models and dashboards.

---

### 5. Reporting Layer

The reporting layer contains final, dashboard-ready datasets.

This is where the project exposes metrics and analytical outputs such as:

- total imports
- market share by partner
- year-over-year variations
- dependency by product
- LNG vs pipeline comparisons
- price vs volume decomposition
- Russia vs other partner comparisons

These models are designed to be consumed directly by BI tools.

---

## Development Environment with DuckDB

In development, the project uses **DuckDB** to enable fast local iteration.

### How it works

The raw layer is exposed in DuckDB through views that read directly from local files such as Parquet and CSV.

This means data does not need to be physically loaded into a database during development.

Conceptually, the flow is:

```text
Files → DuckDB raw views → dbt models
```

### Setup command

To prepare the DuckDB development environment, the project uses:

```bash
uv run .\transformation\duckdb_setup\build_setup.py
```

### Why this is useful

Using DuckDB in development provides several benefits:

- very fast local iteration
- minimal setup overhead
- direct reading from Parquet and CSV files
- easy testing of dbt logic without loading everything into PostgreSQL

This makes DuckDB an excellent engine for development and experimentation.

---

## Production Environment with PostgreSQL

In production, the project uses **PostgreSQL** as the analytical warehouse.

### How it works

Instead of exposing raw data through views over files, the raw datasets are physically loaded into PostgreSQL tables.

Conceptually, the flow is:

```text
Files → PostgreSQL raw tables → dbt models
```

### Load command

To load the data into PostgreSQL, the project uses:

```bash
uv run .\transformation\engines\postgres\scripts\postgres_loader.py
```

After the load step, dbt reads from the same logical sources defined in `sources.yml`, but now those sources point to PostgreSQL tables in the `raw` schema.

---

## DEV to PROD Transition

A central goal of this project is making the transition from development to production smooth and predictable.

### What changes

When moving from DuckDB to PostgreSQL, these elements change:

| Component | DEV | PROD |
|---|---|---|
| Execution engine | DuckDB | PostgreSQL |
| Raw storage | Views over local files | Physical tables |
| Data access backend | File-based | Database-based |

### What does not change

These elements remain exactly the same:

- dbt source names
- dbt staging models
- dbt intermediate models
- dbt marts
- dbt reporting logic
- business rules and calculations

This is possible because the project isolates storage concerns from transformation logic.

---

## Why the Transition Requires No dbt Model Changes

The project was intentionally designed so that dbt models never read files directly.

Instead of using engine-specific logic such as:

- `read_parquet(...)`
- `read_csv(...)`

inside dbt models, all models depend on `source()`.

That means:

- in DuckDB, the source points to views
- in PostgreSQL, the source points to tables

From the dbt model perspective, nothing changes.

This is the key design choice that makes the transformation layer portable.

---

## dbt Profiles and Targets

The project defines two execution targets:

- **dev** → DuckDB
- **prod** → PostgreSQL

The dbt profile is configured so the same project can run against both engines by simply switching target.

### Run in development

```bash
dbt run --target dev
```

### Run in production

```bash
dbt run --target prod
```

This allows the exact same transformation codebase to be executed in different environments.

---

## End-to-End Transformation Workflow

### Development workflow

1. Prepare the DuckDB setup  
   `uv run .\transformation\duckdb_setup\build_setup.py`

2. Run dbt models on DuckDB  
   `dbt run --target dev`

This is the preferred workflow for local development and iteration.

### Production workflow

1. Load raw data into PostgreSQL  
   `uv run .\transformation\engines\postgres\scripts\postgres_loader.py`

2. Run dbt models on PostgreSQL  
   `dbt run --target prod`

This is the workflow used to build the production analytical layer.

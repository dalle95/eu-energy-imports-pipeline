# EU Energy Imports Pipeline

## Project Overview

This project builds an end-to-end **data engineering pipeline** to
analyze **European Union energy imports**, focusing on three key
commodities:

-   Natural Gas
-   Oil
-   Electricity

The goal is to analyze how the European energy supply changed **before
and after sanctions against Russia**, examining:

-   Import volumes
-   Import costs
-   Supplier countries
-   Energy dependency shifts over time

The project integrates **official European data sources** and builds a
unified analytical platform for exploring supply dynamics and
geopolitical impacts on EU energy markets.

The first version of the project is designed as a **local data
platform**, built to demonstrate a complete data engineering workflow
including ingestion, orchestration, transformation, modeling and
visualization.

A future iteration may migrate the architecture to a **cloud-based
stack**.

------------------------------------------------------------------------

# Analytical Goals

The project aims to answer questions such as:

-   How did EU imports of gas, oil and electricity change after
    sanctions against Russia?
-   Which countries replaced Russia as major energy suppliers?
-   How did import costs evolve before and after sanctions?
-   Which energy commodities showed the largest dependency shifts?
-   How do trade statistics compare with physical energy flows?

------------------------------------------------------------------------

# Data Sources

The pipeline integrates multiple official European data sources:

-   **Eurostat** -- trade and energy statistics
-   **ENTSOG Transparency Platform** -- gas network flows
-   **ENTSO-E Transparency Platform** -- electricity flows and prices
-   **EU Sanctions Timeline / EUR-Lex** -- regulatory events and
    sanctions timeline

Combining these sources allows the project to compare **trade
statistics, physical energy flows and geopolitical events**.

------------------------------------------------------------------------

# Architecture

Pipeline overview:

Data Sources\
↓\
Kestra Orchestration\
↓\
Python Data Ingestion\
↓\
Raw Data Lake (CSV files)\
↓\
Spark Processing Layer\
↓\
Curated Data Lake (Parquet)\
↓\
PostgreSQL Data Warehouse\
↓\
dbt Transformations (Star Schema)\
↓\
Metabase Dashboards

------------------------------------------------------------------------

# Orchestration

**Kestra** is used as the workflow orchestrator.

Kestra coordinates the execution of:

-   Data ingestion tasks
-   Spark processing jobs
-   Data warehouse loading
-   dbt transformations

This enables reproducible and automated pipeline execution.

------------------------------------------------------------------------

# Data Ingestion

Python scripts extract datasets from official sources and store them in
a **local raw data lake**.

The ingestion layer is responsible for:

-   API interaction
-   dataset download
-   schema inspection
-   metadata logging

------------------------------------------------------------------------

# Processing Layer

**Spark / PySpark** is used to standardize heterogeneous datasets and
convert raw files into **Parquet format**.

Typical processing tasks include:

-   schema harmonization
-   unit normalization
-   timestamp formatting
-   raw dataset standardization

------------------------------------------------------------------------

# Data Warehouse

A **PostgreSQL** database acts as the analytical warehouse.

Curated datasets are loaded into PostgreSQL to enable efficient querying
and modeling.

------------------------------------------------------------------------

# Data Transformation

Transformations are managed using **dbt**.

The transformation layers follow the common dbt convention:

-   **staging** -- source cleanup and renaming
-   **intermediate** -- business logic and harmonization
-   **marts** -- reporting-ready datasets

The final reporting layer follows a **star schema**.

------------------------------------------------------------------------

# Data Visualization

**Metabase** is used for:

-   dashboard creation
-   exploratory analysis
-   reporting

Dashboards will highlight:

-   energy imports over time
-   supplier country shifts
-   price and cost evolution
-   pre- and post-sanctions comparisons

------------------------------------------------------------------------

# Technology Stack

  Layer                    Technology
  ------------------------ -------------------------
  Workflow orchestration   Kestra
  Data ingestion           Python
  Processing               Spark / PySpark
  Data lake                Local storage
  Data warehouse           PostgreSQL
  Data transformation      dbt
  Visualization            Metabase
  Containerization         Docker / Docker Compose

------------------------------------------------------------------------

# Repository Structure

See the `docs/` folder for architecture and technology documentation.

The repository is structured to clearly separate:

-   ingestion
-   processing
-   storage
-   warehouse
-   transformation
-   visualization

------------------------------------------------------------------------

# Future Cloud Architecture

A future iteration of this project may migrate to a cloud architecture.

Possible stack:

-   Google Cloud Storage -- data lake
-   BigQuery -- data warehouse
-   dbt Core -- transformations
-   Looker -- visualization
-   Airflow or Kestra -- orchestration

------------------------------------------------------------------------

# Documentation

Additional documentation is available in the `docs/` directory,
including:

-   architecture decisions
-   data sources description
-   technology documentation

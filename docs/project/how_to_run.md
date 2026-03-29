# How to Run the Project

This document explains how to execute the project from the main entrypoint using command-line arguments.

The goal is to provide a **single, consistent way** to run the pipeline phases without launching each component manually.

---

## Overview

The project can be executed from the root directory through:

```bash
python main.py --phase <phase> --env <environment>
```

The `main.py` script acts as the central orchestrator for the local pipeline and dispatches execution to the corresponding project phase.

This approach makes the project easier to:

- run
- understand
- document
- reproduce

---

## Arguments

### `--phase`

Defines which pipeline phase should be executed.

Supported values:

- `ingestion`
- `processing`
- `transformation`
- `all`

### `--env`

Defines the execution environment.

Supported values:

- `dev`
- `prod`

---

## Available Phases

### `ingestion`

Runs the ingestion layer only.

This phase is responsible for extracting raw data from external sources and storing it in the raw data layer.

Typical responsibilities:

- call external APIs
- download source datasets
- organize raw files in the project storage

---

### `processing`

Runs the processing layer only.

This phase is responsible for standardizing raw files and preparing processed datasets, typically through Spark jobs.

Typical responsibilities:

- read raw files
- apply schema harmonization
- convert data into processed formats such as Parquet

---

### `transformation`

Runs the transformation layer only.

This phase is responsible for loading or exposing processed data to the analytical engine and executing dbt models.

Typical responsibilities depend on the selected environment:

- in `dev`: prepare DuckDB and run dbt on DuckDB
- in `prod`: load data into PostgreSQL and run dbt on PostgreSQL

---

### `all`

Runs the full pipeline end-to-end.

Execution order:

```text
ingestion → processing → transformation
```

This is the recommended option when reproducing the full project from scratch.

---

## Available Environments

### `dev`

Development environment.

Used for fast local iteration and testing.

Typical behavior:

- local execution
- DuckDB-based transformation workflow
- minimal setup overhead

This environment is useful when developing and validating the pipeline logic.

---

### `prod`

Production-like environment.

Used to simulate the final warehouse workflow.

Typical behavior:

- processed data loaded into PostgreSQL
- dbt models executed against PostgreSQL
- setup closer to a real analytical warehouse

This environment is useful when validating the final end-to-end architecture.

---

## Command Examples

### Run ingestion only

```bash
python main.py --phase ingestion --env dev
```

### Run processing only

```bash
python main.py --phase processing --env dev
```

### Run transformation in development mode

```bash
python main.py --phase transformation --env dev
```

### Run transformation in production mode

```bash
python main.py --phase transformation --env prod
```

### Run the full pipeline in development mode

```bash
python main.py --phase all --env dev
```

### Run the full pipeline in production mode

```bash
python main.py --phase all --env prod
```

---

## Internal Execution Logic

At a high level, `main.py` works as a dispatcher.

Depending on the selected arguments, it triggers the corresponding phase runner:

- ingestion runner
- processing runner
- transformation runner

Conceptually:

```text
main.py
 ├── ingestion
 ├── processing
 └── transformation
```

This design keeps the entrypoint simple while preserving modularity inside each pipeline layer.

---

## Typical Usage Patterns

### During development

A common workflow is:

1. run ingestion
2. run processing
3. run transformation in `dev`

Example:

```bash
python main.py --phase ingestion --env dev
python main.py --phase processing --env dev
python main.py --phase transformation --env dev
```

This is useful when working incrementally on one phase at a time.

---

### For full local reproducibility

Run the whole pipeline from scratch:

```bash
python main.py --phase all --env dev
```

This is the simplest way to reproduce the project locally.

---

### For warehouse-oriented validation

Run the full project using PostgreSQL:

```bash
python main.py --phase all --env prod
```

This is useful to validate the production-oriented version of the pipeline.

---

## Requirements

Before running the project, make sure that:

- the project dependencies are installed
- Docker services are available if required by the selected phase
- the necessary local folders exist
- the database containers are running when using `prod`
- the Spark environment is available when running the processing phase

A typical startup command is:

```bash
docker compose up -d --build
```

---

## Recommended Execution Order

If starting from an empty local environment, use the following order:

1. start infrastructure
2. run ingestion
3. run processing
4. run transformation
5. open the dashboard layer if needed

Or simply:

```bash
python main.py --phase all --env dev
```

or

```bash
python main.py --phase all --env prod
```

---

## Notes

- `dev` and `prod` do not change the business logic of the project
- they only change the execution environment and storage backend
- the separation between phases makes the pipeline easier to test and maintain
- using `main.py` as a single entrypoint improves reproducibility and usability

---

## Related Documentation

For more details, see:

- `docs/project/project_structure.md`
- `docs/processing/run_processing_spark.md`
- `docs/transformation/transformation_layer.md`

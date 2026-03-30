# 📊 Metabase Setup (Docker)

## Overview

This document describes how Metabase is configured and deployed in this project using Docker.

The goal is to provide a **fully reproducible BI environment**, allowing anyone to:

* start Metabase locally
* connect to the PostgreSQL data warehouse
* explore the dashboard

---

## Docker Configuration

Metabase is deployed as a Docker container using the following configuration:

```yaml
metabase:
  image: metabase/metabase:latest
  container_name: metabase
  ports:
    - "3000:3000"
  volumes:
    - metabase_data:/metabase-data
  environment:
    MB_DB_FILE: /metabase-data/metabase.db
  depends_on:
    - pgdatabase
```

---

## Key Components

### 🔹 Image

* `metabase/metabase:latest`
* Official Metabase Docker image

---

### 🔹 Port Mapping

```yaml
ports:
  - "3000:3000"
```

* Metabase is exposed on:
  👉 http://localhost:3000

---

### 🔹 Persistent Storage

```yaml
volumes:
  - metabase_data:/metabase-data
```

* Stores:

  * dashboards
  * questions
  * database connections
  * settings

This ensures that Metabase state is preserved across container restarts.

---

### 🔹 Internal Database

```yaml
environment:
  MB_DB_FILE: /metabase-data/metabase.db
```

* Metabase uses an embedded **H2 database**
* Stored inside the mounted volume
* No external DB required for metadata

---

### 🔹 Dependency

```yaml
depends_on:
  - pgdatabase
```

* Ensures PostgreSQL is started before Metabase
* Required to allow immediate connection to the data warehouse

---

## Network Configuration

```yaml
networks:
  spark-network:
    driver: bridge
```

* Shared Docker network between:

  * Metabase
  * PostgreSQL
  * other services (e.g. Spark)

This allows containers to communicate using service names.

---

## Volume Definition

```yaml
volumes:
  metabase_data:
```

* Named Docker volume
* Automatically created if not present

---

## How to Run

From the project root:

```bash
docker compose up -d
```

Then open:

👉 http://localhost:3000

---

## Initial Setup

On first startup, Metabase requires configuration:

1. Create admin account
2. Connect to PostgreSQL database:

   * Host: `pgdatabase`
   * Port: `5432`
   * Database: `ue_energy`
   * User: `root`
   * Password: `root`
3. Select schemas/tables to expose

---

## Notes

* The Metabase database (`metabase.db`) is **not version-controlled**
* Dashboards are documented separately in this repository
* This approach ensures:

  * reproducibility of infrastructure
  * separation between data and BI layer

---

## Limitations

* The internal H2 database is suitable for local/dev environments only
* For production use, an external database (PostgreSQL/MySQL) is recommended

---

## Summary

This setup provides a lightweight and portable way to:

* run Metabase locally
* connect to the data warehouse
* reproduce the analytical layer of the project

---

# Orchestration Layer (Kestra)

## Overview

The orchestration layer is responsible for coordinating the execution of the entire data pipeline.

In this project, orchestration is handled by **Kestra**, which executes the pipeline phases in sequence:

1. Ingestion  
2. Processing  
3. Transformation  

Kestra acts as the control plane, while the actual execution happens inside dedicated runtime environments.

---

## Architecture

The orchestration architecture is composed of:

- **Kestra (Orchestrator)**
- **Pipeline Runner (Python Execution Environment)**
- **Spark Client (Processing Runtime)**
- **PostgreSQL (Metadata & Data Warehouse)**

### High-Level Flow

Kestra Flow → Task Execution → (Python Runner / Spark Client) → PostgreSQL

---

## Project Structure

orchestration/
└── kestra/
    ├── config/
    │   └── application.yml
    ├── flows/
    │   └── eu_energy_pipeline.yml
    ├── Dockerfile.kestra
    └── Dockerfile.runner

---

## Kestra Components

### Flows

Flows define the pipeline logic and are stored in:

orchestration/kestra/flows/

Each flow defines the sequence of tasks:

- run_ingestion
- run_processing
- run_transformation

---

## Task Execution Strategy

### Ingestion & Transformation

- Executed using Docker Task Runner
- Run inside eu-energy-pipeline-runner:latest
- Provides isolated Python environment and reproducibility

### Processing

- Executed using Process Task Runner
- Uses docker exec on spark-client
- Required due to Spark runtime and mounted volumes

---

## Configuration (application.yml)

Location:

orchestration/kestra/config/application.yml

### Configuration Content

datasources:
  postgres:
    url: jdbc:postgresql://pgdatabase:5432/ue_energy
    driver-class-name: org.postgresql.Driver
    username: root
    password: root

kestra:
  repository:
    type: postgres
  queue:
    type: postgres
  storage:
    type: local
    local:
      base-path: /app/storage

---

## Configuration Explanation

- datasources.postgres: connection used by Kestra internally
- repository: stores flows and executions
- queue: manages task execution queue
- storage: stores temporary files and artifacts

---

## Network Configuration

All services use project-network.

Kestra tasks must specify:

taskRunner:
  networkMode: project-network

---

## Execution

Start services:

docker compose up -d --build

Access UI:

http://localhost:8081

Run pipeline via UI.


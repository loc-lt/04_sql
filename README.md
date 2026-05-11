# Project 04 - SQL (Full Requirement Implementation)

This implementation follows the full Project 04 requirement:

- create and populate `orders` and `order_item`
- generate large transactional data (2.5M to 3M orders)
- generate transaction rows with Python `Faker` (aligned with Project03 style)
- optimize with partitions and indexes
- benchmark query runtime and execution plans
- build dynamic reports using SQL functions and procedures

## Scope

- Data source from Project 03 master tables:
  - `brand`
  - `category`
  - `seller`
  - `product`
  - `promotion`
  - `promotion_product`
- New transactional layer in Project 04:
  - `orders` (partitioned by `order_date`)
  - `order_item` (partitioned by `order_date`)

## Objectives

- Build high-volume synthetic transaction data with relational consistency.
- Ensure each order has 3-4 products from the same seller as the order.
- Keep order dates within `2025-08-01` to `2025-10-31`.
- Compare baseline vs optimized query plans.
- Deliver reusable reporting functions and one procedure-based snapshot flow.

## Project Layout

- `run_order.md`: exact execution order.
- `assumptions.md`: technical and business assumptions.
- `data_dictionary.md`: reference for key columns and tables.
- `checks/`: acceptance criteria and reviewer quickstart.
- `src/`: modular Python code (`config`, `db`, `generators`, `loaders`, benchmark snapshot runner).
- `python/generate_orders_faker.py`: backward-compatible entrypoint wrapper.
- `sql/00_bootstrap`: setup and schema bootstrap.
- `sql/01_quality_gate`: data quality and rule validation.
- `sql/02_marts`: reporting views.
- `sql/03_kpis`: required business queries.
- `sql/04_performance`: optional manual explain scripts.
- `sql/05_dynamic_reports`: functions, procedure, and usage examples.
- `sql/99_submission`: final query bundle and result snapshot template.
- `output/benchmarks`: generated runtime + execution plan snapshots.

## How To Run

### Install dependencies (Poetry)

```bash
poetry install
```

Or from repository root:

```bash
poetry -C . install
```

Create a local `.env` from `.env.example` and point it to the PostgreSQL database that already contains Project 03 reference tables.

### Execute workflow

1. Ensure Project 03 data already exists in the same PostgreSQL database.
2. Build partitioned tables from SQL bootstrap.
3. Run Python Faker generator for `orders` and `order_item`.
4. Capture baseline snapshot with `poetry run python -m src.snapshot_benchmarks --stage baseline`.
5. Apply indexes and capture optimized snapshot with `poetry run python -m src.snapshot_benchmarks --stage optimized`.
6. Compare latest benchmark runs with `poetry run python -m src.compare_benchmarks`.
7. Follow `run_order.md` in strict order for the remaining SQL flow.
8. Save benchmark and query outputs into `sql/99_submission/results_snapshot.md`.

### Local validation

```bash
poetry run python -m unittest discover -s tests
```

## Important Notes

- Default target volume is `2,500,000` orders.
- This volume can take significant time and disk space.
- Start with lower volume first for dry run, then rerun at full volume.
- Main generator command: `poetry run python -m src.generate_transactions --truncate-first`.
- Snapshot command: `poetry run python -m src.snapshot_benchmarks --stage baseline`.
- Compare command: `poetry run python -m src.compare_benchmarks`.
- Backward-compatible alias: `poetry run python python/generate_orders_faker.py --truncate-first`.
- A full submission is not complete until `sql/99_submission/results_snapshot.md` contains row counts, representative report outputs, and the baseline-vs-optimized comparison.

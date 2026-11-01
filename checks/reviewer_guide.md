# Reviewer Guide

## Quick Verification (10-15 minutes)

1. Open `run_order.md`.
2. Run all scripts in order and execute the Python Faker generator step.
3. Confirm `orders` and `order_item` are generated with expected volume.
4. Confirm quality checks return healthy values.
5. Inspect outputs from required KPI scripts and dynamic report functions.
6. Validate benchmark snapshots under `output/benchmarks`.
7. Validate indexes in PostgreSQL (`\di` or pgAdmin index tree).
8. Confirm `sql/99_submission/results_snapshot.md` contains real row counts, benchmark comparison, and report samples.

## What to focus on

- Integrity-first workflow: quality scripts run before KPI scripts.
- Data generation logic: each order has 2-5 items; `customer_id` on orders; seller via `order_item` → `product`.
- SQL readability: clear CTE naming, explicit joins, minimal ambiguity.
- Business relevance: queries answer required optimization and report questions.
- Performance basics: baseline vs optimized plan capture with partitions and indexes.
- Reproducibility: documented commands must run from this folder without renaming the repository.

## Expected healthy signals

- No FK violations and no invalid price logic.
- No invalid totals; order line counts between 2 and 5.
- KPI outputs show realistic distribution (not all zeros or null-heavy).
- Benchmark comparison includes both runtime deltas and plan evidence.

## If something fails

- Recheck Project 03 load completeness.
- Confirm database and schema context (`current_database`, `current_schema`).
- Re-run bootstrap scripts and then quality scripts.

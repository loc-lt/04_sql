# Acceptance Checklist

## Reproducibility

- [ ] SQL scripts run end-to-end with `run_order.md`.
- [ ] No manual SQL edits are required during execution.
- [ ] Script ordering and dependencies are clearly documented.
- [ ] `.env` is created from `.env.example` and points to the Project 03 database.
- [ ] Python commands run from this folder with `poetry run python -m src...`.

## Data Generation

- [ ] `orders` volume is between 2.5M and 3M.
- [ ] Each order has 3-4 related order items.
- [ ] Order dates fall within Aug-Oct 2025.
- [ ] Order item products match the order seller.
- [ ] No seller has fewer than 4 products with non-negative `discount_price`.

## Data Quality

- [ ] Foreign key integrity issues equal 0.
- [ ] Invalid quantity/unit/subtotal rows equal 0.
- [ ] `orders.total_amount` matches sum of line subtotals.
- [ ] Duplicate `(order_id, product_id)` lines are within accepted behavior.

## Analytics

- [ ] Required optimization query set runs successfully.
- [ ] Revenue reports (monthly, daily) run successfully.
- [ ] Seller performance, top products per brand, and status summary run successfully.
- [ ] Results are explainable with business interpretation.

## Performance

- [ ] Baseline query plans are captured.
- [ ] Monthly partitions are created for `orders` and `order_item`.
- [ ] Required indexes are created successfully (including `order_item.product_id`).
- [ ] Optimized query plans are captured and compared with baseline.
- [ ] `poetry run python -m src.compare_benchmarks` output is copied into submission evidence.
- [ ] Snapshot files are available under `output/benchmarks`.

## Submission Quality

- [ ] `project04_final_queries.sql` contains final clean queries.
- [ ] `results_snapshot.md` captures representative outputs.
- [ ] `README.md`, `assumptions.md`, and `data_dictionary.md` are complete.

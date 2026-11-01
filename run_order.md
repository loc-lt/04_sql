# Run Order

Execute scripts in the following order:

1. `sql/00_bootstrap/00_session_config.sql`
2. `sql/00_bootstrap/01_prerequisites.sql`
3. `sql/00_bootstrap/02_orders_schema_partitions.sql`
4. Run Python Faker generator (seeds **both** `orders` and `order_item`):
   - `poetry run python -m src.generate_transactions --truncate-first`
   - Optional dry run: `poetry run python -m src.generate_transactions --order-count 100000 --chunk-size 10000 --truncate-first --allow-small-run`
5. `sql/00_bootstrap/03_generate_orders_data.sql` (post-load sanity checks)
6. Baseline snapshot (runtime + execution plan):
   - `poetry run python -m src.snapshot_benchmarks --stage baseline`
7. `sql/04_performance/00_baseline_explain.sql` (optional manual verification)
8. `sql/04_performance/01_indexes.sql`
9. Optimized snapshot (runtime + execution plan):
   - `poetry run python -m src.snapshot_benchmarks --stage optimized`
10. Compare latest benchmark runs:
   - `poetry run python -m src.compare_benchmarks`
11. `sql/04_performance/02_optimized_explain.sql` (optional manual verification)
12. `sql/01_quality_gate/01_row_counts.sql`
13. `sql/01_quality_gate/02_fk_integrity.sql`
14. `sql/01_quality_gate/03_business_rules.sql`
15. `sql/01_quality_gate/04_duplicates_and_nulls.sql`
16. `sql/02_marts/01_vw_product_enriched.sql`
17. `sql/02_marts/02_vw_promotion_coverage.sql`
18. `sql/02_marts/03_vw_order_item_enriched.sql`
19. `sql/03_kpis/01_catalog_health.sql`
20. `sql/03_kpis/02_price_discount_insights.sql`
21. `sql/03_kpis/03_seller_and_promotion_performance.sql`
22. `sql/03_kpis/04_required_optimization_queries.sql`
23. `sql/05_dynamic_reports/01_report_functions.sql`
24. `sql/05_dynamic_reports/02_report_procedure.sql`
25. `sql/05_dynamic_reports/03_report_examples.sql`
26. `sql/99_submission/project04_final_queries.sql`

Optional:

- Save benchmark snapshots from `output/benchmarks/*` into `sql/99_submission/results_snapshot.md`.
- Rerun generation with a larger volume after validating logic on a smaller volume.

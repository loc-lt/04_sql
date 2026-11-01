# Project 04 - SQL (Full Requirement Implementation)

**Tiếng Việt:** [`docs/HUONG_DAN_CHAY_DU_AN_04.md`](docs/HUONG_DAN_CHAY_DU_AN_04.md) — quy trình chạy từng bước. Project 05: [`docs/KE_HOACH_DU_AN_05.md`](docs/KE_HOACH_DU_AN_05.md).

Aligned with **Project 03 (refactored)** and the Notion Project 04 brief:

- populate partitioned `orders` and `order_item` on the same DB as Project 03
- **5,000,000** orders, **2–5** line items each, dates **2025-01-01 → 2025-05-31**
- `customer_id` on orders; seller analytics via `order_item` → `product`
- Python `Faker` bulk load, indexes, benchmarks, KPI SQL, dynamic reports

## Scope

- Master data from Project 03: `brand`, `category`, `seller`, `customer`, `product`, `promotion`, `promotion_product`
- Transactional layer (Project 04): partitioned `orders`, `order_item`

## How To Run

See **`run_order.md`** and **`docs/HUONG_DAN_CHAY_DU_AN_04.md`**.

Quick start:

```bash
# 1) Project 03 master data (once)
cd ../project03 && poetry run python -m src.main --load --reset-db

# 2) Project 04
cd ../04_sql && poetry install
# copy .env (same DB_NAME=ecommerce_project03)
# run sql/00_bootstrap in psql, then:
poetry run python -m src.generate_transactions --order-count 100000 --truncate-first --allow-small-run
# full volume:
poetry run python -m src.generate_transactions --truncate-first
```

### Local validation

```bash
poetry run python -m unittest discover -s tests
```

## Important Notes

- Full load (~5M orders, ~17M items) needs significant disk and runtime.
- Always dry-run with `--allow-small-run` before the full generator.
- Submission evidence: `sql/99_submission/results_snapshot.md` + benchmarks under `output/benchmarks/`.

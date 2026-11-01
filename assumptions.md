# Assumptions

## Data assumptions

- Project 03 has successfully loaded master data into PostgreSQL (`ecommerce_project03`).
- IDs in generated tables are stable and follow the schema constraints.
- Price fields are in VND-like currency units; `product.price > 0`.
- At least five active products exist so each order can sample 2–5 unique products.

## Transaction generation assumptions

- `orders` and `order_item` are recreated in Project 04 as range-partitioned tables (Jan–May 2025).
- Synthetic transaction rows are generated using Python `Faker`.
- Target volume is **5,000,000** orders (~17.5M line items at 2–5 items per order).
- Date range: `2025-01-01` through `2025-05-31`.
- Each order has **2–5** line items; products are chosen randomly from the catalog.
- `unit_price` equals `product.price` at generation time.
- Seller attribution for analytics uses `order_item` → `product` → `seller`.

## Metric assumptions

- Potential catalog GMV is estimated as `price * stock_qty`.
- Order revenue is computed from `SUM(order_item.subtotal)` at order level.
- Promotion insights use `promotion` / `promotion_product`, not a stored discount price on `product`.

## Environment assumptions

- PostgreSQL version supports table partitioning, plpgsql, window functions, and `CREATE INDEX IF NOT EXISTS`.
- Working schema is `public`.
- Database credentials are loaded from `.env` in this folder first, then from the parent folder as fallback.

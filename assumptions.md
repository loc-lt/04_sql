# Assumptions

## Data assumptions

- Project 03 has successfully loaded data into PostgreSQL using the schema described in the Project 03 brief.
- IDs in generated tables are stable and follow the schema constraints.
- Price fields are in VND-like currency units and are non-negative.
- Each seller has at least 4 products with a non-null, non-negative `discount_price`.

## Transaction generation assumptions

- `orders` and `order_item` are recreated in Project 04 as partitioned tables.
- Synthetic transaction rows are generated using Python `Faker`.
- Target date range is from `2025-08-01 00:00:00` to before `2025-11-01 00:00:00`.
- Each order has 3-4 line items.
- Products in each order item must belong to the same seller as the order.
- `unit_price` is based on current `product.discount_price` at generation time.

## Metric assumptions

- Potential catalog GMV is estimated as `discount_price * stock_qty`.
- Order revenue is computed from `SUM(order_item.subtotal)` at order level.
- Discount percentage is computed as `(1 - discount_price / price) * 100`.

## Environment assumptions

- PostgreSQL version supports:
  - table partitioning by range
  - plpgsql functions and procedures
  - window functions
  - `PERCENTILE_CONT`
  - `CREATE INDEX IF NOT EXISTS`
- Working schema is `public`.
- Local database credentials are loaded from `.env` in this folder first, then from the parent folder only as a fallback.

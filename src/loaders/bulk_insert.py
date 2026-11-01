from __future__ import annotations

from psycopg2.extras import execute_values


def insert_batch(cursor, orders_batch: list[tuple], order_items_batch: list[tuple]) -> None:
    execute_values(
        cursor,
        """
        INSERT INTO orders (order_id, customer_id, order_date, status, total_amount, created_at)
        VALUES %s
        """,
        orders_batch,
        page_size=10_000,
    )

    execute_values(
        cursor,
        """
        INSERT INTO order_item (order_id, product_id, order_date, quantity, unit_price, subtotal, created_at)
        VALUES %s
        """,
        order_items_batch,
        page_size=20_000,
    )

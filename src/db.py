from __future__ import annotations

from decimal import Decimal
from pathlib import Path
from typing import Any

from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine

from .config import DATABASE_URL


def get_engine() -> Engine:
    return create_engine(DATABASE_URL)


def ensure_directory(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def load_reference_data(engine: Engine) -> tuple[list[int], list[tuple[int, Decimal]]]:
    with engine.connect() as connection:
        customer_ids = [
            row[0] for row in connection.execute(text("SELECT customer_id FROM customer"))
        ]
        product_rows = connection.execute(
            text(
                """
                SELECT product_id, price
                FROM product
                WHERE price > 0
                  AND is_active IS TRUE
                ORDER BY product_id
                """
            )
        ).fetchall()

    if not customer_ids:
        raise ValueError("Project03 customer table is empty. Load Project03 reference data first.")

    if len(product_rows) < 5:
        raise ValueError(
            "Need at least 5 active products with price > 0 to sample 2-5 unique line items per order."
        )

    products = [(product_id, Decimal(price)) for product_id, price in product_rows]
    return customer_ids, products


def truncate_orders(raw_connection: Any) -> None:
    with raw_connection.cursor() as cursor:
        cursor.execute("TRUNCATE TABLE order_item, orders RESTART IDENTITY")
    raw_connection.commit()


def sync_orders_sequence(engine: Engine, max_order_id: int) -> None:
    with engine.begin() as connection:
        connection.execute(
            text(
                """
                SELECT setval(
                    pg_get_serial_sequence('orders', 'order_id'),
                    :max_id,
                    true
                )
                """
            ),
            {"max_id": max_order_id},
        )


def analyze_orders_tables(engine: Engine) -> None:
    with engine.begin() as connection:
        connection.execute(text("ANALYZE orders"))
        connection.execute(text("ANALYZE order_item"))

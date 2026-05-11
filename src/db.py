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


def load_reference_data(engine: Engine) -> tuple[list[int], dict[int, list[tuple[int, Decimal]]]]:
    with engine.connect() as connection:
        seller_ids = [row[0] for row in connection.execute(text("SELECT seller_id FROM seller"))]
        product_rows = connection.execute(
            text(
                """
                SELECT seller_id, product_id, discount_price
                FROM product
                WHERE discount_price IS NOT NULL
                  AND discount_price >= 0
                ORDER BY seller_id, product_id
                """
            )
        ).fetchall()

    if not seller_ids:
        raise ValueError("Project03 seller table is empty. Load Project03 reference data first.")

    seller_products: dict[int, list[tuple[int, Decimal]]] = {seller_id: [] for seller_id in seller_ids}
    for seller_id, product_id, discount_price in product_rows:
        seller_products[seller_id].append((product_id, Decimal(discount_price)))

    missing_sellers = [seller_id for seller_id, items in seller_products.items() if len(items) < 4]
    if missing_sellers:
        raise ValueError(
            "Each seller must have >= 4 products with non-negative discount_price "
            "because orders randomly contain 3-4 unique products. "
            f"Missing sellers: {missing_sellers[:10]}"
        )

    return seller_ids, seller_products


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

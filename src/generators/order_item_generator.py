from __future__ import annotations

import random
from datetime import UTC, datetime
from decimal import Decimal
from typing import Iterable

from faker import Faker

from ..config import ORDER_END, ORDER_START, STATUS_VALUES, STATUS_WEIGHTS

MONEY_QUANT = Decimal("0.01")


def random_datetime(fake: Faker) -> datetime:
    return fake.date_time_between_dates(datetime_start=ORDER_START, datetime_end=ORDER_END)


def chunk_sizes(total: int, size: int) -> Iterable[int]:
    full, remainder = divmod(total, size)
    for _ in range(full):
        yield size
    if remainder:
        yield remainder


def build_chunk(
    fake: Faker,
    start_order_id: int,
    chunk_count: int,
    seller_ids: list[int],
    seller_products: dict[int, list[tuple[int, Decimal]]],
) -> tuple[list[tuple], list[tuple]]:
    orders_batch: list[tuple] = []
    order_items_batch: list[tuple] = []

    for idx in range(chunk_count):
        order_id = start_order_id + idx
        order_date = random_datetime(fake)
        seller_id = random.choice(seller_ids)
        status = random.choices(STATUS_VALUES, weights=STATUS_WEIGHTS, k=1)[0]
        created_at = datetime.now(UTC).replace(tzinfo=None)

        items_count = random.randint(3, 4)
        product_pool = seller_products[seller_id]
        selected_products = random.sample(product_pool, k=items_count)

        order_total = Decimal("0.00")
        for product_id, unit_price in selected_products:
            quantity = random.randint(1, 3)
            subtotal = (Decimal(quantity) * unit_price).quantize(MONEY_QUANT)
            order_total += subtotal
            order_items_batch.append(
                (order_id, product_id, order_date, quantity, unit_price, subtotal, created_at)
            )

        orders_batch.append(
            (order_id, order_date, seller_id, status, order_total.quantize(MONEY_QUANT), created_at)
        )

    return orders_batch, order_items_batch

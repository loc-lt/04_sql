from __future__ import annotations

import argparse
import random

from faker import Faker

from sqlalchemy import text

from .config import DEFAULT_ORDER_COUNT, RANDOM_SEED
from .db import analyze_orders_tables, get_engine, load_reference_data, sync_orders_sequence, truncate_orders
from .generators.order_item_generator import build_chunk, chunk_sizes
from .loaders.bulk_insert import insert_batch


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate Project04 orders/order_item with Python Faker."
    )
    parser.add_argument(
        "--order-count",
        type=int,
        default=DEFAULT_ORDER_COUNT,
        help=f"Number of orders to generate (default {DEFAULT_ORDER_COUNT:,}).",
    )
    parser.add_argument(
        "--chunk-size",
        type=int,
        default=25_000,
        help="Orders per insert chunk.",
    )
    parser.add_argument(
        "--truncate-first",
        action="store_true",
        help="Truncate orders/order_item before loading.",
    )
    parser.add_argument(
        "--allow-small-run",
        action="store_true",
        help="Allow order_count below 5,000,000 for dry-run validation.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.order_count > DEFAULT_ORDER_COUNT:
        raise ValueError(f"order_count must be <= {DEFAULT_ORDER_COUNT:,}")
    if args.order_count < DEFAULT_ORDER_COUNT and not args.allow_small_run:
        raise ValueError(
            f"order_count must be {DEFAULT_ORDER_COUNT:,} for full submission. "
            "Use --allow-small-run for local dry-run."
        )
    if args.chunk_size < 1_000:
        raise ValueError("chunk_size must be >= 1,000")

    random.seed(RANDOM_SEED)
    fake = Faker("en_US")
    fake.seed_instance(RANDOM_SEED)

    engine = get_engine()
    customer_ids, products = load_reference_data(engine)
    raw_connection = engine.raw_connection()
    total_items_inserted = 0
    processed = 0
    order_rows = item_rows = avg_items = 0

    try:
        if args.truncate_first:
            truncate_orders(raw_connection)

        next_order_id = 1
        with raw_connection.cursor() as cursor:
            for size in chunk_sizes(args.order_count, args.chunk_size):
                orders_batch, order_items_batch = build_chunk(
                    fake=fake,
                    start_order_id=next_order_id,
                    chunk_count=size,
                    customer_ids=customer_ids,
                    products=products,
                )
                insert_batch(cursor, orders_batch, order_items_batch)
                raw_connection.commit()

                chunk_items = len(order_items_batch)
                total_items_inserted += chunk_items
                processed += size
                next_order_id += size
                print(
                    f"Inserted orders: {processed:,}/{args.order_count:,} | "
                    f"order_item (this chunk): {chunk_items:,} | "
                    f"order_item (cumulative): {total_items_inserted:,}"
                )

        sync_orders_sequence(engine, args.order_count)
        analyze_orders_tables(engine)

        with engine.connect() as connection:
            order_rows = connection.execute(text("SELECT COUNT(*) FROM orders")).scalar_one()
            item_rows = connection.execute(text("SELECT COUNT(*) FROM order_item")).scalar_one()
            avg_items = connection.execute(
                text(
                    """
                    SELECT ROUND(AVG(item_count)::numeric, 2)
                    FROM (
                        SELECT COUNT(*) AS item_count
                        FROM order_item
                        GROUP BY order_id, order_date
                    ) per_order
                    """
                )
            ).scalar_one()
    finally:
        raw_connection.close()
        engine.dispose()

    if processed == args.order_count and order_rows:
        print("Generation completed successfully.")
        print(
            f"Summary: orders={order_rows:,}, order_item={item_rows:,} "
            f"(avg {avg_items} line items per order)."
        )
    else:
        print("Generation finished with errors or incomplete run.")


if __name__ == "__main__":
    main()

from __future__ import annotations

import argparse
import random

from faker import Faker

from .config import RANDOM_SEED
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
        default=2_500_000,
        help="Number of orders to generate (required 2_500_000 to 3_000_000).",
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
        help="Allow order_count below 2,500,000 for dry-run validation.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.order_count > 3_000_000:
        raise ValueError("order_count must be <= 3,000,000")
    if args.order_count < 2_500_000 and not args.allow_small_run:
        raise ValueError(
            "order_count must be between 2,500,000 and 3,000,000. "
            "Use --allow-small-run for local dry-run."
        )
    if args.chunk_size < 1_000:
        raise ValueError("chunk_size must be >= 1,000")

    random.seed(RANDOM_SEED)
    fake = Faker("en_US")
    fake.seed_instance(RANDOM_SEED)

    engine = get_engine()
    seller_ids, seller_products = load_reference_data(engine)
    raw_connection = engine.raw_connection()

    try:
        if args.truncate_first:
            truncate_orders(raw_connection)

        next_order_id = 1
        processed = 0
        with raw_connection.cursor() as cursor:
            for size in chunk_sizes(args.order_count, args.chunk_size):
                orders_batch, order_items_batch = build_chunk(
                    fake=fake,
                    start_order_id=next_order_id,
                    chunk_count=size,
                    seller_ids=seller_ids,
                    seller_products=seller_products,
                )
                insert_batch(cursor, orders_batch, order_items_batch)
                raw_connection.commit()

                processed += size
                next_order_id += size
                print(
                    f"Inserted orders: {processed:,}/{args.order_count:,} "
                    f"({len(order_items_batch):,} items in latest chunk)"
                )

        sync_orders_sequence(engine, args.order_count)
        analyze_orders_tables(engine)
    finally:
        raw_connection.close()
        engine.dispose()

    print("Generation completed successfully.")


if __name__ == "__main__":
    main()

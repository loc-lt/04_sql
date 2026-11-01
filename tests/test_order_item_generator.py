from __future__ import annotations

import random
import unittest
from decimal import Decimal

from faker import Faker

from src.generators.order_item_generator import build_chunk, chunk_sizes


class OrderItemGeneratorTest(unittest.TestCase):
    def test_chunk_sizes_splits_remainder(self) -> None:
        self.assertEqual(list(chunk_sizes(10, 4)), [4, 4, 2])

    def test_build_chunk_preserves_order_invariants(self) -> None:
        random.seed(42)
        fake = Faker("en_US")
        fake.seed_instance(42)

        products = [
            (101, Decimal("10.00")),
            (102, Decimal("20.50")),
            (103, Decimal("30.99")),
            (104, Decimal("40.00")),
            (105, Decimal("50.00")),
        ]

        orders, order_items = build_chunk(
            fake=fake,
            start_order_id=1,
            chunk_count=25,
            customer_ids=[1, 2, 3],
            products=products,
        )

        self.assertEqual(len(orders), 25)
        self.assertGreaterEqual(len(order_items), 25 * 2)
        self.assertLessEqual(len(order_items), 25 * 5)

        for order in orders:
            order_id, customer_id, order_date, _status, total_amount, _created_at = order
            items = [item for item in order_items if item[0] == order_id]

            self.assertIn(customer_id, (1, 2, 3))
            self.assertEqual(len(items), len({item[1] for item in items}))
            self.assertGreaterEqual(len(items), 2)
            self.assertLessEqual(len(items), 5)
            self.assertTrue(all(item[2] == order_date for item in items))
            self.assertEqual(total_amount, sum(item[5] for item in items))


if __name__ == "__main__":
    unittest.main()

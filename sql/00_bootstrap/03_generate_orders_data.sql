-- Post-load sanity checks for Python Faker generation
-- Generation command:
-- poetry run python -m src.generate_transactions --truncate-first

SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'order_item', COUNT(*) FROM order_item
ORDER BY table_name;

SELECT
    MIN(order_date) AS min_order_date,
    MAX(order_date) AS max_order_date
FROM orders;

SELECT
    ROUND(AVG(item_count), 2) AS avg_items_per_order,
    MIN(item_count) AS min_items_per_order,
    MAX(item_count) AS max_items_per_order
FROM (
    SELECT order_id, order_date, COUNT(*) AS item_count
    FROM order_item
    GROUP BY order_id, order_date
) per_order;

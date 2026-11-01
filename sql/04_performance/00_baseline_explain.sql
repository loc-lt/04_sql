-- Run this BEFORE optimization indexes
-- Capture runtime + execution plan screenshots

EXPLAIN ANALYZE
SELECT DATE_TRUNC('month', order_date)::DATE AS month, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY 1
ORDER BY 1;

EXPLAIN ANALYZE
SELECT DISTINCT o.order_id, o.order_date, o.customer_id, o.total_amount
FROM orders o
WHERE o.order_date >= '2025-05-01'
  AND o.order_date < '2025-06-01'
  AND EXISTS (
      SELECT 1
      FROM order_item oi
      JOIN product p ON p.product_id = oi.product_id
      WHERE oi.order_id = o.order_id
        AND oi.order_date = o.order_date
        AND p.seller_id = 1
  );

EXPLAIN ANALYZE
SELECT *
FROM order_item
WHERE product_id = 10;

EXPLAIN ANALYZE
SELECT order_id, order_date, customer_id, total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 1;

EXPLAIN ANALYZE
SELECT
    oi.product_id,
    SUM(oi.quantity) AS quantity_sold
FROM order_item oi
GROUP BY oi.product_id
ORDER BY quantity_sold DESC
LIMIT 20;

EXPLAIN ANALYZE
SELECT
    p.seller_id,
    COUNT(DISTINCT (o.order_id, o.order_date)) AS order_count
FROM orders o
JOIN order_item oi
  ON oi.order_id = o.order_id
 AND oi.order_date = o.order_date
JOIN product p ON p.product_id = oi.product_id
WHERE o.order_date >= '2025-05-01'
  AND o.order_date < '2025-06-01'
GROUP BY p.seller_id
ORDER BY order_count DESC;

EXPLAIN ANALYZE
SELECT
    DATE_TRUNC('month', oi.order_date)::DATE AS month,
    oi.product_id,
    SUM(oi.subtotal) AS revenue
FROM order_item oi
GROUP BY 1, 2
ORDER BY month, revenue DESC;

EXPLAIN ANALYZE
SELECT
    p.seller_id,
    SUM(oi.quantity) AS products_sold
FROM order_item oi
JOIN product p ON p.product_id = oi.product_id
GROUP BY p.seller_id
ORDER BY products_sold DESC;

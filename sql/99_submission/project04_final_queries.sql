-- Project04 final query set (full requirement aligned)

-- 1) Total Revenue per Month
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY 1
ORDER BY 1;

-- 2) Orders that include products from seller 1 in May 2025
SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    o.status,
    o.total_amount
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
  )
ORDER BY o.order_date;

-- 3) Filter order_item by product_id
SELECT *
FROM order_item
WHERE product_id = 10;

-- 4) Find order with highest total_amount
SELECT
    order_id,
    order_date,
    customer_id,
    total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 1;

-- 5) List products with highest quantity sold
SELECT
    oi.product_id,
    p.product_name,
    SUM(oi.quantity) AS quantity_sold
FROM order_item oi
JOIN product p ON p.product_id = oi.product_id
GROUP BY oi.product_id, p.product_name
ORDER BY quantity_sold DESC
LIMIT 20;

-- 6) Distinct orders per seller in May 2025
SELECT
    p.seller_id,
    COUNT(DISTINCT (o.order_id, o.order_date)) AS order_count,
    ROUND(SUM(oi.subtotal), 2) AS revenue
FROM orders o
JOIN order_item oi
  ON oi.order_id = o.order_id
 AND oi.order_date = o.order_date
JOIN product p ON p.product_id = oi.product_id
WHERE o.order_date >= '2025-05-01'
  AND o.order_date < '2025-06-01'
GROUP BY p.seller_id
ORDER BY order_count DESC;

-- 7) Revenue per Product per Month
SELECT
    DATE_TRUNC('month', oi.order_date)::DATE AS month,
    oi.product_id,
    p.product_name,
    ROUND(SUM(oi.subtotal), 2) AS revenue
FROM order_item oi
JOIN product p ON p.product_id = oi.product_id
GROUP BY 1, oi.product_id, p.product_name
ORDER BY month, revenue DESC;

-- 8) Products Sold per Seller
SELECT
    p.seller_id,
    s.seller_name,
    SUM(oi.quantity) AS products_sold
FROM order_item oi
JOIN product p ON p.product_id = oi.product_id
JOIN seller s ON s.seller_id = p.seller_id
GROUP BY p.seller_id, s.seller_name
ORDER BY products_sold DESC;

-- 9) Monthly Revenue Report (function)
SELECT * FROM fn_monthly_revenue_report('2025-01-01', '2025-05-31', NULL);

-- 10) Daily Revenue Report (function)
SELECT * FROM fn_daily_revenue_report('2025-05-01', '2025-05-31', NULL);

-- 11) Seller Performance Report (function)
SELECT * FROM fn_seller_performance_report('2025-01-01', '2025-05-31');

-- 12) Top Products per Brand (function)
SELECT * FROM fn_top_products_per_brand_report('2025-01-01', '2025-05-31', 5);

-- 13) Order Status Summary (function)
SELECT * FROM fn_order_status_summary_report('2025-01-01', '2025-05-31', NULL);

-- Project04 final query set (full requirement aligned)

-- 1) Total Revenue per Month
SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY 1
ORDER BY 1;

-- 2) Orders filtered by seller and date
SELECT
    order_id,
    order_date,
    seller_id,
    status,
    total_amount
FROM orders
WHERE seller_id = 1
  AND order_date >= '2025-10-01'
  AND order_date < '2025-11-01'
ORDER BY order_date;

-- 3) Filter order_item by product_id
SELECT *
FROM order_item
WHERE product_id = 10;

-- 4) Find order with highest total_amount
SELECT
    order_id,
    order_date,
    seller_id,
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

-- 6) Orders by Seller in October
SELECT
    seller_id,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS revenue
FROM orders
WHERE order_date >= '2025-10-01'
  AND order_date < '2025-11-01'
GROUP BY seller_id
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
    o.seller_id,
    s.seller_name,
    SUM(oi.quantity) AS products_sold
FROM order_item oi
JOIN orders o
  ON o.order_id = oi.order_id
 AND o.order_date = oi.order_date
JOIN seller s ON s.seller_id = o.seller_id
GROUP BY o.seller_id, s.seller_name
ORDER BY products_sold DESC;

-- 9) Monthly Revenue Report (function)
SELECT * FROM fn_monthly_revenue_report('2025-08-01', '2025-10-31', NULL);

-- 10) Daily Revenue Report (function)
SELECT * FROM fn_daily_revenue_report('2025-10-01', '2025-10-31', NULL);

-- 11) Seller Performance Report (function)
SELECT * FROM fn_seller_performance_report('2025-08-01', '2025-10-31');

-- 12) Top Products per Brand (function)
SELECT * FROM fn_top_products_per_brand_report('2025-08-01', '2025-10-31', 5);

-- 13) Order Status Summary (function)
SELECT * FROM fn_order_status_summary_report('2025-08-01', '2025-10-31', NULL);

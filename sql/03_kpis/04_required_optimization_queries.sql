-- Required query set from Project04 optimization section

-- 1) Total revenue per month
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

-- 6) Orders by seller in October
SELECT
    seller_id,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS revenue
FROM orders
WHERE order_date >= '2025-10-01'
  AND order_date < '2025-11-01'
GROUP BY seller_id
ORDER BY order_count DESC;

-- 7) Revenue per product per month
SELECT
    DATE_TRUNC('month', oi.order_date)::DATE AS month,
    oi.product_id,
    p.product_name,
    ROUND(SUM(oi.subtotal), 2) AS revenue
FROM order_item oi
JOIN product p ON p.product_id = oi.product_id
GROUP BY 1, oi.product_id, p.product_name
ORDER BY month, revenue DESC;

-- 8) Products sold per seller
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

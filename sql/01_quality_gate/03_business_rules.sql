-- QG-03: business rule checks

-- Product price and rating
SELECT COUNT(*) AS invalid_product_price_rows
FROM product
WHERE price <= 0;

SELECT COUNT(*) AS invalid_product_rating_rows
FROM product
WHERE rating < 0
   OR rating > 5;

-- Seller rating range
SELECT COUNT(*) AS invalid_seller_rating_rows
FROM seller
WHERE rating < 0
   OR rating > 5;

-- Category hierarchy consistency
SELECT COUNT(*) AS invalid_category_hierarchy_rows
FROM category
WHERE (level = 1 AND parent_category_id IS NOT NULL)
   OR (level = 2 AND parent_category_id IS NULL);

-- Promotion date consistency
SELECT COUNT(*) AS invalid_promotion_date_rows
FROM promotion
WHERE end_date < start_date;

-- Order date range in requirement window (Jan 1 - May 31, 2025)
SELECT COUNT(*) AS invalid_order_date_range_rows
FROM orders
WHERE order_date < '2025-01-01'
   OR order_date >= '2025-06-01';

-- Each order should have 2-5 line items
SELECT COUNT(*) AS invalid_order_item_count_rows
FROM (
    SELECT order_id, order_date, COUNT(*) AS item_count
    FROM order_item
    GROUP BY order_id, order_date
    HAVING COUNT(*) NOT BETWEEN 2 AND 5
) bad_orders;

-- Subtotal and total amount consistency
SELECT COUNT(*) AS invalid_order_item_subtotal_rows
FROM order_item
WHERE subtotal <> ROUND(quantity * unit_price, 2);

SELECT COUNT(*) AS invalid_order_total_amount_rows
FROM (
    SELECT
        o.order_id,
        o.order_date,
        o.total_amount,
        ROUND(SUM(oi.subtotal), 2) AS computed_total
    FROM orders o
    JOIN order_item oi
      ON oi.order_id = o.order_id
     AND oi.order_date = o.order_date
    GROUP BY o.order_id, o.order_date, o.total_amount
    HAVING o.total_amount <> ROUND(SUM(oi.subtotal), 2)
) mismatched_orders;

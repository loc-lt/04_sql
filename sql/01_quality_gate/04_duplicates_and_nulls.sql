-- QG-04: duplicates and null checks

-- Duplicate promotion-product pairs
SELECT COUNT(*) AS duplicate_promotion_product_pairs
FROM (
    SELECT promotion_id, product_id, COUNT(*) AS pair_count
    FROM promotion_product
    GROUP BY promotion_id, product_id
    HAVING COUNT(*) > 1
) duplicates;

-- Nulls in mandatory product fields
SELECT COUNT(*) AS null_mandatory_product_rows
FROM product
WHERE product_name IS NULL
   OR category_id IS NULL
   OR brand_id IS NULL
   OR seller_id IS NULL
   OR price IS NULL
   OR stock_qty IS NULL
   OR rating IS NULL
   OR created_at IS NULL
   OR is_active IS NULL;

-- Nulls in mandatory order fields
SELECT COUNT(*) AS null_mandatory_order_rows
FROM orders
WHERE customer_id IS NULL
   OR order_date IS NULL
   OR status IS NULL
   OR total_amount IS NULL
   OR created_at IS NULL;

-- Nulls in mandatory order_item fields
SELECT COUNT(*) AS null_mandatory_order_item_rows
FROM order_item
WHERE order_id IS NULL
   OR product_id IS NULL
   OR order_date IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL
   OR subtotal IS NULL
   OR created_at IS NULL;

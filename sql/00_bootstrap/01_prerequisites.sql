-- Verify required Project03 tables exist

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
    'brand',
    'category',
    'seller',
    'product',
    'promotion',
    'promotion_product'
  )
ORDER BY table_name;

-- Quick sanity row sample counts
SELECT
    (SELECT COUNT(*) FROM brand) AS brand_rows,
    (SELECT COUNT(*) FROM category) AS category_rows,
    (SELECT COUNT(*) FROM seller) AS seller_rows,
    (SELECT COUNT(*) FROM product) AS product_rows,
    (SELECT COUNT(*) FROM promotion) AS promotion_rows,
    (SELECT COUNT(*) FROM promotion_product) AS promotion_product_rows;

-- Sellers must have enough valid products for 3-4 unique order items.
SELECT
    seller_id,
    COUNT(*) AS valid_product_count
FROM product
WHERE discount_price IS NOT NULL
  AND discount_price >= 0
GROUP BY seller_id
HAVING COUNT(*) < 4
ORDER BY valid_product_count, seller_id;

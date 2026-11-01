-- Verify required Project03 tables exist

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
    'brand',
    'category',
    'seller',
    'customer',
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
    (SELECT COUNT(*) FROM customer) AS customer_rows,
    (SELECT COUNT(*) FROM product) AS product_rows,
    (SELECT COUNT(*) FROM promotion) AS promotion_rows,
    (SELECT COUNT(*) FROM promotion_product) AS promotion_product_rows;

-- Catalog must have enough active products for 2-5 unique line items per order
SELECT COUNT(*) AS sellable_product_count
FROM product
WHERE price > 0
  AND is_active IS TRUE;

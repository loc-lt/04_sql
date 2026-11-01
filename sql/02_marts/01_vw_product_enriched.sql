CREATE OR REPLACE VIEW vw_product_enriched AS
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    c.category_name,
    c.level AS category_level,
    p.brand_id,
    b.brand_name,
    p.seller_id,
    s.seller_name,
    s.seller_type,
    p.price,
    p.stock_qty,
    p.rating AS product_rating,
    p.is_active,
    p.created_at,
    COALESCE(pp.promotion_count, 0) AS active_promotion_links
FROM product p
JOIN category c ON p.category_id = c.category_id
JOIN brand b ON p.brand_id = b.brand_id
JOIN seller s ON p.seller_id = s.seller_id
LEFT JOIN (
    SELECT product_id, COUNT(*) AS promotion_count
    FROM promotion_product
    GROUP BY product_id
) pp ON pp.product_id = p.product_id;

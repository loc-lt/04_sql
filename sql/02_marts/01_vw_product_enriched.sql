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
    p.discount_price,
    ROUND((1 - p.discount_price / NULLIF(p.price, 0)) * 100, 2) AS discount_pct,
    p.stock_qty,
    p.rating AS product_rating,
    p.is_active,
    p.created_at
FROM product p
JOIN category c ON p.category_id = c.category_id
JOIN brand b ON p.brand_id = b.brand_id
JOIN seller s ON p.seller_id = s.seller_id;

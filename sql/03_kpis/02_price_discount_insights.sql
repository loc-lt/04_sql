-- KPI-02: list price behavior by category

SELECT
    category_name,
    COUNT(*) AS product_count,
    MIN(price) AS min_price,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price)::numeric, 2) AS median_price,
    ROUND(AVG(price), 2) AS avg_price,
    MAX(price) AS max_price
FROM vw_product_enriched
GROUP BY category_name
ORDER BY avg_price DESC;

-- KPI-02b: top 10 products by list price
SELECT
    product_id,
    product_name,
    category_name,
    brand_name,
    seller_name,
    price,
    active_promotion_links
FROM vw_product_enriched
ORDER BY price DESC, product_id
LIMIT 10;

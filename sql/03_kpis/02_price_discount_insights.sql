-- KPI-02: price and discount behavior by category

SELECT
    category_name,
    COUNT(*) AS product_count,
    MIN(discount_price) AS min_discount_price,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY discount_price)::numeric, 2) AS median_discount_price,
    ROUND(AVG(discount_price), 2) AS avg_discount_price,
    MAX(discount_price) AS max_discount_price,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct
FROM vw_product_enriched
GROUP BY category_name
ORDER BY avg_discount_price DESC;

-- KPI-02b: top 10 products by effective discount percentage
SELECT
    product_id,
    product_name,
    category_name,
    brand_name,
    seller_name,
    price,
    discount_price,
    discount_pct
FROM vw_product_enriched
ORDER BY discount_pct DESC, price DESC
LIMIT 10;

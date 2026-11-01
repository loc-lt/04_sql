-- KPI-03: top sellers by potential catalog GMV

SELECT
    seller_id,
    seller_name,
    seller_type,
    COUNT(*) AS total_products,
    ROUND(SUM(price * stock_qty), 2) AS potential_catalog_gmv,
    ROUND(AVG(product_rating), 2) AS avg_product_rating
FROM vw_product_enriched
GROUP BY seller_id, seller_name, seller_type
ORDER BY potential_catalog_gmv DESC
LIMIT 15;

-- KPI-03b: promotion coverage and breadth
SELECT
    promotion_type,
    COUNT(*) AS promotion_count,
    SUM(linked_product_count) AS total_linked_products,
    ROUND(AVG(linked_product_count), 2) AS avg_products_per_promotion
FROM vw_promotion_coverage
GROUP BY promotion_type
ORDER BY total_linked_products DESC;

-- KPI-03c: categories with the largest promoted assortment
SELECT
    c.category_name,
    COUNT(DISTINCT p.product_id) AS promoted_product_count
FROM promotion_product pp
JOIN product p ON p.product_id = pp.product_id
JOIN category c ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY promoted_product_count DESC;

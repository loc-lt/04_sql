-- KPI-01: catalog activity and inventory health

WITH catalog AS (
    SELECT
        is_active,
        stock_qty,
        product_rating
    FROM vw_product_enriched
)
SELECT
    is_active,
    COUNT(*) AS product_count,
    ROUND(AVG(stock_qty), 2) AS avg_stock_qty,
    ROUND(AVG(product_rating), 2) AS avg_rating,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS product_share_pct
FROM catalog
GROUP BY is_active
ORDER BY is_active DESC;

-- KPI-01b: low-stock high-rating products (restock watchlist)
SELECT
    product_id,
    product_name,
    seller_name,
    category_name,
    stock_qty,
    product_rating
FROM vw_product_enriched
WHERE is_active = TRUE
  AND stock_qty <= 20
  AND product_rating >= 4.7
ORDER BY product_rating DESC, stock_qty ASC
LIMIT 30;

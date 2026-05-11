-- Dynamic report functions

CREATE OR REPLACE FUNCTION fn_monthly_revenue_report(
    p_start_date DATE,
    p_end_date DATE,
    p_seller_id INT DEFAULT NULL
)
RETURNS TABLE (
    month DATE,
    order_count BIGINT,
    total_revenue NUMERIC(18,2),
    total_quantity BIGINT
)
LANGUAGE sql
AS $$
    SELECT
        DATE_TRUNC('month', oi.order_date)::DATE AS month,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(oi.subtotal), 2) AS total_revenue,
        SUM(oi.quantity) AS total_quantity
    FROM orders o
    JOIN order_item oi
      ON oi.order_id = o.order_id
     AND oi.order_date = o.order_date
    WHERE o.order_date >= p_start_date
      AND o.order_date < (p_end_date + INTERVAL '1 day')
      AND (p_seller_id IS NULL OR o.seller_id = p_seller_id)
    GROUP BY 1
    ORDER BY 1;
$$;

CREATE OR REPLACE FUNCTION fn_daily_revenue_report(
    p_start_date DATE,
    p_end_date DATE,
    p_seller_id INT DEFAULT NULL
)
RETURNS TABLE (
    order_day DATE,
    order_count BIGINT,
    total_revenue NUMERIC(18,2),
    total_quantity BIGINT
)
LANGUAGE sql
AS $$
    SELECT
        oi.order_date::DATE AS order_day,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(oi.subtotal), 2) AS total_revenue,
        SUM(oi.quantity) AS total_quantity
    FROM orders o
    JOIN order_item oi
      ON oi.order_id = o.order_id
     AND oi.order_date = o.order_date
    WHERE o.order_date >= p_start_date
      AND o.order_date < (p_end_date + INTERVAL '1 day')
      AND (p_seller_id IS NULL OR o.seller_id = p_seller_id)
    GROUP BY 1
    ORDER BY 1;
$$;

CREATE OR REPLACE FUNCTION fn_seller_performance_report(
    p_start_date DATE,
    p_end_date DATE
)
RETURNS TABLE (
    seller_id INT,
    seller_name VARCHAR(150),
    order_count BIGINT,
    total_revenue NUMERIC(18,2),
    total_quantity BIGINT,
    avg_order_value NUMERIC(18,2)
)
LANGUAGE sql
AS $$
    SELECT
        o.seller_id,
        s.seller_name,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(oi.subtotal), 2) AS total_revenue,
        SUM(oi.quantity) AS total_quantity,
        ROUND(SUM(oi.subtotal) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS avg_order_value
    FROM orders o
    JOIN order_item oi
      ON oi.order_id = o.order_id
     AND oi.order_date = o.order_date
    JOIN seller s ON s.seller_id = o.seller_id
    WHERE o.order_date >= p_start_date
      AND o.order_date < (p_end_date + INTERVAL '1 day')
    GROUP BY o.seller_id, s.seller_name
    ORDER BY total_revenue DESC;
$$;

CREATE OR REPLACE FUNCTION fn_top_products_per_brand_report(
    p_start_date DATE,
    p_end_date DATE,
    p_top_n INT DEFAULT 5
)
RETURNS TABLE (
    brand_name VARCHAR(100),
    product_id INT,
    product_name VARCHAR(200),
    quantity_sold BIGINT,
    revenue NUMERIC(18,2),
    rank_in_brand BIGINT
)
LANGUAGE sql
AS $$
    WITH base AS (
        SELECT
            b.brand_name,
            p.product_id,
            p.product_name,
            SUM(oi.quantity) AS quantity_sold,
            ROUND(SUM(oi.subtotal), 2) AS revenue
        FROM order_item oi
        JOIN orders o
          ON o.order_id = oi.order_id
         AND o.order_date = oi.order_date
        JOIN product p ON p.product_id = oi.product_id
        JOIN brand b ON b.brand_id = p.brand_id
        WHERE o.order_date >= p_start_date
          AND o.order_date < (p_end_date + INTERVAL '1 day')
        GROUP BY b.brand_name, p.product_id, p.product_name
    ),
    ranked AS (
        SELECT
            base.*,
            ROW_NUMBER() OVER (PARTITION BY brand_name ORDER BY revenue DESC, quantity_sold DESC) AS rank_in_brand
        FROM base
    )
    SELECT
        brand_name,
        product_id,
        product_name,
        quantity_sold,
        revenue,
        rank_in_brand
    FROM ranked
    WHERE rank_in_brand <= p_top_n
    ORDER BY brand_name, rank_in_brand;
$$;

CREATE OR REPLACE FUNCTION fn_order_status_summary_report(
    p_start_date DATE,
    p_end_date DATE,
    p_seller_id INT DEFAULT NULL
)
RETURNS TABLE (
    status VARCHAR(20),
    order_count BIGINT,
    revenue NUMERIC(18,2),
    revenue_share_pct NUMERIC(10,2)
)
LANGUAGE sql
AS $$
    WITH status_base AS (
        SELECT
            o.status,
            COUNT(*) AS order_count,
            ROUND(SUM(o.total_amount), 2) AS revenue
        FROM orders o
        WHERE o.order_date >= p_start_date
          AND o.order_date < (p_end_date + INTERVAL '1 day')
          AND (p_seller_id IS NULL OR o.seller_id = p_seller_id)
        GROUP BY o.status
    )
    SELECT
        status,
        order_count,
        revenue,
        ROUND(revenue * 100.0 / NULLIF(SUM(revenue) OVER (), 0), 2) AS revenue_share_pct
    FROM status_base
    ORDER BY revenue DESC;
$$;

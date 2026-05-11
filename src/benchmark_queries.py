BENCHMARK_QUERIES = {
    "total_revenue_per_month": """
        SELECT DATE_TRUNC('month', order_date)::DATE AS month, SUM(total_amount) AS total_revenue
        FROM orders
        GROUP BY 1
        ORDER BY 1
    """,
    "orders_by_seller_and_date": """
        SELECT *
        FROM orders
        WHERE seller_id = 1
          AND order_date >= '2025-10-01'
          AND order_date < '2025-11-01'
    """,
    "order_item_by_product_id": """
        SELECT *
        FROM order_item
        WHERE product_id = 10
    """,
    "order_highest_total_amount": """
        SELECT order_id, order_date, seller_id, total_amount
        FROM orders
        ORDER BY total_amount DESC
        LIMIT 1
    """,
    "top_products_by_quantity_sold": """
        SELECT oi.product_id, SUM(oi.quantity) AS quantity_sold
        FROM order_item oi
        GROUP BY oi.product_id
        ORDER BY quantity_sold DESC
        LIMIT 20
    """,
    "orders_by_seller_in_october": """
        SELECT seller_id, COUNT(*) AS order_count
        FROM orders
        WHERE order_date >= '2025-10-01'
          AND order_date < '2025-11-01'
        GROUP BY seller_id
        ORDER BY order_count DESC
    """,
    "revenue_per_product_per_month": """
        SELECT DATE_TRUNC('month', oi.order_date)::DATE AS month, oi.product_id, SUM(oi.subtotal) AS revenue
        FROM order_item oi
        GROUP BY 1, 2
        ORDER BY month, revenue DESC
    """,
    "products_sold_per_seller": """
        SELECT o.seller_id, SUM(oi.quantity) AS products_sold
        FROM order_item oi
        JOIN orders o
          ON o.order_id = oi.order_id
         AND o.order_date = oi.order_date
        GROUP BY o.seller_id
        ORDER BY products_sold DESC
    """,
}

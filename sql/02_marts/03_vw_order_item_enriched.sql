CREATE OR REPLACE VIEW vw_order_item_enriched AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.order_date,
    o.status AS order_status,
    o.customer_id,
    cu.customer_name,
    oi.product_id,
    p.product_name,
    p.seller_id,
    s.seller_name,
    s.seller_type,
    p.brand_id,
    b.brand_name,
    p.category_id,
    c.category_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal,
    oi.created_at
FROM order_item oi
JOIN orders o
  ON o.order_id = oi.order_id
 AND o.order_date = oi.order_date
JOIN customer cu ON cu.customer_id = o.customer_id
JOIN product p ON p.product_id = oi.product_id
JOIN seller s ON s.seller_id = p.seller_id
JOIN brand b ON b.brand_id = p.brand_id
JOIN category c ON c.category_id = p.category_id;

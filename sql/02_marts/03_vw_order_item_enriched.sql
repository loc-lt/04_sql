CREATE OR REPLACE VIEW vw_order_item_enriched AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.order_date,
    o.status AS order_status,
    o.seller_id,
    s.seller_name,
    s.seller_type,
    oi.product_id,
    p.product_name,
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
JOIN seller s ON s.seller_id = o.seller_id
JOIN product p ON p.product_id = oi.product_id
JOIN brand b ON b.brand_id = p.brand_id
JOIN category c ON c.category_id = p.category_id;

-- QG-02: foreign key integrity checks

SELECT COUNT(*) AS invalid_product_fk_rows
FROM product p
LEFT JOIN brand b ON p.brand_id = b.brand_id
LEFT JOIN category c ON p.category_id = c.category_id
LEFT JOIN seller s ON p.seller_id = s.seller_id
WHERE b.brand_id IS NULL
   OR c.category_id IS NULL
   OR s.seller_id IS NULL;

SELECT COUNT(*) AS invalid_promotion_product_fk_rows
FROM promotion_product pp
LEFT JOIN promotion pr ON pp.promotion_id = pr.promotion_id
LEFT JOIN product p ON pp.product_id = p.product_id
WHERE pr.promotion_id IS NULL
   OR p.product_id IS NULL;

SELECT COUNT(*) AS invalid_order_fk_rows
FROM orders o
LEFT JOIN customer c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS invalid_order_item_fk_rows
FROM order_item oi
LEFT JOIN orders o
       ON o.order_id = oi.order_id
      AND o.order_date = oi.order_date
LEFT JOIN product p
       ON p.product_id = oi.product_id
WHERE o.order_id IS NULL
   OR p.product_id IS NULL;

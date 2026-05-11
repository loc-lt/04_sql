CREATE OR REPLACE VIEW vw_promotion_coverage AS
SELECT
    pr.promotion_id,
    pr.promotion_name,
    pr.promotion_type,
    pr.discount_type,
    pr.discount_value,
    pr.start_date,
    pr.end_date,
    COUNT(pp.product_id) AS linked_product_count
FROM promotion pr
LEFT JOIN promotion_product pp
       ON pp.promotion_id = pr.promotion_id
GROUP BY
    pr.promotion_id,
    pr.promotion_name,
    pr.promotion_type,
    pr.discount_type,
    pr.discount_value,
    pr.start_date,
    pr.end_date;

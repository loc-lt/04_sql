-- Indexes for full Project04 requirement

CREATE INDEX IF NOT EXISTS idx_product_category_id
    ON product (category_id);

CREATE INDEX IF NOT EXISTS idx_product_brand_id
    ON product (brand_id);

CREATE INDEX IF NOT EXISTS idx_product_seller_id
    ON product (seller_id);

CREATE INDEX IF NOT EXISTS idx_product_is_active
    ON product (is_active);

CREATE INDEX IF NOT EXISTS idx_product_created_at
    ON product (created_at);

CREATE INDEX IF NOT EXISTS idx_promotion_product_promotion_id
    ON promotion_product (promotion_id);

CREATE INDEX IF NOT EXISTS idx_promotion_product_product_id
    ON promotion_product (product_id);

CREATE INDEX IF NOT EXISTS idx_promotion_dates
    ON promotion (start_date, end_date);

CREATE INDEX IF NOT EXISTS idx_category_parent_category_id
    ON category (parent_category_id);

-- Transaction table indexes required by assignment
CREATE INDEX IF NOT EXISTS idx_orders_seller_order_date
    ON orders (seller_id, order_date);

CREATE INDEX IF NOT EXISTS idx_orders_total_amount
    ON orders (total_amount DESC);

CREATE INDEX IF NOT EXISTS idx_order_item_product_id
    ON order_item (product_id);

CREATE INDEX IF NOT EXISTS idx_order_item_order_id_date
    ON order_item (order_id, order_date);

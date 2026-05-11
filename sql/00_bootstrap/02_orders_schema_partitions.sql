-- Recreate transactional tables for Project04 full requirement
-- Using `orders` (instead of reserved word `order`)

DROP TABLE IF EXISTS order_item CASCADE;
DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE orders (
    order_id BIGSERIAL,
    order_date TIMESTAMP NOT NULL,
    seller_id INT NOT NULL REFERENCES seller(seller_id),
    status VARCHAR(20) NOT NULL CHECK (
        status IN ('PLACED', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED')
    ),
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (order_id, order_date)
) PARTITION BY RANGE (order_date);

CREATE TABLE orders_2025_08 PARTITION OF orders
FOR VALUES FROM ('2025-08-01') TO ('2025-09-01');

CREATE TABLE orders_2025_09 PARTITION OF orders
FOR VALUES FROM ('2025-09-01') TO ('2025-10-01');

CREATE TABLE orders_2025_10 PARTITION OF orders
FOR VALUES FROM ('2025-10-01') TO ('2025-11-01');

CREATE TABLE orders_default PARTITION OF orders DEFAULT;

CREATE TABLE order_item (
    order_item_id BIGSERIAL,
    order_id BIGINT NOT NULL,
    product_id INT NOT NULL REFERENCES product(product_id),
    order_date TIMESTAMP NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal NUMERIC(12,2) NOT NULL CHECK (subtotal >= 0),
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (order_item_id, order_date),
    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id, order_date)
        REFERENCES orders(order_id, order_date)
        ON DELETE CASCADE
) PARTITION BY RANGE (order_date);

CREATE TABLE order_item_2025_08 PARTITION OF order_item
FOR VALUES FROM ('2025-08-01') TO ('2025-09-01');

CREATE TABLE order_item_2025_09 PARTITION OF order_item
FOR VALUES FROM ('2025-09-01') TO ('2025-10-01');

CREATE TABLE order_item_2025_10 PARTITION OF order_item
FOR VALUES FROM ('2025-10-01') TO ('2025-11-01');

CREATE TABLE order_item_default PARTITION OF order_item DEFAULT;

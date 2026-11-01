# Data Dictionary (Project 04)

## `brand`

- `brand_id`: primary key.
- `brand_name`: brand label.
- `country`: brand origin country.
- `created_at`: creation timestamp.

## `category`

- `category_id`: primary key.
- `category_name`: category label.
- `parent_category_id`: self-reference for level 2 categories.
- `level`: hierarchy level (1 or 2).
- `created_at`: creation timestamp.

## `seller`

- `seller_id`: primary key.
- `seller_name`: seller display name.
- `join_date`: seller onboarding date.
- `seller_type`: `Official` or `Marketplace`.
- `rating`: seller score from 0 to 5.
- `country`: seller country.

## `customer`

- `customer_id`: primary key.
- `customer_name`: customer display name.
- `email`, `phone`: unique contact fields.
- `gender`, `address`, `city`: profile attributes.
- `created_at`: registration timestamp.

## `product`

- `product_id`: primary key.
- `product_name`: product title.
- `category_id`: foreign key to `category`.
- `brand_id`: foreign key to `brand`.
- `seller_id`: foreign key to `seller`.
- `price`: list price (used as `unit_price` when generating orders).
- `stock_qty`: available stock.
- `rating`: product score from 0 to 5.
- `created_at`: product creation timestamp.
- `is_active`: active listing flag.

## `orders`

- `order_id`: order identifier (partition key component).
- `customer_id`: foreign key to `customer`.
- `order_date`: order placement timestamp (partition key).
- `status`: order status.
- `total_amount`: sum of related line subtotals.
- `created_at`: record creation timestamp.

## `order_item`

- `order_item_id`: line item identifier.
- `order_id`: foreign key to `orders`.
- `product_id`: foreign key to `product`.
- `order_date`: copied from parent order (partition key).
- `quantity`: purchased quantity.
- `unit_price`: price per unit at purchase time.
- `subtotal`: `quantity * unit_price`.
- `created_at`: record creation timestamp.

## `promotion`

- `promotion_id`: primary key.
- `promotion_name`: promotion title.
- `promotion_type`: one of `product`, `category`, `seller`, `flash_sale`.
- `discount_type`: one of `percentage`, `fixed_amount`.
- `discount_value`: promotion value.
- `start_date`: start date.
- `end_date`: end date.

## `promotion_product`

- `promo_product_id`: primary key.
- `promotion_id`: foreign key to `promotion`.
- `product_id`: foreign key to `product`.
- `created_at`: mapping creation timestamp.

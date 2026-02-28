-- Parent Category
-- ===============================
INSERT INTO
    Categories (category_name)
VALUES ('Electronics'),
    ('Clothing'),
    ('Home & Kitchen'),
    ('Books'),
    ('Sports & Outdoors'),
    ('Beauty & Personal Care'),
    ('Toys & Games'),
    ('Groceries'),
    ('Automotive'),
    ('Health'),
    ('Office Supplies'),
    ('Pet Supplies');

-- Sub-categoies
-- ===============================

-- Electronics
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Mobile Phones', 1),
    ('Laptops', 1),
    ('Accessories', 1);

-- Clothing
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Men Clothing', 2),
    ('Women Clothing', 2),
    ('Kids Clothing', 2);

-- Home & Kitchen
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Furniture', 3),
    ('Cookware', 3),
    ('Home Decor', 3);

-- Books
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Fiction', 4),
    ('Non-Fiction', 4),
    ('Educational', 4);

-- Sports & Outdoors
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Gym Equipment', 5),
    ('Outdoor Gear', 5),
    ('Sportswear', 5);

-- Beauty & Personal Care
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Skincare', 6),
    ('Makeup', 6),
    ('Haircare', 6);

-- Toys & Games
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Board Games', 7),
    ('Action Figures', 7),
    ('Puzzles', 7);

-- Groceries
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Beverages', 8),
    ('Snacks', 8),
    ('Dairy', 8);

-- Automotive
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Car Accessories', 9),
    ('Motorbike Parts', 9),
    ('Oils & Fluids', 9);

-- Health
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Supplements', 10),
    ('Medical Devices', 10),
    ('Personal Hygiene', 10);

-- Office Supplies
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Stationery', 11),
    ('Office Furniture', 11),
    ('Electronics Accessories', 11);

-- Pet Supplies
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Pet Food', 12),
    ('Pet Toys', 12),
    ('Pet Grooming', 12);

-- Gererates 5000 realistic products
-- =====================================
TRUNCATE TABLE Products RESTART IDENTITY CASCADE;
INSERT INTO
    products (
        product_name,
        description,
        category_id,
        base_price,
        is_active
    )
SELECT 'Product ' || gs, 'Description for Product ' || gs, c.category_id, ROUND(
        (RANDOM() * 500 + 10)::numeric, 2
    ), (RANDOM() > 0.1)
FROM generate_series(1, 5000) gs
    JOIN (
        SELECT category_id, ROW_NUMBER() OVER () AS rn
        FROM categories
    ) c ON ((gs - 1) % 48) + 1 = c.rn;

-- Generate 3 variants per product
-- ====================================
INSERT INTO
    Product_Variants (
        product_id,
        variant_name,
        size,
        color,
        sku,
        price_override,
        stock_quantity
    )
SELECT p.product_id, 'Variant ' || gs, (
        ARRAY[
            'S', 'M', 'L', 'XL', 'Standard'
        ]
    ) [floor(random() * 5) + 1], (
        ARRAY[
            'Black', 'White', 'Blue', 'Red', 'Green'
        ]
    ) [floor(random() * 5) + 1], 'SKU-' || p.product_id || '-' || gs, NULL, (RANDOM() * 200)::INT
FROM Products p, generate_series(1, 3) gs;

-- adds 15% variants having price overrides

UPDATE Product_Variants pv
SET
    price_override = ROUND(
        (
            p.base_price + (RANDOM() * 50)
        )::numeric,
        2
    )
FROM Products p
WHERE
    pv.product_id = p.product_id
    AND RANDOM() < 0.15;

-- Generates 1000 customers
-- ===============================
INSERT INTO
    Customer (
        first_name,
        last_name,
        email,
        phone
    )
SELECT 'Customer' || gs, 'Last' || gs, 'customer' || gs || '@mail.com', '017' || LPAD((10000000 + gs)::text, 8, '0')
FROM generate_series(1, 1000) gs;

-- Generates 2 addresses per customer
-- =====================================
INSERT INTO
    Customer_Address (
        customer_id,
        address_line1,
        city,
        postal_code,
        country,
        address_type
    )
SELECT c.customer_id, 'Street ' || c.customer_id, (
        ARRAY[
            'Dhaka', 'Chittagong', 'Sylhet', 'Khulna'
        ]
    ) [floor(random() * 4) + 1], '1' || floor(random() * 9999), 'Bangladesh', (ARRAY['Shipping', 'Billing']) [floor(random() * 2) + 1]
FROM Customer c, generate_series(1, 2);

-- Generates Discounts
INSERT INTO
    Discounts (
        discount_code,
        discount_type,
        discount_value,
        start_date,
        end_date,
        is_active
    )
SELECT
    'DISC' || gs,
    (ARRAY['Percentage', 'Flat']) [floor(random() * 2) + 1],
    CASE
        WHEN (ARRAY['Percentage', 'Flat']) [floor(random() * 2) + 1] = 'Percentage' THEN ROUND(
            (RANDOM() * 25 + 5)::numeric,
            2
        ) -- 5% - 30%
        ELSE ROUND(
            (RANDOM() * 450 + 50)::numeric,
            2
        ) -- 50 - 500 flat
    END,
    CURRENT_DATE - (RANDOM() * 30)::INT, -- start_date in past 30 days
    CURRENT_DATE + (RANDOM() * 60)::INT, -- end_date in next 60 days
    (RANDOM() > 0.2) -- ~80% active
FROM generate_series(1, 50) gs;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- TRUNCATE dependent tables first
TRUNCATE TABLE Returns,
Payments,
Order_Items,
Orders RESTART IDENTITY CASCADE;

-- Generate exactly 1500 Orders
INSERT INTO
    Orders (
        customer_id,
        shipping_address_id,
        billing_address_id,
        discount_id,
        order_status,
        order_date
    )
SELECT
    c.customer_id,
    sa.address_id,
    ba.address_id,
    CASE
        WHEN RANDOM() < 0.3 THEN (
            SELECT discount_id
            FROM Discounts
            ORDER BY RANDOM()
            LIMIT 1
        )
        ELSE NULL
    END,
    (
        ARRAY[
            'Pending',
            'Completed',
            'Shipped',
            'Cancelled'
        ]
    ) [floor(RANDOM() * 4) + 1],
    CURRENT_TIMESTAMP - (
        (floor(RANDOM() * 30)) || ' days'
    )::interval
FROM
    generate_series(1, 1500) gs
    JOIN Customer c ON c.customer_id = ((gs - 1) % 1000 + 1)
    JOIN Customer_Address sa ON sa.customer_id = c.customer_id
    AND sa.address_type = 'Shipping'
    JOIN Customer_Address ba ON ba.customer_id = c.customer_id
    AND ba.address_type = 'Billing';
SELECT 'Categories' AS table_name, COUNT(*) AS row_count
FROM Categories
UNION ALL
SELECT 'Products', COUNT(*)
FROM Products
UNION ALL
SELECT 'Product_Variants', COUNT(*)
FROM Product_Variants
UNION ALL
SELECT 'Customer', COUNT(*)
FROM Customer
UNION ALL
SELECT 'Customer_Address', COUNT(*)
FROM Customer_Address
UNION ALL
SELECT 'Discounts', COUNT(*)
FROM Discounts
UNION ALL
SELECT 'Orders', COUNT(*)
FROM Orders
UNION ALL
SELECT 'Order_Items', COUNT(*)
FROM Order_Items
UNION ALL
SELECT 'Payments', COUNT(*)
FROM Payments
UNION ALL
SELECT 'Returns', COUNT(*)
FROM Returns;
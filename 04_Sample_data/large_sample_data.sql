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

SELECT COUNT(*) FROM Categories;

-- Generates 5000 Products

INSERT INTO
    Products (
        product_name,
        description,
        category_id,
        base_price,
        is_active
    )
SELECT 'Product ' || gs, 'Description for product ' || gs, ((gs - 1) % 48) + 1, ROUND(
        (RANDOM() * 500 + 10)::numeric, 2
    ), TRUE
FROM generate_series(1, 5000) gs;

SELECT COUNT(*) FROM Products;

-- Generates Product Variants (3 variants per product, 15000 total)

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
    ) [floor(RANDOM() * 5) + 1], (
        ARRAY[
            'Black', 'White', 'Blue', 'Red', 'Green'
        ]
    ) [floor(RANDOM() * 5) + 1], 'SKU-' || p.product_id || '-' || gs, NULL, floor(RANDOM() * 200)
FROM Products p
    CROSS JOIN generate_series(1, 3) gs;

SELECT COUNT(*) FROM Product_Variants;

-- GEnerates 1000 Customers

INSERT INTO
    Customer (
        first_name,
        last_name,
        email,
        phone
    )
SELECT 'Customer' || gs, 'Last' || gs, 'customer' || gs || '@mail.com', '017' || LPAD(gs::text, 8, '0')
FROM generate_series(1, 1000) gs;

SELECT COUNT(*) FROM customer

--Generates 200 Addresses(2 address per customer)

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
    ) [floor(RANDOM() * 4) + 1], floor(RANDOM() * 9999), 'Bangladesh', t.type
FROM Customer c
    CROSS JOIN (
        VALUES ('Shipping'), ('Billing')
    ) AS t (type);

SELECT COUNT(*) FROM Customer_Address;

-- Generates 50 Discounts

INSERT INTO
    Discounts (
        discount_code,
        discount_type,
        discount_value,
        start_date,
        end_date,
        is_active
    )
SELECT 'DISC' || gs, (ARRAY['Percentage', 'Flat']) [floor(RANDOM() * 2) + 1], ROUND(
        (RANDOM() * 30 + 5)::numeric, 2
    ), CURRENT_DATE - floor(RANDOM() * 30)::int, CURRENT_DATE + floor(RANDOM() * 60)::int, TRUE
FROM generate_series(1, 50) gs;

SELECT COUNT(*) FROM Discounts;

-- Generates 1500 Orders

INSERT INTO
    Orders (
        customer_id,
        shipping_address_id,
        billing_address_id,
        discount_id,
        order_status,
        order_date
    )
SELECT ((gs - 1) % 1000) + 1, ((gs - 1) % 1000) * 2 + 1, ((gs - 1) % 1000) * 2 + 2, NULL, (
        ARRAY[
            'Pending', 'Completed', 'Shipped', 'Cancelled'
        ]
    ) [floor(RANDOM() * 4) + 1], CURRENT_TIMESTAMP - (
        floor(RANDOM() * 30) || ' days'
    )::interval
FROM generate_series(1, 1500) gs;

SELECT COUNT(*) FROM Orders;

-- Generates 4500 Order Items (3 items per order)

INSERT INTO
    Order_Items (
        order_id,
        variant_id,
        quantity,
        unit_price,
        total_price
    )
SELECT o.order_id, ((o.order_id - 1) * 3 + gs), floor(RANDOM() * 5 + 1), p.base_price, p.base_price * floor(RANDOM() * 5 + 1)
FROM
    Orders o
    CROSS JOIN generate_series(1, 3) gs
    JOIN Product_Variants pv ON pv.variant_id = ((o.order_id - 1) * 3 + gs)
    JOIN Products p ON p.product_id = pv.product_id;

SELECT COUNT(*) FROM Order_Items;

-- Updated Order tatals

UPDATE Orders o
SET
    total_amount = sub.total
FROM (
        SELECT order_id, SUM(total_price) AS total
        FROM Order_Items
        GROUP BY
            order_id
    ) sub
WHERE
    o.order_id = sub.order_id;

-- Generates 1500 Payments

INSERT INTO
    Payments (
        order_id,
        amount,
        payment_method,
        payment_status,
        transaction_reference
    )
SELECT
    order_id,
    total_amount,
    (
        ARRAY[
            'Credit Card',
            'Bkash',
            'Cash on Delivery',
            'Paypal'
        ]
    ) [floor(RANDOM() * 4) + 1],
    (
        ARRAY[
            'Pending',
            'Completed',
            'Failed'
        ]
    ) [floor(RANDOM() * 3) + 1],
    'TXN-' || order_id
FROM Orders;

-- Generates Return (8%)

INSERT INTO
    Returns (
        order_item_id,
        return_reason,
        refund_amount,
        return_status
    )
SELECT order_item_id, (
        ARRAY[
            'Damaged product', 'Wrong item sent', 'Not satisfied'
        ]
    ) [floor(RANDOM() * 3) + 1], ROUND(
        (total_price * RANDOM())::numeric, 2
    ), (
        ARRAY[
            'Requested', 'Approved', 'Rejected'
        ]
    ) [floor(RANDOM() * 3) + 1]
FROM Order_Items
WHERE
    RANDOM() < 0.08;

-- Check
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

SELECT p.product_name, c.category_name, pv.variant_name
FROM
    products p
    JOIN categories c ON p.category_id = c.category_id
    LEFT JOIN product_variants pv ON p.product_id = pv.product_id
ORDER BY c.category_name, p.product_name;
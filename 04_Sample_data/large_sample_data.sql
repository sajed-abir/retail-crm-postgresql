-- Parent Category
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
-- Electronics
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Mobile Phones', 1),
    ('Laptops', 1),
    ('Accessories', 1),

-- Clothing
('Men Clothing', 2), ('Women Clothing', 2), ('Kids Clothing', 2),

-- Home & Kitchen
('Furniture', 3), ('Cookware', 3), ('Home Decor', 3),

-- Books
('Fiction', 4), ('Non-Fiction', 4), ('Educational', 4),

-- Sports
('Gym Equipment', 5), ('Outdoor Gear', 5), ('Sportswear', 5),

-- Beauty
('Skincare', 6), ('Makeup', 6), ('Haircare', 6),

-- Toys
('Board Games', 7), ('Action Figures', 7), ('Puzzles', 7),

-- Groceries
('Beverages', 8), ('Snacks', 8), ('Dairy', 8),

-- Automotive
('Car Accessories', 9), ('Motorbike Parts', 9), ('Oils & Fluids', 9),

-- Health
('Supplements', 10),
('Medical Devices', 10),
('Personal Hygiene', 10),

-- Office
('Stationery', 11),
('Office Furniture', 11),
('Electronics Accessories', 11),

-- Pet
('Pet Food', 12), ('Pet Toys', 12), ('Pet Grooming', 12);

-- Gererates 300 realistic products
INSERT INTO
    Products (
        category_id,
        product_name,
        description,
        base_price
    )
SELECT (RANDOM() * 35 + 13)::INT, 'Product ' || gs, 'Description for product ' || gs, (RANDOM() * 10000 + 200)::NUMERIC(10, 2)
FROM generate_series(1, 300) gs;

-- Generate 3 variants per product
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

-- Generates 1000 customers
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

SELECT * from customer_address;
INSERT INTO
    Categories (
        category_name,
        parent_category_id
    )
VALUES ('Men', NULL),
    ('Women', NULL),
    ('T-Shirts', 1),
    ('Jeans', 1),
    ('Dresses', 2);

INSERT INTO
    Customer (
        first_name,
        last_name,
        email,
        phone
    )
VALUES (
        'Sajed',
        'Rahman',
        'sajed@gmail.com',
        '01711111111'
    ),
    (
        'Nusrat',
        'Ahmed',
        'nusrat@gmail.com',
        '01822222222'
    ),
    (
        'Tanvir',
        'Hasan',
        'tanvir@gmail.com',
        '01933333333'
    );

INSERT INTO
    Customer_Address (
        customer_id,
        address_line1,
        city,
        postal_code,
        country,
        address_type
    )
VALUES (
        1,
        'House 10, Road 5',
        'Dhaka',
        '1207',
        'Bangladesh',
        'Shipping'
    ),
    (
        1,
        'House 10, Road 5',
        'Dhaka',
        '1207',
        'Bangladesh',
        'Billing'
    ),
    (
        2,
        'Flat 4B, Green Tower',
        'Chittagong',
        '4000',
        'Bangladesh',
        'Shipping'
    ),
    (
        3,
        'House 22, Lake View',
        'Sylhet',
        '3100',
        'Bangladesh',
        'Shipping'
    );

    INSERT INTO
    Products (
        category_id,
        product_name,
        description,
        base_price
    )
VALUES (
        3,
        'Basic Black T-Shirt',
        '100% cotton black t-shirt',
        800.00
    ),
    (
        4,
        'Slim Blue Jeans',
        'Stretch slim-fit jeans',
        2200.00
    ),
    (
        5,
        'Summer Floral Dress',
        'Lightweight summer dress',
        3000.00
    );

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
VALUES (
        1,
        'Black T-Shirt M',
        'M',
        'Black',
        'TS-BLK-M',
        NULL,
        50
    ),
    (
        1,
        'Black T-Shirt L',
        'L',
        'Black',
        'TS-BLK-L',
        NULL,
        40
    ),
    (
        2,
        'Blue Jeans 32',
        '32',
        'Blue',
        'JN-BLU-32',
        NULL,
        25
    ),
    (
        3,
        'Floral Dress S',
        'S',
        'Floral',
        'DR-FLR-S',
        2800.00,
        15
    );

INSERT INTO
    Discounts (
        discount_code,
        discount_type,
        discount_value,
        start_date,
        end_date
    )
VALUES (
        'NEW10',
        'PERCENTAGE',
        10,
        '2026-01-01',
        '2026-12-31'
    ),
    (
        'FLAT200',
        'FIXED',
        200,
        '2026-01-01',
        '2026-06-30'
    );

INSERT INTO
    Orders (
        customer_id,
        shipping_address_id,
        billing_address_id,
        discount_id,
        order_status,
        total_amount
    )
VALUES (
        1,
        1,
        2,
        1,
        'Completed',
        1440.00
    ),
    (
        2,
        3,
        3,
        NULL,
        'Pending',
        2200.00
    ),
    (
        3,
        4,
        4,
        2,
        'Shipped',
        2600.00
    );

INSERT INTO
    Order_Items (
        order_id,
        variant_id,
        quantity,
        unit_price,
        total_price
    )
VALUES (1, 1, 2, 800.00, 1600.00),
    (2, 3, 1, 2200.00, 2200.00),
    (3, 4, 1, 2800.00, 2800.00);

INSERT INTO
    Payments (
        order_id,
        amount,
        payment_method,
        payment_status
    )
VALUES (
        1,
        1440.00,
        'bKash',
        'Completed'
    ),
    (
        2,
        2200.00,
        'Credit Card',
        'Pending'
    ),
    (
        3,
        2600.00,
        'Nagad',
        'Completed'
    );

INSERT INTO
    Returns (
        order_item_id,
        return_reason,
        refund_amount,
        return_status
    )
VALUES (
        1,
        'Size issue',
        800.00,
        'Approved'
    );
SELECT * FROM returns
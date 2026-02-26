-- Active: 1771962167652@@127.0.0.1@5432@ecommerce_db
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE Customer_Address (
    address_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    address_type VARCHAR(50),
    CONSTRAINT fk_customer Foreign Key (customer_id) REFERENCES Customer (customer_id) ON DELETE CASCADE
);

CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    CONSTRAINT fk_parent_category Foreign Key (parent_category_id) REFERENCES Categories (category_id) ON DELETE SET NULL
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price NUMERIC(10, 2) NOT NULL CHECK (base_price >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES Categories (category_id) ON DELETE CASCADE
);

CREATE TABLE Product_Variants (
    variant_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    variant_name VARCHAR(255) NOT NULL,
    size VARCHAR(50),
    color VARCHAR(50),
    sku VARCHAR(50) UNIQUE NOT NULL,
    price_override NUMERIC(10, 2) CHECK (price_override >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_variant_product Foreign Key (product_id) REFERENCES Products (product_id) ON DELETE CASCADE
);

CREATE TABLE Discounts (
    discount_id SERIAL PRIMARY KEY,
    discount_code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(50),
    discount_value NUMERIC(10, 2) CHECK (discount_value >= 0),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    shipping_address_id INT,
    billing_address_id INT,
    discount_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(50) DEFAULT 'Pending',
    total_amount NUMERIC(10, 2) DEFAULT 0 CHECK (total_amount >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_customer Foreign Key (customer_id) REFERENCES Customer (customer_id) ON Delete CASCADE,
    CONSTRAINT fk_order_shipping_address Foreign Key (shipping_address_id) REFERENCES Customer_Address (address_id) ON DELETE Set NULL,
    CONSTRAINT fk_order_billing_addresss Foreign Key (billing_address_id) REFERENCES Customer_Address (address_id) on delete set NULL,
    CONSTRAINT fk_order_billing_address Foreign Key (Billing_address_id) REFERENCES Customer_Address (address_id) on delete set NULL,
    CONSTRAINT fk_order_discount Foreign Key (discount_id) REFERENCES Discounts (discount_id) On delete set NULL
);

CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    variant_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    total_price NUMERIC(10, 2) NOT NULL CHECK (total_price >= 0),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_variant FOREIGN KEY (variant_id) REFERENCES Product_Variants (variant_id) ON DELETE SET NULL
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(10, 2) not NULL check (amount >= 0),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'Pending',
    transaction_reference VARCHAR(100),
    CONSTRAINT fk_payment_order Foreign Key (order_id) REFERENCES Orders (order_id) on delete CASCADE
);

CREATE TABLE Returns (
    return_id SERIAL PRIMARY KEY,
    order_item_id INT NOT NULL,
    return_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_reason TEXT,
    refund_amount NUMERIC(10, 2) DEFAULT 0 CHECK (refund_amount >= 0),
    return_status VARCHAR(50) DEFAULT 'Requested',
    CONSTRAINT fk_return_orderitem FOREIGN KEY (order_item_id) REFERENCES Order_Items (order_item_id) ON DELETE CASCADE
);

ALTER TABLE Orders DROP CONSTRAINT fk_order_billing_addresss;
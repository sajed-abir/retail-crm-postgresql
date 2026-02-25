CREATE TABLE Customer (
    customer_id serial primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    email varchar(150) UNIQUE not null,
    phone varchar(20),
    created_at timestamp dafault CURRENT_TIMESTAMP,
    is_active boolean default TRUE
)
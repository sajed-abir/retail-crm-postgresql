-- 01. Total Customers
SELECT COUNT(DISTINCT customer_id) as total_customers
from customer

-- 02. Active Customers
SELECT COUNT(DISTINCT customer_id) as active_customers
from orders

-- 03. Repeat vs One-time Customers
SELECT
    CASE 
        WHEN order_count = 1 THEN 'One-time Customer' 
        ELSE 'Repeat Customer' 
    END as customer_type,
    COUNT(*) as total_cutomers
FROM(
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
GROUP BY customer_type;

-- 04. Top 10 Customers by Revenue
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.total_price) AS total_spent
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- 05. Average Customer Spend
SELECT AVG(customer_spent) AS avg_customer_spent
FROM(
    SELECT
        o.customer_id,
        SUM(oi.total_price) as customer_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY o.customer_id
    );

-- 06. Customer Lifetime Value
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.total_price) AS lifetime_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.customer_id
ORDER BY lifetime_value DESC;

-- 07. Customers by City
SELECT
    ca.city,
    COUNT(DISTINCT c.customer_id) AS customers
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
GROUP BY ca.city
ORDER BY customers DESC;

-- 08. New Customers Over Time
SELECT
   TO_CHAR(DATE_TRUNC('month', created_at), 'MM') AS month,
    COUNT(*) AS new_customers
FROM customer
GROUP BY month
ORDER BY month;

-- RMF
SELECT
    c.customer_id,
    MAX(o.order_date) AS last_purchase,
    COUNT(DISTINCT o.order_id) as frequency,
    sum(oi.total_price) as monetary
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id;
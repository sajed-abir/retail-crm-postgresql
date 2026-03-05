-- 01. Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 02. Monthly Order Trend
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- 03. Average Order value
SELECT ROUND(AVG(total_amount),2) AS average_order_value
FROM orders
WHERE order_status = 'Completed';

-- 04 Orders per Customer
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- 05. Orders by City
SELECT
    ca.city,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customer_address ca ON o.shipping_address_id = ca.address_id
GROUP BY ca.city
ORDER BY total_orders DESC;
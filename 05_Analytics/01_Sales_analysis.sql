-- 01. Total Revenue
SELECT SUM(oi.total_price) as total_revenue
from order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';

-- 02. Total Orders
SELECT count(*) as total_completed_orders
from orders
WHERE order_status = 'Completed';

-- 03. Average Order Value(AOV)
SELECT sum(oi.total_price) / count(DISTINCT o.order_id) AS avg_order_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';

-- 04. Monthly Revenue Trend
SELECT DATE_TRUNC('month', o.order_date) AS month, sum(oi.total_price) AS monthly_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY MONTH
ORDER BY MONTH

-- 05. Revenue by Categorty
SELECT
    c.category_name,
    SUM(oi.total_price) as category_revenue
from order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
JOIN categories c on p.category_id = c.category_id
WHERE o.order_status = 'Completed'
GROUP BY c.category_name
order by category_revenue DESC;

-- 06. Top 10 Products
SELECT
    p.product_name,
    sum(oi.total_price) as product_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name
ORDER BY product_revenue DESC
LIMIT 10;

-- 07. Variant-Level Performance
SELECT
    p.product_name,
    pv.variant_name,
    sum(oi.quantity) AS total_units_sold,
    sum(oi.total_price) AS variant_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name, pv.variant_name
ORDER BY variant_revenue DESC;

-- 08. Revenue Growth %
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.total_price) AS revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY month
)
SELECT
    month,
    revenue,
    lag(revenue) over(ORDER BY month) AS previous_month,
    round(
        ((revenue - LAG(revenue) OVER (ORDER BY month))
        / lag(revenue) OVER (ORDER BY month)) * 100, 2
    ) as growth_percentage
FROM monthly_revenue;
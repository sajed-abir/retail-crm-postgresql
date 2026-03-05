-- 01. Top Selling Products by Quantity
SELECT
    p.product_name,
    sum(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- 02. Top Products by Revenue
SELECT
    p.product_name,
    SUM(oi.total_price) AS total_revenue
FROM order_items oi
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 03. Top Selling Categories
SELECT
    c.category_name,
    SUM(oi.total_price) as total_revenue
from order_items oi
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- 04. Best Performing Variants
SELECT
    p.product_name,
    pv.variant_name,
    pv.color,
    pv.size,
    SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.product_name,
    pv.variant_name,
    pv.color,
    pv.size
ORDER BY total_sold DESC
LIMIT 10;

-- 05. Products with Highest Return Rate
SELECT
    p.product_name,
    COUNT(r.return_id) AS total_retuns
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_retuns DESC
LIMIT 10;

-- 06. Low Stock Products
SELECT
    p.product_name,
    pv.variant_name,
    pv.stock_quantity
FROM product_variants pv
JOIN products p ON pv.product_id = p.product_id
WHERE pv.stock_quantity < 20
ORDER BY pv.stock_quantity ASC;

-- 07. Average Product Price
SELECT
    c.category_name,
    avg(p.base_price) AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY avg_price DESC;


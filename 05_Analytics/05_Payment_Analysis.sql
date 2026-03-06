-- 01. Revenue by Payment Method
SELECT
    payment_method,
    round(sum(amount),2) as total_revenue
FROM payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 02. Payment Method Popularity
SELECT
    payment_method,
    COUNT(*) AS total_trasactions
FROM payments
GROUP BY payment_method
ORDER BY total_trasactions DESC;

-- 03. Payment Success vs Failure Rate
SELECT
    payment_status,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_status;

-- 04. Monthly Payment Revenue
SELECT
    TO_CHAR(payment_date, 'Month') AS month,
    round(sum(amount),2) AS monthly_revenue
FROM payments
WHERE payment_status = 'Completed'
GROUP BY month
ORDER BY month;

-- 05. Average Payment Value
SELECT round(avg(amount),2) as avg_payment_value
FROM payments
WHERE payment_status ='Completed';

-- 06. Payment Method Success Rate
SELECT
    payment_method,
    payment_status,
    count(*) AS transactions
FROM payments
GROUP BY payment_method, payment_status
ORDER BY payment_method
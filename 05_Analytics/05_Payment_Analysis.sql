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
    DATE_TRUC('month', payment_date) AS mothth,
    
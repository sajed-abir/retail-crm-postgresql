-- 01. Each customer's first order
WITH first_order AS(
    SELECT
        customer_id,
        TO_CHAR(min(order_date), 'Month') as cohort_month
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT * FROM first_order;

-- 02. Calculates when each order happened relatiove to the cohort
WITH first_order AS(
    SELECT
        customer_id,
        TO_CHAR(min(order_date), 'Month') as cohort_month
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
customer_orders AS(
    SELECT
        o.customer_id,
        TO_CHAR(o.order_date, 'Month') AS order_month,
        f.cohort_month
    FROM orders o
    JOIN first_order f ON o.customer_id = f.customer_id
    WHERE o.order_status = 'Completed'
)
SELECT * FROM customer_orders;

-- 03. Calculates months since first purchase
WITH
    first_order AS (
        SELECT customer_id, DATE_TRUNC('month', MIN(order_date)) AS cohort_month
        FROM orders
        WHERE
            order_status = 'Completed'
        GROUP BY
            customer_id
),
customer_orders AS (
    SELECT o.customer_id, DATE_TRUNC('month', o.order_date) AS order_month, f.cohort_month
    FROM orders o
        JOIN first_order f ON o.customer_id = f.customer_id
    WHERE
        o.order_status = 'Completed'
)
SELECT
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
    TO_CHAR(order_month, 'YYYY-MM') AS order_month,
    CASE 
        WHEN EXTRACT( MONTH FROM AGE (order_month, cohort_month)) = 0  THEN 'First Purchase' 
        ELSE  'After ' || EXTRACT( MONTH FROM AGE (order_month, cohort_month) ) || ' Month(s)'
    END as purchase_period,
    
    count(DISTINCT customer_id) as active_customers
FROM customer_orders
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;

-- 04. Chohort Retetion Rate
WITH
    first_order AS (
        SELECT customer_id, DATE_TRUNC('month', MIN(order_date)) AS cohort_month
        FROM orders
        WHERE
            order_status = 'Completed'
        GROUP BY
            customer_id
    ),
    customer_orders AS (
        SELECT o.customer_id, DATE_TRUNC('month', o.order_date) AS order_month, f.cohort_month
        FROM orders o
            JOIN first_order f ON o.customer_id = f.customer_id
        WHERE
            o.order_status = 'Completed'
    ),
    cohort_data AS (
        SELECT
            cohort_month,
            extract(MONTH FROM age(order_month, cohort_month)) as month_number,
            count(DISTINCT customer_id) AS customers
        FROM customer_orders
        GROUP BY cohort_month, month_number
    )
SELECT
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
    CASE
        WHEN month_number = 0 THEN 'First Purchase Month'
        WHEN month_number = 1 THEN '1 Month After First Purchase'
        WHEN month_number = 2 THEN '2 Months After First Purchase'
        WHEN month_number = 3 THEN '3 Months After First Purchase'
        ELSE month_number || ' Months After First Purchase'
    END AS purchase_period,
    customers,
    round(
        customers * 100.0 / 
        first_value(customers) OVER (PARTITION BY cohort_month ORDER BY month_number), 2
        ) AS retention_rate
FROM cohort_data
ORDER BY cohort_month, month_number
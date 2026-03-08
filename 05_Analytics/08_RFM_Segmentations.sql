-- R - Recency -> How recenty the customer purchased
-- F - Frequency -> How often the customer purchases
-- M - Monetary -> How much money the customer spends

-- 01. Calculates RFM metrics
WITH rfm_base AS (
    SELECT
        c.customer_id,
        MAX(o.order_date) AS last_purchase_date,
        CURRENT_DATE - MAX(o.order_date) :: date AS recency_days,
        COUNT(o.order_id) AS frequency,
        SUM(p.amount) AS monetary
    FROM customer c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN payments p ON o.order_id = p.order_id
    WHERE
        o.order_status = 'Completed' AND
        p.payment_status = 'Completed'
    GROUP BY c.customer_id
)
SELECT * FROM rfm_base;

-- 02. RFM schores
WITH
    rfm_base AS (
        SELECT
            c.customer_id,
            MAX(o.order_date) AS last_purchase_date,
            CURRENT_DATE - MAX(o.order_date)::date AS recency,
            COUNT(o.order_id) AS frequency,
            SUM(p.amount) AS monetary
        FROM
            customer c
            JOIN orders o ON c.customer_id = o.customer_id
            JOIN payments p ON o.order_id = p.order_id
        WHERE
            o.order_status = 'Completed'
            AND p.payment_status = 'Completed'
        GROUP BY
            c.customer_id
    ),
rfm_scores AS (
    SELECT
        customer_id,
        ntile(5) OVER (ORDER BY recency DESC) AS r_score,
        ntile(5) OVER ( ORDER BY frequency DESC ) AS f_score,
        ntile(5) OVER ( ORDER BY monetary DESC ) AS m_score

    FROM rfm_base
)
SELECT * FROM rfm_scores;

-- 03. Customer Segments
-- | Segment             | Meaning                           |
-- | ------------------- | --------------------------------- |
-- | Champions           | Best customers                    |
-- | Loyal               | Frequent buyers                   |
-- | Potential Loyalists | New customers with potential      |
-- | At Risk             | Used to buy but stopped           |
-- | Lost                | Haven't purchased for a long time |
WITH
    rfm_base AS (
        SELECT
            c.customer_id,
            MAX(o.order_date) AS last_purchase_date,
            CURRENT_DATE - MAX(o.order_date)::date AS recency,
            COUNT(o.order_id) AS frequency,
            SUM(p.amount) AS monetary
        FROM
            customer c
            JOIN orders o ON c.customer_id = o.customer_id
            JOIN payments p ON o.order_id = p.order_id
        WHERE
            o.order_status = 'Completed'
            AND p.payment_status = 'Completed'
        GROUP BY
            c.customer_id
    ),
    rfm_scores AS (
        SELECT
            customer_id,
            ntile(5) OVER (
                ORDER BY recency DESC
            ) AS r_score,
            ntile(5) OVER (
                ORDER BY frequency DESC
            ) AS f_score,
            ntile(5) OVER (
                ORDER BY monetary DESC
            ) AS m_score
        FROM rfm_base
    )
SELECT
    customer_id,
    r_score,
    f_score,
    m_score,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 2 AND f_score >= 2 THEN 'Potential Loyalists'
        WHEN r_score >= 2 AND f_score >= 3 THEN 'At Risk'
        ELSE 'Lost Customers' 
    END AS customer_segment
FROM rfm_scores;
-- 01. Total Return and Refund Amount
SELECT
    COUNT(*) AS total_returns,
    round(sum(refund_amount), 2) AS total_refund_amount
FROM returns;

-- 02. Retun rate
SELECT
    round(
        count(r.return_id) * 100 / count(oi.order_item_id),2
    ) AS return_rate_percent
FROM order_items oi
LEFT JOIN returns r ON oi.order_item_id = r.order_item_id;

-- 03. Most returned product
SELECT
    p.product_name,
    pv.variant_name,
    COUNT(r.return_id) AS total_returns
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
GROUP BY p.product_name, pv.variant_name
ORDER BY total_returns DESC
LIMIT 10;

-- 04. Common return resons
SELECT
    return_reason,
    count(*) as total_returns
FROM returns
GROUP BY return_reason
ORDER BY total_returns DESC;

-- 05. Refund amount by products
SELECT
    p.product_name,
    round(sum(r.refund_amount),2) as total_refund
FROM returns r
JOIN order_items oi on r.order_item_id = oi.order_item_id
JOIN product_variants pv ON oi.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
GROUP BY p.product_name
order BY total_refund DESC
limit 5;

-- 06. Monthly return trend
SELECT
    TO_CHAR(return_date, 'Month') AS month,
    count(*) AS returns
FROM returns
GROUP BY month
ORDER BY month;


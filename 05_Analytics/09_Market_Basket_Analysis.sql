-- Finds products that are frequently bought together

SELECT
    p1.product_name as product_1,
    p2.product_name as product_2,
    count(*) as times_bought_together
FROM order_items oi1

JOIN order_items oi2 ON oi1.order_id = oi2.order_id
    AND oi1.variant_id < oi2.variant_id
JOIN product_variants pv1 ON oi1.variant_id = pv1.variant_id
JOIN product_variants pv2 ON oi2.variant_id = pv2.variant_id
JOIN products p1 ON pv1.product_id = p1.product_id
JOIN products p2 ON pv2.product_id = p2.product_id

GROUP BY p1.product_name, p2.product_name
ORDER BY times_bought_together DESC
LIMIT 10;
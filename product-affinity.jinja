INSERT OVERWRITE TABLE product_affinity
SELECT 
    s1.product_name as product1,
    s2.product_name as product2,
    COUNT(DISTINCT CASE WHEN s1.customer_id = s2.customer_id 
                       AND s1.sale_date = s2.sale_date 
                       AND s1.product_name < s2.product_name 
                  THEN CONCAT(s1.sale_id, '-', s2.sale_id) END) as bought_together_count,
    (SELECT COUNT(DISTINCT s3.customer_id) 
     FROM raw.sales_raw s3 
     WHERE s3.product_name = s1.product_name) as product1_buyers,
    (SELECT COUNT(DISTINCT s4.customer_id) 
     FROM raw.sales_raw s4 
     WHERE s4.product_name = s2.product_name) as product2_buyers,
    ROUND(
        COUNT(DISTINCT CASE WHEN s1.customer_id = s2.customer_id 
                           AND s1.sale_date = s2.sale_date 
                           AND s1.product_name < s2.product_name 
                      THEN s1.customer_id END) * 100.0 / 
        LEAST(
            (SELECT COUNT(DISTINCT s5.customer_id) FROM raw.sales_raw s5 WHERE s5.product_name = s1.product_name),
            (SELECT COUNT(DISTINCT s6.customer_id) FROM raw.sales_raw s6 WHERE s6.product_name = s2.product_name)
        ),
        2
    ) as affinity_score,
    (SELECT p1.category FROM raw.products_raw p1 WHERE p1.name = s1.product_name) as category1,
    (SELECT p2.category FROM raw.products_raw p2 WHERE p2.name = s2.product_name) as category2
FROM raw.sales_raw s1
CROSS JOIN raw.sales_raw s2
WHERE s1.product_name < s2.product_name
GROUP BY s1.product_name, s2.product_name
HAVING COUNT(DISTINCT CASE WHEN s1.customer_id = s2.customer_id 
                          AND s1.sale_date = s2.sale_date 
                     THEN CONCAT(s1.sale_id, '-', s2.sale_id) END) > 1
ORDER BY bought_together_count DESC;

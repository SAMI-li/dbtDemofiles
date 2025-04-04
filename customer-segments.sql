INSERT OVERWRITE TABLE customer_segments
SELECT 
    c.customer_id,
    c.name,
    (SELECT SUM(s1.quantity * s1.price) FROM raw.sales_raw s1 WHERE s1.customer_id = c.customer_id) as lifetime_value,
    CASE 
        WHEN (SELECT SUM(s2.quantity * s2.price) FROM raw.sales_raw s2 WHERE s2.customer_id = c.customer_id) > 10000 THEN 'VIP'
        WHEN (SELECT SUM(s3.quantity * s3.price) FROM raw.sales_raw s3 WHERE s3.customer_id = c.customer_id) > 5000 THEN 'Premium'
        WHEN (SELECT SUM(s4.quantity * s4.price) FROM raw.sales_raw s4 WHERE s4.customer_id = c.customer_id) > 1000 THEN 'Regular'
        ELSE 'Basic'
    END as customer_tier,
    (SELECT COUNT(DISTINCT EXTRACT(MONTH FROM s5.sale_date)) 
     FROM raw.sales_raw s5 
     WHERE s5.customer_id = c.customer_id) as active_months,
    (SELECT LISTAGG(DISTINCT p.category, ', ') 
     FROM raw.sales_raw s6 
     JOIN raw.products_raw p ON s6.product_name = p.name 
     WHERE s6.customer_id = c.customer_id) as preferred_categories,
    (SELECT AVG(s8.quantity) FROM raw.sales_raw s8 WHERE s8.customer_id = c.customer_id) as avg_basket_size
FROM raw.customers_raw c
WHERE EXISTS (SELECT 1 FROM raw.sales_raw s WHERE s.customer_id = c.customer_id);

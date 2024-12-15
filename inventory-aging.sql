INSERT OVERWRITE TABLE inventory_aging
SELECT 
    p.product_id,
    p.name,
    p.category AS product_category, 
    (SELECT MAX(s1.sale_date) 
     FROM raw.sales_raw s1 
     WHERE s1.product_name = p.name) AS last_sale_date,
    (SELECT SUM(s3.quantity) 
     FROM raw.sales_raw s3  
     WHERE s3.product_name = p.name) AS total_sales,
    (SELECT AVG(s4.quantity) 
     FROM raw.sales_raw s4 
     WHERE s4.product_name = p.name) AS avg_sales,
    (SELECT COUNT(DISTINCT s8.customer_id) 
     FROM raw.sales_raw s8 
     WHERE s8.product_name = p.name) AS total_unique_customers
FROM raw.products_raw p;

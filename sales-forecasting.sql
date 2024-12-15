INSERT OVERWRITE TABLE sales_forecast_prep
SELECT 
    EXTRACT(year FROM s.sale_date) as sales_year,
    EXTRACT(month FROM s.sale_date) as sales_month,
    p.category,
    SUM(s.quantity * s.price) as revenue,
    LAG(SUM(s.quantity * s.price), 1) OVER (
        PARTITION BY p.category, EXTRACT(month FROM s.sale_date) 
        ORDER BY EXTRACT(year FROM s.sale_date)
    ) as prev_year_revenue,
    LAG(SUM(s.quantity * s.price), 12) OVER (
        PARTITION BY p.category 
        ORDER BY EXTRACT(year FROM s.sale_date), EXTRACT(month FROM s.sale_date)
    ) as last_year_same_month,
    SUM(s.quantity) as units_sold,
    COUNT(DISTINCT s.customer_id) as unique_customers,
    (SELECT AVG(s2.price) 
     FROM raw.sales_raw s2 
     WHERE s2.product_name IN (SELECT name FROM raw.products_raw WHERE category = p.category)
     AND EXTRACT(year FROM s2.sale_date) = EXTRACT(year FROM s.sale_date)
     AND EXTRACT(month FROM s2.sale_date) = EXTRACT(month FROM s.sale_date)
    ) as avg_price
FROM raw.sales_raw s
JOIN raw.products_raw p ON s.product_name = p.name
GROUP BY 
    EXTRACT(year FROM s.sale_date),
    EXTRACT(month FROM s.sale_date),
    p.category
ORDER BY 
    p.category,
    sales_year,
    sales_month;

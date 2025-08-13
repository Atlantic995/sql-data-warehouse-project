-- checking the Foreign Key Integrity

SELECT * FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dimention_products AS p
ON f.product_key = p.product_key
WHERE c.customer_key IS NULL

SELECT * FROM gold.fact_sales
SELECT * FROM gold.dim_customers
SELECT * FROM gold.dimention_products
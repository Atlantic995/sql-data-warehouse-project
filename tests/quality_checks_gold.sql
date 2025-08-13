/*
##################################################################
Quality Checks Gold level
##################################################################
Script Purpose:
  This script performs quality checks to validate the integrity, consistency,
  and accuracy of the gold layer. These checks ensure:
    - Uniqueness of the surrogate key in dimension tables.
    - Referential integrity between the fact and dimension tables.
    - Validation of relationship in the data model for analytical purposes.

Usage Notes:
    - Run these checks after loading data to Silver layer.
    - Invensitage and resolve any discrepancies found during the checks.
##################################################################
*/


-- ##################################################################
-- Checking gold.dim_customers
-- ##################################################################
-- Checking the uniqueness of Customer_Key in gold.dim_customers
-- Expectation: No results

SELECT 
prd_key,
COUNT(*)
FROM 
(
	SELECT 
		pn.prd_id,
		pn.cat_id,
		pn.prd_key,
		pn.prd_nm,
		pn.prd_cost,
		pn.prd_line,
		pn.prd_start_dt,
		pc.cat,
		pc.subcat,
		pc.maintenance
	FROM silver.crm_prd_info AS pn
	LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pn.prd_key = pc.id
	WHERE prd_end_dt IS NULL
)t
GROUP BY prd_key
HAVING COUNT(*) > 1 


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


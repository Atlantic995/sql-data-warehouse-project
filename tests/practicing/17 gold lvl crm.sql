-- lets check the uniqueness of the data
-- no duplicates found
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


CREATE VIEW gold.dimention_products AS 
SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, 
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pa.cat AS category,
	pa.subcat AS sub_category,
	pa.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date

FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pa
ON pn.cat_id = pa.id
WHERE prd_end_dt IS NULL

SELECT * FROM gold.dimention_products
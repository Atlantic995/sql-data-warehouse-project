-- joining all customer tables into one
-- joining tables this way might result in duplicates 

SELECT cst_id, COUNT(*) FROM (
	SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		loc.cntry
	FROM silver.crm_cust_info AS ci
	LEFT JOIN silver.erp_cust_az12 AS ca
	ON		  ci.cst_key= ca.cid
	LEFT JOIN silver.erp_loc_a101 AS loc
	ON		  ci.cst_key = loc.cid
)t GROUP BY cst_id
HAVING COUNT(*) >1 

/* the check shows no duplicates created after join operation */

CREATE VIEW gold.dim_customers AS 
	SELECT
		ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		loc.cntry AS country,
		ci.cst_marital_status AS marital_status,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
			ELSE COALESCE(ca.gen, 'n/a')
		END AS gender,
		ca.bdate AS birthdate,
		ci.cst_create_date AS create_date

	FROM silver.crm_cust_info AS ci
	LEFT JOIN silver.erp_cust_az12 AS ca
	ON		  ci.cst_key= ca.cid
	LEFT JOIN silver.erp_loc_a101 AS loc
	ON		  ci.cst_key = loc.cid
	

/* Data integration for ca.gen and ci.cst_gndr */
/* The master table is silver.crm, so any inconsistencies will be finex using the crm table data*/

	SELECT DISTINCT
		ci.cst_gndr,
		ca.gen,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
		END new_gen
	FROM silver.crm_cust_info AS ci
	LEFT JOIN silver.erp_cust_az12 AS ca
	ON		  ci.cst_key= ca.cid
	LEFT JOIN silver.erp_loc_a101 AS loc
	ON		  ci.cst_key = loc.cid
ORDER BY 1,2


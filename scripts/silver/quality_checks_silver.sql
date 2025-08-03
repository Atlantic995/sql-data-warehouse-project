/*
###########################################
Quality Checks
###########################################
Script Purpise:
	This script performs various quality checks for data consistency, accuracy,
		and standadization across 'silver' schema. It includes checks for:
	- Null or duplicate primary keys
	- Unwanted spaces in String type fields
	- Data standardization and consisntency
	- Invalid Data ranges and orders
	- Data consistency between related fields.

Usage Notice:
	- use checks after loading Silver layer.
	- investigate and resolve any discrepancies found during the checks
###########################################

*/



-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL

--Check for inwanted Spaces
--Expectation: Not results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


-- replacing 'F' and 'M' with 'Female' and 'Male' for better readability
-- and for better consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info


SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT *
FROM silver.crm_cust_info
-- ################################################################
--Check if there are any duplicates or null in the PK

SELECT
prd_id
FROM [DataWarehouse].[bronze].[crm_prd_info]
WHERE prd_id IS NULL


-- Checking for duplicates
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Checking for unwanted spaces
-- Expectation: No result
SELECT
prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- checking if the product cost contains negative numbers or nulls 
SELECT
prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- checking  
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- checking for invalid date orders
SELECT * FROM
bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt 

-- prd_end_dt data is wrong, the product starts in 2011 but ends in 2007
SELECT 
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')


-- checking the data quality for SILVER layer

SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- Checking for unwanted spaces
-- Expectation: No result
SELECT
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- checking if the product cost contains negative numbers or nulls 
SELECT
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- checking  
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- checking for invalid date orders
SELECT * FROM
silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt 


SELECT * FROM
silver.crm_prd_info
-- ##################################################################

  -- checking if sls_ord_num has any unwanted spaces or nulls
  
  SELECT [sls_ord_num] FROM  [DataWarehouse].[bronze].[crm_sales_details] 
  WHERE  [sls_ord_num] != TRIM([sls_ord_num]) OR  [sls_ord_num] IS NULL


  -- the sls_prd_key and sls_cust_id are connected to the crm_cust_info, we need to check if there are any issues with this data

SELECT sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price
  FROM bronze.crm_sales_details
  WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

  SELECT * FROM silver.crm_prd_info


  -- the columns  ,sls_order_dt ,sls_ship_dt ,sls_due_dt are not DATES but INT, we need to format them for better readability
  -- not only that they are int, there are lots of gaps where data is set as 0
  -- the formatting is wrong in some cells, the data len should be equal to 8, some data shows different len
SELECT 
      NULLIF(sls_order_dt,0) sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8

-- we can check the boundaries too
SELECT 
      NULLIF(sls_order_dt,0) sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt < 19000101 OR sls_order_dt > 20260101


-- checking the next column, sls_ship_dt, if it has nulls, weird data length
SELECT 
      NULLIF(sls_order_dt,0) sls_order_dt,
      NULLIF(sls_ship_dt,0) sls_ship_dt,
      sls_due_dt
FROM bronze.crm_sales_details
WHERE 
sls_ship_dt <= 0 
OR LEN(sls_ship_dt) != 8 
OR sls_ship_dt < 19000101 
OR sls_ship_dt > 20260101


-- checking the sls_due_dt column, if it has weird data

SELECT 
      NULLIF(sls_order_dt,0) sls_order_dt,
      NULLIF(sls_ship_dt,0) sls_ship_dt,
      NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE 
sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8 
OR sls_due_dt < 19000101 
OR sls_due_dt > 20260101


-- Checking for invalid dates
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt


-- checking data consistency between sales, quantity, price
-- Sales = Quantity * price
-- no nulls, zeroes, or negatives

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity AS old_sls_quantity,
sls_price AS old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0 
        THEN sls_sales/NULLIF(sls_quantity, 0)
    ELSE sls_price
END AS sls_price


FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_price <= 0
OR sls_quantity <= 0
OR sls_price  <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Checking the health of the silver table
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_price <= 0
OR sls_quantity <= 0
OR sls_price  <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- final look 
SELECT * FROM silver.crm_sales_details
-- ###########################################################
-- cid from bronze.erp_cust_az12 should be identical with cst_key from silver.crm_cust_info
-- but there is a 'NAS' before the cid code, using substring to make it clear
-- after removing NAS with substring we can link erp_cust_az12 with silver.crm_cust_info

SELECT
cid,
CASE WHEN cid LIKE 'NAS%' THEN (SUBSTRING(cid, 4, LEN(cid)))
	ELSE cid
END cid2,
bdate,
CASE WHEN bdate > GETDATE() THEN NULL 
	ELSE bdate
END bdate,
gen
FROM bronze.erp_cust_az12

-- we need to check bdate if its a data type
-- also if its out of date


SELECT
CASE WHEN cid LIKE 'NAS%' THEN (SUBSTRING(cid, 4, LEN(cid)))
	ELSE cid
END cid2,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE bdate < '1925-01-01' or bdate > GETDATE()

-- checking all distinct gender 

SELECT DISTINCT 
gen
FROM bronze.erp_cust_az12

-- checking silver

SELECT
CASE WHEN cid LIKE 'NAS%' THEN (SUBSTRING(cid, 4, LEN(cid)))
	ELSE cid
END cid2,
bdate,
gen
FROM silver.erp_cust_az12
WHERE bdate < '1925-01-01' or bdate > GETDATE()


SELECT DISTINCT 
gen
FROM silver.erp_cust_az12
-- ####################################################
INSERT INTO silver.erp_px_cat_g1v2 (
      id,
      cat,
      subcat,
      maintenance
)

SELECT 
      id,
      cat,
      subcat,
      maintenance
  FROM bronze.erp_px_cat_g1v2;


SELECT * FROM silver.crm_prd_info;


SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2;

-- checking cat for unwanted spaces
SELECT 
*
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat) != cat OR TRIM(subcat) != subcat OR TRIM(maintenance) != maintenance


SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2;

-- no cleaning needed

SELECT 
      id,
      cat,
      subcat,
      maintenance
  FROM silver.erp_px_cat_g1v2;
--################################################

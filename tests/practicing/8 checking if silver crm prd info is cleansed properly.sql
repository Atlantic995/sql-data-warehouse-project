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
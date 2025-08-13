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
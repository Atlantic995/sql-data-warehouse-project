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
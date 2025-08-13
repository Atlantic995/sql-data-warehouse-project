SELECT [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
  FROM [DataWarehouse].[bronze].[crm_sales_details]


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
TRUNCATE TABLE silver.crm_cust_info;
BULK INSERT silver.crm_cust_info
FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);

TRUNCATE TABLE silver.crm_prd_info;

BULK INSERT silver.crm_prd_info
FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);

TRUNCATE TABLE silver.crm_sales_details;

BULK INSERT silver.crm_sales_details
FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);

TRUNCATE TABLE silver.erp_cust_az12;

BULK INSERT silver.erp_cust_az12
FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);


TRUNCATE TABLE silver.erp_loc_a101;

BULK INSERT silver.erp_loc_a101
FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);


TRUNCATE TABLE silver.erp_px_cat_g1v2;

BULK INSERT silver.erp_px_cat_g1v2
FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK

);

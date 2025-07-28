/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source->Bronze)
===============================================================================
Script Purpose:
      This stored procedure loads datainto the 'bronze' schema from external CSV files.
      It performs the following actions:
      - Truncates the bronze tables before loading data.
      - Use the 'BULK INSERT' command to load data from CSV Files to bronze tables.

      Parameters:
      none
      This script does not accept any parameters or return any values

      Usage:
      EXEC bronze.load_bronze;
      
      
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN 
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch DATETIME, @end_batch DATETIME;

	BEGIN TRY
		SET @start_batch = GETDATE();
		PRINT '========================'
		PRINT 'loading the bronze layer'
		PRINT '========================'

		PRINT '------------------------'
		PRINT 'Loading CRM Tables'
		PRINT '------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating TABLE: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT 'Inserting data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time)AS VARCHAR) + 'seconds';
		PRINT '-----------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating TABLE: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT 'Inserting data into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time)AS VARCHAR) + 'seconds';
		PRINT '-----------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating TABLE: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT 'Inserting data into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time)AS VARCHAR) + 'seconds';
		PRINT '-----------';

		PRINT '------------------------'
		PRINT 'Loading ERP Tables'
		PRINT '------------------------'



		SET @start_time = GETDATE();
		PRINT '>> Truncating TABLE: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT 'Inserting data into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time)AS VARCHAR) + 'seconds';
		PRINT '-----------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating TABLE: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT 'Inserting data into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time)AS VARCHAR) + 'seconds';
		PRINT '-----------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating TABLE: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT 'Inserting data into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Vasily\Desktop\DATA Engineering sql\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK

		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time)AS VARCHAR) + 'seconds';
		PRINT '-----------';
		SET @end_batch = GETDATE();
		PRINT '>>TOTAL Load Duration:' + CAST(DATEDIFF(second, @start_batch, @end_batch)AS VARCHAR) + 'seconds';
	END TRY
	BEGIN CATCH
	PRINT '============================================='
	PRINT 'Error has occured during load bronze layer'
	PRINT 'Error message:'+ ERROR_MESSAGE();
	PRINT 'Error message:'+ CAST(ERROR_NUMBER()AS VARCHAR);
	PRINT 'Error message:'+ CAST(ERROR_STATE()AS VARCHAR);
	PRINT '============================================='
	END CATCH
END	

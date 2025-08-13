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
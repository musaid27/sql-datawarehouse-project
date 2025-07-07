/*
DDL scrpit: Create silver tables
script purpose:
    This scri[pt creates table in silver schema dropping existing tables if they already esixt.
    Run this script to re-difine the ddl structure of bronze table


*/




--- first drop the table if it exist and then create it---
if object_id ('silver.crm_cust_info', 'u' ) is not null
drop table silver.crm_cust_info;




-- creating tabels for source crm----
create table silver.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_maritial_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.crm_prd_info', 'u' ) is not null
drop table silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_date date,
	prd_end_date date,
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.crm_sales_details', 'u' ) is not null
drop table silver.crm_sales_details;
create table silver.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prod_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default getdate()

);



-- creating tables for source erp---

if object_id ('silver.erp_cust_az12', 'u' ) is not null
drop table silver.erp_cust_az12;

create table silver.erp_cust_az12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR (50),
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.erp_loc_a101', 'u' ) is not null
drop table silver.erp_loc_a101;
CREATE table silver.erp_loc_a101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.erp_PX_cat_g1v2', 'u' ) is not null
drop table silver.erp_PX_cat_g1v2;

CREATE TABLE silver.erp_PX_cat_g1v2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date datetime2 default getdate()
);

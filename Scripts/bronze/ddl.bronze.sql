/*
================================
DDL scrpits: create bronze table
================================
This script create tables in bronze schema dropping existing tables if they already exists.

*/






--- first drop the table if it exist and then create it---
if object_id ('bronze.crm_cust_info', 'u' ) is not null
drop table bronze.crm_cust_info;




-- creating tabels for source crm----
create table bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_maritial_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);

if object_id ('bronze.crm_prd_info', 'u' ) is not null
drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_date datetime,
	prd_end_date datetime
);

if object_id ('bronze.crm_sales_details', 'u' ) is not null
drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prod_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int

);



-- creating tables for source erp---
if object_id ('bronze.erp_cust_az12', 'u' ) is not null
drop table bronze.erp_cust_az12;

create table bronze.erp_cust_az12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR (50)
);

if object_id ('bronze.erp_loc_a101', 'u' ) is not null
drop table bronze.erp_loc_a101;
CREATE table bronze.erp_loc_a101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
);

if object_id ('bronze.erp_PX_cat_g1v2', 'u' ) is not null
drop table bronze.erp_PX_cat_g1v2;

CREATE TABLE bronze.erp_PX_cat_g1v2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);

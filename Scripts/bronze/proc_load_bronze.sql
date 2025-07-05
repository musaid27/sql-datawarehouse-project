/*
=============================================
procedure of loading data into bronze layer:
=============================================
This script performs the following action:
- Truncate the bronze tables before loading the data
- load the data through bulk insert command 
parameter:
This procedure does not accept any parameters

USAGE EXAMPLE : exec bronze.load_bronze

*/








----load data into the tabels using bulk insert but first truncate the table and empty the table-----
create or alter procedure bronze.load_bronze as 
begin
    declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
	    set @batch_start_time=getdate();
		print '===========================';
		print ' Loading Bronze Layer';
		print '===========================';


		print'----------------------------';
		print'Loading CRM Tables'
		print'----------------------------';

		set @start_time= getdate();
		print'Truncating table: bronze.crm_cust_info ';
		truncate table bronze.crm_cust_info
		print'Inserting data into: bronze.crm_cust_info ';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\Micropc\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		  firstrow = 2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time=getdate();
		print'>>Load time: '+ cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		print'>> -------------------';


		set @start_time=getdate();
		print'Truncating table:bronze.crm_prd_info ';
		truncate table bronze.crm_prd_info
		print'Inserting data info:bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\Micropc\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
		   firstrow = 2,
		   fieldterminator = ',',
		   tablock
		);
	    set @end_time=getdate();
		print'>> Load time: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+ ' seconds';
		print'>> -------------------';



		set @start_time=getdate();
		print'Truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details
		print'Inserting data info: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'C:\Users\Micropc\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
		  firstrow = 2,
		  fieldterminator = ',',
		  tablock

		);
		set @end_time=getdate();
		print('>>Load time: ')+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
		print'>> -------------------';




		print'----------------------------';
		print'Loading ERP Tables'
		print'----------------------------';



		set @start_time=getdate();
		print'Truncating table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12
		print'Inserting data info: bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\Micropc\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
		  firstrow=2,
		  fieldterminator=',',
		  tablock

		);
        set @end_time=getdate();
		print'Load time:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
		print'>> -------------------';


		set @start_time=getdate();
		print'Truncating table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101
		print'Insertind data info: bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\Micropc\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (firstrow = 2,
			  fieldterminator = ',',
			  tablock
  
		);
		set @end_time=getdate();
		print'Load time:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
		print'>> -------------------';

		set @start_time=getdate();
		print'Truncate table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2
		print'Inserting data info: bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\Micropc\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
		   firstrow = 2,
		   fieldterminator= ',',
		   tablock
		);
		set @end_time=getdate();
		print'Load time:'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
		print'>> -------------------';

		set @batch_end_time=getdate();
		print'----------------------';
		print'Loading bronze layer is completed';
		print'   -Total load time: '+ cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar)+' secnods';
		print'----------------------';
	end try
	begin catch
		print'=================================';
		print'error occured during loading';
		print'error message:'+ error_message();
		print'error number:'+ cast(error_number() as nvarchar);
		print'error number:'+ cast(error_state() as nvarchar);
		print'=================================';
	end catch
end

---- quality check that it matches from the table rows ---
select count(*) from bronze.crm_cust_info
select count(*) from bronze.crm_prd_info
select count(*) from bronze.crm_sales_details
select count(*) from bronze.erp_cust_az12
select count(*) from bronze.erp_loc_a101
select count(*) from bronze.erp_PX_cat_g1v2

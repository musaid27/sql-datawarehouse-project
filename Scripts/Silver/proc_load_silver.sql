/*
   *****************************************************
   Stored procedure: load silver layer  (Bronze-> Silver)
   *****************************************************
Script purpose: This stored procedure performs the ETL(extarct , transform , delete) process to populate the silver schema from the bronze schema
actions performed: Truncate silver tables
                   Inserts transformed and cleansed data  from bronze into silver table
parameters: This stored procedure does not take any parameters.

USAGE: exec silver.load_silver;
           
*/






create or alter procedure silver.load_silver as
begin
 declare @start_time datetime, @end_time datetime,@batch_start_time datetime, @batch_end_time datetime
begin try
        set @batch_start_time = getdate(); 
        print'=========================';
		print'Loading Silver Layer';
		print'=========================';
		
		print'Loading CRM tables:';
		print'------------------';
		set @start_time = getdate();
		print'<< Truncating Table: Silver.crm_cust_info';
		truncate table silver.crm_cust_info;
		print'<<Insreting data into silver.crm_cust_info';
		insert into silver.crm_cust_info (cst_id,cst_key,cst_firstname,cst_lastname,cst_maritial_status,cst_gndr,cst_create_date)
		select  cst_id,
				cst_key,
				trim(cst_firstname) as cst_firstname,--trimming value for deleting unwanted spacing---
				trim(cst_lastname) as cst_lastname,
		
				case when upper(trim(cst_maritial_status)) = 'M' THEN 'Married'
					 when upper(trim(cst_maritial_status))= 'S' THEN 'Single'
					 else 'n/a'
				end cst_maritial_status,---normalize maritial status values to readable format
		
				case when upper(trim(cst_gndr)) = 'M' THEN 'Male'
					 when upper(trim(cst_gndr))= 'F' THEN 'Female'
					 else 'n/a'
				end cst_gndr,   ---normalize gndr values to readable format
				cst_create_date

		from(

		select *,
		row_number() over(partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info where cst_id is not null)t where flag_last = 1; --select the most rescent record per customer--
		set @end_time = getdate();
		print'Total loading time of table: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
		print'>>----------------------------------';

		set @start_time = getdate();
		print'Truncating Table: silver.crm_prd_info';
		Truncate table silver.crm_prd_info;
		print'<< Insertimg data into silver.crm_prd_info';
		Insert into silver.crm_prd_info(prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_date,prd_end_date)
		select  prd_id,
				replace(substring(prd_key,1,5),'-','_') as cat_id,---extract category id
				substring(prd_key,7,len(prd_key)) as prd_key,--extract product key
				prd_nm,
				isnull(prd_cost,0) as prd_cost,
		
				case when upper(trim(prd_line))='R' THEN 'Road'
					 when upper(trim(prd_line))='S' THEN 'Other sales'
					 when upper(trim(prd_line))='M' THEN 'Mountain'
					 when upper(trim(prd_line))='T' THEN 'Touring'
					 else 'n/a'
				end  as prd_line, --map product lines code to discriptive value
				cast(prd_start_date as date)as prd_start_date,
				cast(lead(prd_start_date) over(partition by prd_key order by prd_start_date)-1 as date) as prd_end_date--calculate end date as one day before the next start day
		from bronze.crm_prd_info;
		set @end_time = getdate();
		print'Total loading time of table: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
		print'>>----------------------------------';


		set @start_time = getdate();
		print'Truncating table: silver.crm_sales_details';
		Truncate table silver.crm_sales_details;
		print'Inserting data into silver.crm_sales_details';
		insert into silver.crm_sales_details (sls_ord_num,sls_prod_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
		select sls_ord_num,
			sls_prod_key,
			sls_cust_id,
	
			case when sls_order_dt <= 0 or len(sls_order_dt) !=8 then null  ---handling invalid data
				 else cast(cast(sls_order_dt as varchar) as date)           --data type casting changing format of int to date
			end sls_order_dt,
	
			case when sls_ship_dt <= 0 or len(sls_ship_dt) !=8 then null
				 else cast(cast(sls_ship_dt as varchar) as date)
			end sls_ship_dt,
	
			case when sls_due_dt <= 0 or len(sls_due_dt) !=8 then null
				 else cast(cast(sls_due_dt as varchar) as date)
			end sls_due_dt,
	
			case when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price) then 
					sls_quantity * abs(sls_price)
			   else sls_sales
			end sls_sales,                                             --recalculating sales if original value is missing or incorect
			sls_quantity,
			case when sls_price is null or sls_price <=0 then
			   sls_sales / nullif(sls_quantity,0)
			   else sls_price
		  end sls_price                                                --derive price if original value is incorrect
		from bronze.crm_sales_details;
		set @end_time = getdate();
		print'Total loading time of table: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
		print'>>----------------------------------';

		PRINT'loading ERP tables:';
		print'-------------------';
		set @start_time = getdate();
		print'Truncating table: silver.erp_cust_az12';
		Truncate table silver.erp_cust_az12;
		print'Inserting data into silver.erp_cust_az12';
		insert into silver.erp_cust_az12(cid,bdate,gen)
		select 

		 case when cid like 'NAS%' THEN substring(cid,4,len(cid))  --- Remove nas prefix if present to match the key
			  else cid
		 end cid,

		 case when bdate > getdate() then null      --- remove the date that was in the future
			  else bdate
		 end as bdate ,

		 case when upper(trim(gen)) in ('F','Female') THEN  'Female'    ---standardize the format removing null and blank spaces and make it in consistent format 
			  when upper(trim(gen)) in ('M','Male') THEN  'Male'
			  else 'n/a'
		 end gen
		from bronze.erp_cust_az12;
		set @end_time = getdate();
		print'Total loading time of table: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
		print'>>----------------------------------';


		set @start_time = getdate();
		print'Truncating table :silver.erp_loc_a101 ';
		Truncate table silver.erp_loc_a101;
		print'Insertimd data into silver.erp_loc_a101';
		insert into silver.erp_loc_a101(cid,cntry)
		select 

		replace(cid,'-','') cid,   --- remove the minus to match the column

		case when trim(cntry) = 'DE' then ' Germany'
			 when trim(cntry)  in ('US','USA','United States') then 'United States'
			 when trim(cntry) is null or trim(cntry) = '' then 'n/a'
			 else trim(cntry)      ----- handle missing null and inconsistent values
		end cntry
		from bronze.erp_loc_a101 ;
		set @end_time = getdate();
		print'Total loading time of table: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
		print'>>----------------------------------';


		set @start_time = getdate();
		print'Truncating table: silver.erp_px_cat_g1v2';
		Truncate table silver.erp_px_cat_g1v2;
		print'Inserting data into silver.erp_px_cat_g1v2';
		insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)
		select 
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_px_cat_g1v2;
		set @end_time = getdate();
		print'Total loading time of table: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
		
		set @batch_end_time = getdate();
	 PRINT'-------------------------------';
	 print'Total load time of silver layer: '+cast(datediff(second,@batch_start_time,@batch_end_time)as nvarchar)+' seconds';
	 print'-------------------------------';


end try
    begin catch
		 print'========================';
		 print'error occured during loading;';
		 print'Error message:'+ error_message();
		 print'Error number: '+ cast(error_number()as nvarchar);
		 print'Error state:'+ cast(error_state() as nvarchar);
		 print'========================';
	 end catch
	 set @batch_end_time = getdate();
	
end

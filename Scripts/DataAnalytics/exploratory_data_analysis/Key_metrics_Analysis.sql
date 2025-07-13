/*
Gnerating report for key mertrics
*/


---explore all objects in database---
select * from information_schema.tables


--explore all columns in database--
select * from information_schema.columns
where TABLE_NAME = 'dim_customers'


--explore all countries are customers come from
select distinct country from gold.dim_customers

--explore productline--
select distinct product_line from gold.dim_products

--explore all categories 'the major division'
select distinct category,subcategory,product_name,product_line from gold.dim_products
order by 1,2,3,4

--explore date column find youngest and oldest customers in customers column--
select min(birthdate)earlist_bdt ,
max(birthdate)latest_bdt,
datediff(year,min(birthdate),getdate())oldest_customer_age,
datediff(year,max(birthdate),getdate())youngest_customer_age
from gold.dim_customers


--explore date in fact tables ie: find first and last order
--how many years of sales is available

select min(order_date)first_order,
max(order_date)last_order,
datediff(year,min(order_date),max(order_date)) as years_of_sales
from gold.fact_sales 


--find the total sales
--find how many items are sold
--find the average selling price
--find the total number of orders
--find the total number of products
--find the total number of customers
--find the total number of customers that have placed an order

--Generate a report that shows all key metrics of a buisness---
select 'Total_sales' as Measure_name ,sum(sales_amount)Measure_value from gold.fact_sales
union all
select 'Total_quantity' as Measure_name ,sum(quantity)Measure_value from gold.fact_sales
union all
select 'Avg_price' as Measure_name ,avg(price)Measure_value from gold.fact_sales
union all
select 'Total_order_num' as Measure_name ,count(distinct order_number)Measure_value from gold.fact_sales
union all
select 'Total_product_name' as Measure_name ,count(distinct product_name)Measure_value  from gold.dim_products 
union all
select 'Total_customers' as Measure_name , count(customer_id)Measure_value  from gold.dim_customers
union all
select 'Total_customers_with_orders' as Measure_name , count(distinct customer_key)Measure_value  from gold.dim_customers

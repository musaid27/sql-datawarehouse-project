/*
Order the value of dimension by measure
such as top n performer or bottom n performer


*/





--which 5 products generate the high revenue
select top 5 dp.product_name,sum(fs.sales_amount)Total_sales from gold.fact_sales fs 
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name
order by Total_sales desc


--Solved with window function
select * from(
select  dp.product_name,sum(fs.sales_amount)Total_sales,
 row_number() over(order by sum(fs.sales_amount) desc) as rank_products
 from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name)t where rank_products <=5


--what are the w0rst 5 performing products.
select top 5 dp.product_name,sum(fs.sales_amount)Total_sales from gold.fact_sales fs 
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.product_name
order by Total_sales 

--Find the top ten customers who have generated the highest revenue
select top 10 dc.customer_key,dc.first_name,dc.last_name,sum(fs.sales_amount)tottal_sales from gold.fact_sales fs
left join  gold.dim_customers dc on
fs.customer_key = dc.customer_key
group by dc.customer_key,dc.first_name,dc.last_name
order by tottal_sales desc


--top three customers with few placed orders--
select top 3 dc.customer_key,dc.first_name,dc.last_name,count(distinct order_number)tottal_orders from gold.fact_sales fs
left join  gold.dim_customers dc on
fs.customer_key = dc.customer_key
group by dc.customer_key,dc.first_name,dc.last_name
order by tottal_orders

/*
group the data based on specific range
*/
--Data segenmentation
--Segments products into cost ranges  and count how many products fall into each category--

with segement as(
select product_key,
product_name,
cost,
case when cost < 100 then  'below 100'
     when cost between 100 and 500 then '100-500'
     when cost between 500 and 1000 then '500-1000'
     else 'above 1000'
end cost_range
from gold.dim_products)

select count(product_key)total_products,cost_range  from segement group by cost_range;


--Group customers into three sgements based on their spending behavior
--:vip: at least 12 months of history and spending more than 5000
--:Regular: at least 12 months of history but spending 5000 or less
--:New: lifespan less than 12 months
-- and find the total no of customers for each group
with customer_spending as (
select dc.customer_key,
sum(fs.sales_amount)as total_spending, 
min(order_date)as first_order,
max(order_date)as last_order,
datediff(month,min(order_date),max(order_date))as lifespan
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by dc.customer_key )

select customer_segment,
count(customer_key)as total_customers
from(
    select 
    customer_key,
    case when lifespan >= 12 and total_spending > 5000 then 'VIP'
         WHEN lifespan >= 12 and total_spending <= 5000 then 'Regular'
         else 'New'
    end customer_segment
from customer_spending )t
group by customer_segment;

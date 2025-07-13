/*
analyze how ameasure evolve over time


*/

---Advance data analytics--
--Analyze sales performance overtime
select month(order_date)as order_month,
 year(order_date)as order_year,
sum(sales_amount) Total_sales,
count(distinct customer_key)as Total_customer,
sum(quantity)total_quantity
from gold.fact_sales 
where order_date is not null 
group by month(order_date),year(order_date)
order by month(order_date),year(order_date)

/*
you can perform the same thing for year to year change 
*/

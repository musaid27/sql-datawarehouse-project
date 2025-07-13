/*
Aggregate data progressivly overtime . helps determine wethet the buisness is growing or not
such as running total sales by year or moving avg of sales by month

*/
--Cummulative analysis--
--Calculate the total sales for month
-- running total of sales overtime

select order_date,total_sales,avg_price, 
sum(total_sales) over(order by order_date) as running_total_sales,
avg(avg_price) over(order by order_date) as moving_avg_price
from (


select datetrunc(year,order_date)as order_date,
    sum(sales_amount)total_sales,
    avg(price)as avg_price
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)

)t

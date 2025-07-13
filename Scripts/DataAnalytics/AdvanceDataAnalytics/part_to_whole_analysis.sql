/*
analyze how a individual part is performing compared to the overall

allow us to understand which category has greatest impact on buisness
*/

--Part to whole analysis
--Which categories contribute the most to overall sales.

with category_sales as(
select dp.category,
sum(fs.sales_amount)Total_sales
from gold.fact_sales fs 
left join gold.dim_products dp
on fs.product_key = dp.product_key
group by dp.category )

select category,
Total_sales,
sum(Total_sales) over() overall_sales,
concat(round((cast(Total_sales as float)/sum(Total_sales) over())*100,2),'%') percentage_of_total
from category_sales
order by Total_sales desc



--Customer Reporting---
/*
===============================================
THIS REPORT CONSOLIDATE KEY CUSTOMER METRICS AND BEHAVIOR
===============================================
highlights:
 1. Gathers essentials deatails such as names ages and transactional details.
 2.segments customers into category (VIP,Regular,New ) age groups.
 3. aggregate customer level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products
   - lifespan in months
4. calculates valuable kpis:
   - receny (months since last order)
   - average order value
   - average monthly spend
===============================================
*/
create view gold.report_customers as
--1st step: retrive core columns 
with base_query as(
select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name,' ',c.last_name) as customer_name,
datediff(year,c.birthdate,getdate())as age
from gold.fact_sales f
left join gold.dim_customers c on
f.customer_key = c.customer_key
where order_date is not null
), customer_aggregation as (
--custoemr aggregation
select 
     customer_key,
     customer_number,
     customer_name,
     age,
     count(distinct order_number) as total_orders,
     sum(sales_amount) as total_sales,
     sum(quantity) as total_quantity,
     count(distinct product_key) as total_product,
     max(order_date)as last_order,
     datediff(month,min(order_date),max(order_date))as lifespan
 from base_query
 group by
     customer_key,
     customer_number,
     customer_name,
     age)
select 
     customer_key,
     customer_number,
     customer_name,
     age,
     case when age < 20 then 'under 20'
          when age between  20 and 29 then '20- 29'
          when age between  40 and 49 then '40- 49'
          else '50 and above'
     end as age_group,

     case when lifespan >= 12 and total_sales > 5000 then 'VIP'
          WHEN lifespan >= 12 and total_sales <= 5000 then 'Regular'
          else 'New'
     end customer_segment,
     last_order,
     datediff(month,last_order,getdate())as recency,
      total_orders,
      total_sales,
      total_quantity,
      total_product,
      lifespan,
      --compute avderage order value (avo)
      case when total_orders = 0 then 0
           else total_sales/total_orders
      end  as avg_order_value,
      --compute avg monthly spend
      case when lifespan = 0 then total_sales
           else total_sales/lifespan 
      end as avg_monthly_spend
from customer_aggregation;

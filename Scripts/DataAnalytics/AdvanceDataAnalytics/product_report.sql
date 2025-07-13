--product report--
/*
===============================================
THIS REPORT CONSOLIDATE KEY PRODUCTS METRICS AND BEHAVIOR
===============================================
Highlights: 
 1.gathers essential field such as product_name,category,subcategory,cost.
 2.Segment products by revenue to identify high performer , low performer, mid_range.
 3.aggregate product level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers unique
   - lifespan in months
 4.calculate valuable kpis
   - recency (months since last sale)
   - average order revenue (aor)
   - average monthly revenue
*/

create view gold.report_products as 
with base_query as (
select 
p.category,
p.product_name,
p.subcategory,
p.cost,
f.customer_key,
f.product_key,
f.order_date,
f.quantity,
f.sales_amount
from
gold.fact_sales f
left join gold.dim_products p on
f.product_key = p.product_key
where order_date is not null),
product_aggregations as (

select 
       product_key,
       product_name,
       category,
       subcategory,
       cost,
       datediff(month,min(order_date),max(order_date)) as lifespan,
       max(order_date) as last_sale_date,
       count(order_date) as total_orders,
       sum(sales_amount)as total_sales,
       count(quantity) as total_quantity,
       count(distinct customer_key) as total_customers,
       round(avg(cast(sales_amount as float)/nullif(quantity,0)),1) as avg_selling_price
from base_query
group by

       product_key,
       product_name,
       category,
       subcategory,
       cost)
--Final query:
select 
       product_key,
       product_name,
       category,
       subcategory,
       cost,
       last_sale_date,
       datediff(month,last_sale_date,getdate())as recency_IN_months,
        case when total_sales > 5000 then 'high performer'
             when total_sales >= 10000 then 'mid range'
             else 'low performer'
        end as product_segment,
        lifespan,
        total_orders,
        total_customers,
        total_quantity,
        total_sales,
        avg_selling_price,
        --average order revenue
        case when total_orders = 0 then 0 
             else total_sales/total_orders
        end as avg_order_revenue,
        --average monthly revenue
        case when lifespan = 0 then total_sales
             else total_sales/lifespan
        end as avg_monthly_revenue
       from product_aggregations

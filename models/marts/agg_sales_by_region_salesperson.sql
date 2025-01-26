
{{
    config(
        materialized='table'
    )
}}

with sales_by_region_salesperson as (
    select 
        sales_order_id 
        , businessentity_id as sales_person_id
        , order_date
        , subtotal as total_sale
        , case  
        when country_region_code = 'US' then 'United States'
        else territory_name
        end as country
        , region
from {{ ref('int_agg_sales') }}
order by sales_order_id
)

select * 
from sales_by_region_salesperson
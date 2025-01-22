{{
    config(
        materialized='table'
    )
}}

with
    employee as (
        select
            businessentity_id,
            job_title
        from {{ ref('stg_humanresources_employee') }}
    )

    , sales_salesperson as (
        select
            businessentity_id,
            territory_id as salesperson_territory_id,
            sales_ytd as salesperson_salesytd,
            sales_last_year as salesperson_saleslastyear
        from {{ ref('stg_sales_salesperson') }}
    )
    
    , sales_territory as (
        select
            territory_id as territory_id_original,
            territory_name,
            country_region_code,
            region,
            sales_ytd as territory_salesytd,
            sales_last_year as territory_saleslastyear
        from {{ ref('stg_sales_salesterritory') }}
    )
    
    , sales_order_header as (
        select
            sales_order_id,
            order_date,
            sales_person_id as businessentity_id,
            territory_id as order_territory_id,
            subtotal
        from {{ ref('stg_sales_salesorderheader') }}
    )
    
    , businessentity_join_employee_salesperson as (
        select
            employee.businessentity_id,
            employee.job_title,
            sales_salesperson.salesperson_territory_id,
            sales_salesperson.salesperson_salesytd,
            sales_salesperson.salesperson_saleslastyear
        from employee
        left join sales_salesperson
        on employee.businessentity_id = sales_salesperson.businessentity_id
    )
    
    , businessentity_join_orderheader as (
        select
            businessentity_join_employee_salesperson.businessentity_id,
            businessentity_join_employee_salesperson.job_title,
            businessentity_join_employee_salesperson.salesperson_territory_id,
            businessentity_join_employee_salesperson.salesperson_salesytd,
            businessentity_join_employee_salesperson.salesperson_saleslastyear,
            sales_order_header.sales_order_id,
            sales_order_header.order_date,
            sales_order_header.order_territory_id,
            sales_order_header.subtotal 
        from businessentity_join_employee_salesperson
        left join sales_order_header
        on businessentity_join_employee_salesperson.businessentity_id = sales_order_header.businessentity_id
    )
    
    , territory_join as (
        select
            businessentity_join_orderheader.businessentity_id
            , businessentity_join_orderheader.job_title
            , businessentity_join_orderheader.salesperson_territory_id
            , businessentity_join_orderheader.salesperson_salesytd
            , businessentity_join_orderheader.salesperson_saleslastyear
            , businessentity_join_orderheader.sales_order_id
            , businessentity_join_orderheader.order_date
            , businessentity_join_orderheader.subtotal
            , sales_territory.territory_id_original as territory_id
            , sales_territory.territory_name
            , sales_territory.country_region_code
            , sales_territory.region
            , sales_territory.territory_salesytd
            , sales_territory.territory_saleslastyear
        from businessentity_join_orderheader
        left join sales_territory
        on businessentity_join_orderheader.order_territory_id = sales_territory.territory_id_original
    )
    
    , final_table as (
        select *
        from territory_join
        where job_title in (
            'Sales Representative', 
            'Pacific Sales Manager', 
            'European Sales Manager', 
            'North American Sales Manager'
        )
    )

select *
from final_table
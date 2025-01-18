{{
    config(
        materialized='table'
    )
}}

with
    sales_customer as (
        select
            customerid as customer_id
            , personid as person_id
            , storeid as store_id
            , territoryid as territory_id
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_sales.customer
    )

select *
from sales_customer
{{
    config(
        materialized='table'
    )
}}

with
    sales_territory as (
        select
            businessentityid as businessentity_id
            , name as store_name
            , salespersonid as sales_person_id
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_sales','store') }}
    )

select *
from sales_territory
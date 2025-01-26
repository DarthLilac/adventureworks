{{
    config(
        materialized='table'
    )
}}

with
    sales_territory as (
        select
            coalesce(businessentityid, 0) as store_id
            , coalesce(name, 'Online') as store_name
            , salespersonid as sales_person_id
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_sales','store') }}
    )

select *
from sales_territory
{{
    config(
        materialized='table'
    )
}}

with
    sales_order_header_reason as (
        select
            salesorderid as sales_order_id
            , salesreasonid as sales_reason_id
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_sales','salesorderheaderreason') }}
    )

select *
from sales_order_header_reason
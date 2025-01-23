{{
    config(
        materialized='table'
    )
}}

with
    sales_reason as (
        select
            salesreasonid as sales_reason_id
            , name as sales_reason_name
            , reasontype as reason_type
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_sales','salesreason') }}
    )

select *
from sales_reason
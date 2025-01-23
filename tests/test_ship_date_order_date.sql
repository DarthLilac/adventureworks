{{
    config(
        severety = 'error'
    )
}}

with
    test_date as (
        select *
        from {{ ref('stg_sales_salesorderheader') }}
        where ship_date < order_date
    )

select *
from test_date

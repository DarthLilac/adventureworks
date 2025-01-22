{{
    config(
        materialized='table'
    )
}}

with
    sales_order_detail as (
        select
            salesorderdetailid as sales_orderdetail_id
            , salesorderid as sales_order_id
            , orderqty as order_qty
            , productid as product_id
            , round (unitprice, 2) as unit_price
            , specialofferid as special_offer_id
            , unitpricediscount as unit_price_discount
            , round ((unitprice-unitpricediscount)*order_qty, 2) as order_total_value
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_sales','salesorderdetail') }}
    )

select *
from sales_order_detail
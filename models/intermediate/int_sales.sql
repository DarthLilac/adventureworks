{{
    config(
        materialized='table'
    )
}}

with
    sales_order_header as (
        select
            sales_order_id
            , customer_id
            , sales_person_id
            , bill_to_address_id
            , ship_to_address_id
            , credit_card_id
            , subtotal
            , tax_amt
            , freight
            , total_due

        from adventureworks_database.dev_andressa.stg_sales_salesorderheader
    )

    , sales_order_detail as (
        select
            sales_order_id 
            , sales_orderdetail_id
            , order_qty
            , unit_price
            , special_offer_id
            , unit_price_discount
            , order_total_value
        
        from adventureworks_database.dev_andressa.stg_sales_orderdetail
    )

    , sales_order_header_reason as (
        select
            sales_order_id
            , sales_reason_id

        from adventureworks_database.dev_andressa.stg_sales_salesorderheaderreason 
    )

    , credit_card as (
        select
            credit_card_id
            , card_type
        
        from adventureworks_database.dev_andressa.stg_sales_creditcard
    )

    , credit_card_join as (
        select
            sales_order_header.*
            , card_type

        from sales_order_header
        left join credit_card on credit_card.credit_card_id = sales_order_header.credit_card_id
    )

    , order_join as (
        select
            credit_card_join.*
            , sales_orderdetail_id
            , order_qty
            , unit_price
            , unit_price_discount
            , order_total_value

        from credit_card_join
        left join sales_order_detail on sales_order_detail.sales_order_id = credit_card_join.sales_order_id
    )

    , order_qty as (
        select
        sales_order_id
        , count(sales_order_id) as count_order
        
        from order_join
        group by sales_order_id
    )

    , final_table as (
        select
            order_join.*
            , sales_reason_id
            , count_order
            
        from order_join
        left join sales_order_header_reason on sales_order_header_reason.sales_order_id = order_join.sales_order_id
        left join order_qty on order_qty.sales_order_id = order_join.sales_order_id
    )

select *
from final_table
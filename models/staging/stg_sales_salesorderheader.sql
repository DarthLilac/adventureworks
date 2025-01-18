{{
    config(
        materialized='table'
    )
}}

with
    sales_order_header as (
        select
            salesorderid as sales_order_id
            , date (orderdate) as order_date
            , date (duedate) as due_date
            , date (shipdate) as ship_date
            , accountnumber as account_number
            , customerid as customer_id
            , salespersonid as sales_person_id
            , territoryid as territory_id
            , shiptoaddressid as ship_to_address_id
            , creditcardid as credit_card_id
            , subtotal
            , taxamt as tax_amt
            , freight
            , totaldue as total_due
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_sales.salesorderheader
    )

select *
from sales_order_header
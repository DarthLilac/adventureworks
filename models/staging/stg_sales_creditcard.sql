{{
    config(
        materialized='table'
    )
}}

with
    sales_credit_card as (
        select
            creditcardid as credit_card_id
            , cardtype as card_type
            , cardnumber as card_number
            , expmonth as exp_month
            , expyear as exp_year
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_sales','creditcard') }}
    )

select *
from sales_credit_card
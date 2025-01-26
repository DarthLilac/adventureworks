{{ 
    config(
        materialized='table'
    ) 
}}

with sales_data as (
    select
        {{ dbt_utils.generate_surrogate_key(['sales_order_id']) }} as sales_id
        , sales_order_id as order_id
        , order_date
        , customer_id
        , sales_person_id
        , product_id
        , order_qty
        , unit_price
        , freight
        , tax_amt as tax_amount          
        , subtotal as total_sale
        , total_due as gross_sale
        , reason_type

    from {{ ref('int_sales') }}

)

, dedup as (
        select *
        , row_number() over (partition by sales_data.sales_id order by sales_data.sales_id) as dedup_index,
        from sales_data
    )

    select *
    from dedup
    where dedup_index = 1
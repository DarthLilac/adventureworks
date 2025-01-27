{{ 
    config(
        materialized='table'
    ) 
}}

with 
    quantity as (
        select 
            sales_order_id
            , product_id
            , order_qty as product_quantity
        from {{ ref('stg_sales_orderdetail') }}
        --group by sales_order_id, product_id
)

    , store as (
        select
            store_id
            , store_name
            , sales_person_id
        from {{ ref('dim_store') }}
    )

    , sales_data as (
        select
            sales_order_id
            , order_date
            , customer_id
            , sales_person_id
            , product_id
            , unit_price
            , freight
            , tax_amt as tax_amount          
            , subtotal as total_sale
            , total_due as gross_sale
            , reason_type
        from {{ ref('int_sales') }}
)

    , final_table as (
        select 
            sales_data.sales_order_id
            , sales_data.order_date
            , sales_data.customer_id
            , sales_data.sales_person_id
            , sales_data.product_id
            , quantity.product_quantity
            , sales_data.unit_price
            , sales_data.freight
            , sales_data.tax_amount
            , sales_data.total_sale
            , sales_data.gross_sale
            , sales_data.reason_type
            --, store_id
            --, store_name
        from sales_data
        left join quantity
            on quantity.sales_order_id = sales_data.sales_order_id and quantity.product_id = sales_data.product_id
        --left join store
            --on store.sales_person_id = sales_data.sales_person_id
    )

    , dedup as (
        select *
        --, row_number() over (partition by final_table.sales_order_id order by final_table.sales_order_id) as dedup_index,
        from final_table
    )

    select *
    from dedup
    --where dedup_index = 1
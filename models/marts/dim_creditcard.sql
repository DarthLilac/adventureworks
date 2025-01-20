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
             , credit_card_id
        from adventureworks_database.dev_andressa.stg_sales_salesorderheader
    )

    , credit_card as (
        select
            credit_card_id
            , card_type
        from adventureworks_database.dev_andressa.stg_sales_creditcard
    )

    , final_table as (
        select
            {{ dbt_utils.generate_surrogate_key(['sales_order_header.credit_card_id']) }} as dim_creditcard_sk
            , sales_order_header.sales_order_id
            , sales_order_header.customer_id
            , sales_order_header.sales_person_id
            , coalesce(sales_order_header.credit_card_id, 0) as credit_card_id
            , coalesce(card_type, 'not available') as card_type
            from sales_order_header
            left join credit_card on (sales_order_header.credit_card_id = credit_card.credit_card_id)
            order by sales_order_header.sales_order_id asc
    )

    , dedup as (
        select *
        , row_number() over (partition by final_table.credit_card_id order by final_table.credit_card_id) as dedup_index,
        from final_table
    )

    select *
    from dedup
    where dedup_index = 1
{{
    config(
        materialized='table'
    )
}}

with
    store as (
        select
            store_id
            , store_name
            , sales_person_id
        from {{ref('stg_sales_store')}}
    )

    select *
    from store
{{
    config(
        materialized='table'
    )
}}

with
    salesperson as (
        select
            sales_person_id
            , sales_quota
            , bonus
            , commission_pct
            , sales_ytd
            , sales_last_year
        from {{ref('stg_sales_salesperson')}}
    )

    select *
    from salesperson
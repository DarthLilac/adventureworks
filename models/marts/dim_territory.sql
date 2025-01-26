{{
    config(
        materialized='table'
    )
}}

with
    territory as (
        select
            territory_id
            , territory_name
            , country_region_code
            , region
            , sales_ytd
            , sales_last_year
            , cost_ytd
        from {{ref('stg_sales_salesterritory')}}
    )

    select *
    from territory
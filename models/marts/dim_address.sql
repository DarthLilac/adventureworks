{{
    config(
        materialized='table'
    )
}}

with
    address as (
        select
            address_id
            , stateprovince_id
            , complete_address
            , city
            , postal_code
        from {{ref('stg_person_address')}}
    )

    , stateprovince as (
        select
            stateprovince_id
            , stateprovince_code
            , country_region_code
            , stateprovince_name
            , territory_id
        from {{ref('stg_person_stateprovince')}}
    )

    , sales_territory as (
        select
            territory_id
            , country_region_code
            , territory_name
            , sales_ytd
            , sales_last_year
            , cost_ytd
        from {{ref('stg_sales_salesterritory')}}
    )

    , final_table as (
        select
            {{ dbt_utils.generate_surrogate_key(['address_id']) }} as dim_territories_sk
            , address.address_id
            , address.complete_address
            , address.city
            , address.stateprovince_id
            , stateprovince.stateprovince_name
            , stateprovince.stateprovince_code
            , sales_territory.territory_name
            , stateprovince.country_region_code
        from address
        left join stateprovince on (address.stateprovince_id = stateprovince.stateprovince_id)
        left join sales_territory on (stateprovince.territory_id = sales_territory.territory_id)
    )


    select *
    from final_table
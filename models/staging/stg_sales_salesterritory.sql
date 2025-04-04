{{
    config(
        materialized='table'
    )
}}

with
    sales_territory as (
        select
            territoryid as territory_id
            , name as territory_name
            , countryregioncode as country_region_code
            , "GROUP" as region
            , salesytd as sales_ytd
            , saleslastyear as sales_last_year
            , costytd as cost_ytd
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_sales','salesterritory') }}
    )

select *
from sales_territory
{{
    config(
        materialized='table'
    )
}}

with
    state_province as (
        select
            stateprovinceid as stateprovince_id
            , stateprovincecode as stateprovince_code
            , countryregioncode as country_region_code
            , name as stateprovince_name
            , territoryid as territory_id
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_person','stateprovince') }}
    )

select *
from state_province
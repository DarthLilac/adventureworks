{{
    config(
        materialized='table'
    )
}}

with
    state_province as (
        select
            stateprovinceid as stateprovince_id
            , stateprovincecode as state_province_code
            , countryregioncode as country_region_code
            , name as state_province_name
            , territoryid as territory_id
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_person.stateprovince
    )

select *
from state_province
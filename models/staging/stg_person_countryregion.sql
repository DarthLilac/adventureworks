{{
    config(
        materialized='table'
    )
}}

with
    country_region as (
        select
            countryregioncode as country_region_code
            , name
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_person.countryregion
    )

select *
from country_region
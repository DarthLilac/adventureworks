{{
    config(
        materialized='table'
    )
}}

with
    businessentity as (
        select
            businessentityid as businessentity_id
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_person.businessentity
    )

select *
from businessentity
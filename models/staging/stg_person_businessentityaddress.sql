{{
    config(
        materialized='table'
    )
}}

with
    businessentity_address as (
        select
            businessentityid as businessentity_id
            , addresstypeid as addresstype_id
            , addressid as address_id
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_person.businessentityaddress
    )

select *
from businessentity_address
{{
    config(
        materialized='table'
    )
}}

with
    businessentity_contact as (
        select
            businessentityid as businessentity_id
            , contacttypeid as contact_type_id
            , personid as person_id
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_person.businessentitycontact
    )

select *
from businessentity_contact
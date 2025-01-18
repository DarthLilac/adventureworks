{{
    config(
        materialized='table'
    )
}}

with
    address as (
        select
            addressid as address_id
            , stateprovinceid as stateprovince_id
            , case
              when addressline1 is not null and addressline2 is not null 
                  then concat(addressline1, ' ', addressline2)
              when addressline1 is null and addressline2 is not null 
                  then addressline2
              when addressline1 is not null and addressline2 is null
                  then addressline1
              else null
              end as complete_address
            , city
            , postalcode as postal_code
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_person.address
    )

select *
from address
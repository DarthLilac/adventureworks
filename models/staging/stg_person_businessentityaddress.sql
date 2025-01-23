{{
    config(
        materialized='table'
    )
}}

with
    businessentity_address as (
        select
            businessentityid as businessentity_id
            , addressid as address_id
            , addresstypeid as addresstype_id
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_person','businessentityaddress') }}
    )

select *
from businessentity_address
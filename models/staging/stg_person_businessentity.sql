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

        from {{ source('raw_adventureworks_person','businessentity') }}
    )

select *
from businessentity
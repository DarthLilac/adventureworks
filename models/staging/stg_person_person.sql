{{
    config(
        materialized='table'
    )
}}

with
    person as (
        select
            businessentityid as businessentity_id
            , persontype as person_type
            , firstname as first_name
            , middlename as middle_name
            , lastname as last_name
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_person','person') }}
    )

select *
from person
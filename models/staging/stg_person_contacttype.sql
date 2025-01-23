{{
    config(
        materialized='table'
    )
}}

with
    contact_type as (
        select
            contacttypeid as contact_type_id
            , name as contact_type_name
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_person','contacttype') }}
    )

select *
from contact_type
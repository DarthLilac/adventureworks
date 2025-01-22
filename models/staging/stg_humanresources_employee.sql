{{
    config(
        materialized='table'
    )
}}

with
    employee as (
        select
            businessentityid as businessentity_id
            , nationalidnumber as national_id_number
            , jobtitle as job_title
            , birthdate as birth_date
            , gender
            , date (modifieddate) as modified_date
        from {{ source('raw_adventureworks_humanresources','employee') }}
    )

select *
from employee
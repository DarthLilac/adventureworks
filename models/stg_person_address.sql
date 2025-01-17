{{
    config(
        materialized='table'
    )
}}

with
    person_address as (
        select
            addressid
            , addressline1
            , addressline2
            , city
            , postalcode

        from ADVENTUREWORKS_DATABASE.RAW_ADVENTUREWORKS_PERSON.ADDRESS
    )

select *
from person_address
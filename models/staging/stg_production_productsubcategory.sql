{{
    config(
        materialized='table'
    )
}}

with
    product_subcategory as (
        select
            productsubcategoryid as product_subcategory_id
            , name as product_subcategory_name
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_production','productsubcategory') }}
    )

select *
from product_subcategory
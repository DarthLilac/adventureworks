{{
    config(
        materialized='table'
    )
}}

with
    product_category as (
        select
            productcategoryid as product_category_id
            , name as product_category_name
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_production.productcategory
    )

select *
from product_category
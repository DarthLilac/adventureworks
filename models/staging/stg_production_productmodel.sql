{{
    config(
        materialized='table'
    )
}}

with
    product_model as (
        select
            productmodelid as product_model_id
            , name as product_model_name
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_production.productmodel
    )

select *
from product_model
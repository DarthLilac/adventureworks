{{
    config(
        materialized='table'
    )
}}

with
    product as (
        select
            productid as product_id
            , name as product_name
            , productnumber as product_number
            , safetystocklevel as safety_stock_level
            , standardcost as standard_cost
            , listprice as list_price
            , color
            , size
            , sizeunitmeasurecode as size_unit_measure
            , weight
            , weightunitmeasurecode as weight_unit_measure
            , daystomanufacture as days_to_manufacture
            , productmodelid as product_model_id
            , productsubcategoryid as product_subcategory_id
            , date (modifieddate) as modified_date

        from {{ source('raw_adventureworks_production','product') }}
    )

select *
from product
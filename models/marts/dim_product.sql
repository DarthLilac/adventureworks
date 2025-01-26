{{
    config(
        materialized='table'
    )
}}

with
    product as (
        select
            product_id
            , product_subcategory_id
            , product_number
            , product_name
        from {{ref('stg_production_product')}}
    )

    , product_category as (
        select
            product_category_id
            , product_category_name
        from {{ref('stg_production_productcategory')}}
    )

    , product_subcategory as (
        select
            product_subcategory_id
            , product_subcategory_name
        from {{ref('stg_production_productsubcategory')}}
    )

    , product_model as (
        select
            product_model_id
            , product_model_name
        from {{ref('stg_production_productmodel')}}
    )

    , final_table as (
        select
            product.product_id
            , product.product_name
            , coalesce(product_category.product_category_id, 0) as product_category_id
            , coalesce(product_category.product_category_name, 'not available') as product_category_name
            , coalesce(product_subcategory.product_subcategory_id, 0) as product_subcategory_id
            , coalesce(product_subcategory.product_subcategory_name, 'not available') as product_subcategory_name
            , coalesce(product_model.product_model_id, 0) as product_model_id
            , coalesce(product_model.product_model_name, 'not available') as product_model_name
            from product
            left join product_subcategory on (product.product_subcategory_id = product_subcategory.product_subcategory_id)
            left join product_category on (product_category.product_category_id = product_category.product_category_id)
            left join product_model on (product.product_id = product_model.product_model_id)
    )

     , dedup as (
        select *
        , row_number() over (partition by final_table.product_id order by final_table.product_id) as dedup_index,
        from final_table
    )

    select *
    from dedup
    where dedup_index = 1
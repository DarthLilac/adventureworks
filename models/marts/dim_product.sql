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
        from adventureworks_database.dev_andressa.stg_production_product
    )

    , product_category as (
        select
            product_category_id
            , product_category_name
        from adventureworks_database.dev_andressa.stg_production_productcategory
    )

    , product_subcategory as (
        select
            product_subcategory_id
            , product_subcategory_name
        from adventureworks_database.dev_andressa.stg_production_productsubcategory
    )

    , product_model as (
        select
            product_model_id
            , product_model_name
        from adventureworks_database.dev_andressa.stg_production_productmodel
    )

    , final_table as (
        select
            {{ dbt_utils.generate_surrogate_key(['product.product_id']) }} as dim_product_sk
            , product.product_id
            , product.product_name
            , COALESCE(product_subcategory.product_subcategory_id, 0) as product_subcategory_id
            , product_category.product_category_name
            , COALESCE(product_subcategory.product_subcategory_name, 'not available') as product_subcategory_name
            from product
            left join product_subcategory on (product.product_subcategory_id = product_subcategory.product_subcategory_id)
            left join product_category on (product_category.product_category_id = product_category.product_category_id)
    )

     , dedup as (
        select *
        , row_number() over (partition by final_table.dim_product_sk order by final_table.dim_product_sk) as dedup_index,
        from final_table
    )

    select *
    from dedup
    where dedup_index = 1
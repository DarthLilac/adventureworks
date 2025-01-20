{{
    config(
        materialized='table'
    )
}}

with
    customer as (
        select
            customer_id
            , person_id
            , store_id
            , territory_id
        from adventureworks_database.dev_andressa.stg_sales_customer  
    )

    , person as (
        select
            businessentity_id
            , person_type
            , concat(first_name, ' ',coalesce(middle_name, ''), case when middle_name is null then '' else ' ' end,last_name) as complete_name
        from adventureworks_database.dev_andressa.stg_person_person
    )

    , store as (
        select
            businessentity_id
            , sales_person_id
            , store_name
        from adventureworks_database.dev_andressa.stg_sales_store
    )

    , territory as (
        select
            territory_id
            , territory_name
        from adventureworks_database.dev_andressa.stg_sales_salesterritory
    )

    , final_table as (
        select
            {{ dbt_utils.generate_surrogate_key(['customer.customer_id']) }} as dim_client_sk
            , customer.customer_id
            , customer.person_id
            , person.complete_name
            , coalesce(customer.store_id, 0) as store_id
            , coalesce(store.store_name, 'not available') as store_name
            , customer.territory_id
            , territory.territory_name
            from customer
            left join person on (customer.person_id = person.businessentity_id)
            left join store on (customer.store_id = store.businessentity_id)
            left join territory on (customer.territory_id = territory.territory_id)
            where customer.person_id is not null
            order by customer.customer_id asc
    )

    select *
    from final_table
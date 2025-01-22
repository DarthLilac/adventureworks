with
    salesorderheadersalesreason as (
        select
            sales_reason_id,
            sales_order_id
        from {{ ref('stg_sales_salesorderheaderreason') }}
    ),
    salesreason as (
        select
            sales_reason_id,
            sales_reason_name,
            reason_type
        from {{ ref('stg_sales_salesreason') }}
    ),
    join_dim_salesreason as (
        select
            sales_order_id,
            salesorderheadersalesreason.sales_reason_id,
            salesreason.sales_reason_name,
            salesreason.reason_type
        from salesorderheadersalesreason
        left join salesreason 
        on salesorderheadersalesreason.sales_reason_id = salesreason.sales_reason_id
        order by reason_type asc
    ), 
    aggregate_columns as (
        select
            sales_order_id,
            listagg(reason_type, ', ') within group (order by reason_type) as agg_reason_type,
            listagg(sales_reason_name, ', ') within group (order by sales_reason_name) as agg_name_reason
        from join_dim_salesreason
        group by sales_order_id
    ),
    replace_aggregate as (
        select 
            sales_order_id,
            replace(
                replace(replace(agg_reason_type, 'Other, Other', 'Other'),
                    'Other, Promotion', 'Promotion'),
                'Marketing, Other', 'Marketing') as reason_type,
            replace(agg_name_reason, 'Other, Other', 'Other') as sales_reason_name
        from aggregate_columns
        union all
        select
            null as sales_order_id,
            null as reason_type,
            null as sales_reason_name
    ),
    join_dim_salesreason_remove_duplicates as (
        select
            sales_order_id,
            coalesce(reason_type, 'not defined') as reason_type
        from replace_aggregate
    )
select *
from join_dim_salesreason_remove_duplicates
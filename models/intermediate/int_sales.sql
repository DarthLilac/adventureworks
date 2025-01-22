with 
    salesorderheader as (
        select
            sales_order_id
            , order_date
            , due_date
            , ship_date
            , account_number
            , customer_id
            , sales_person_id
            , bill_to_address_id
            , territory_id
            , ship_to_address_id
            , credit_card_id
            , subtotal
            , tax_amt
            , freight
            , total_due
        from {{ref('stg_sales_salesorderheader')}}   
    )

    , salesorderdetail as (
        select
            sales_orderdetail_id
            , sales_order_id
            , order_qty
            , product_id
            , unit_price
            , special_offer_id
            , order_total_value
        from {{ref('stg_sales_orderdetail')}} 
    )

    , salesorderheadersalesreason as (
        select
            sales_order_id
            , sales_reason_id
        from {{ref('stg_sales_salesorderheaderreason')}} 
    )
    
    , creditcard as (
	    select
            credit_card_id
            , card_type 
	    from {{ ref('stg_sales_creditcard') }}	
    )
    
    , int_reason as (
        select *
        from {{ref('int_reason')}}
    )
    
    , union_credit_card as (
	    select 
	    	salesorderheader.*
	    	, card_type
	    from salesorderheader 
	    left join creditcard on creditcard.credit_card_id = salesorderheader.credit_card_id
    )
    
    , union_header_detail as (
	    select 
		union_credit_card.*
		, sales_orderdetail_id
		, product_id
		, order_qty
		, unit_price
		, order_total_value
	from salesorderdetail 
	left join union_credit_card
		on union_credit_card.sales_order_id =  salesorderdetail.sales_order_id
    )
    , count_orders as (
        select 
            sales_order_id
            , count(sales_order_id) as count_orders_rows
            from union_header_detail
            group by sales_order_id
    )
    
    , join_fixing_columns as (
        select
            union_header_detail.*
            , count_orders_rows
            , freight / count_orders_rows as freight_fixed
            , tax_amt / count_orders_rows as tax_fixed
            from union_header_detail
            left join count_orders
                on count_orders.sales_order_id  = union_header_detail.sales_order_id
)

    , fixed_table as (
	    select 
		    sales_order_id
		    , sales_orderdetail_id
            , order_date
		    , customer_id
            , sales_person_id
            , territory_id
            , bill_to_address_id
            , ship_to_address_id
            , credit_card_id
            , card_type
            , product_id
            , order_qty
            , unit_price
            , round (freight_fixed, 2) as freight
            , round (tax_fixed, 2) as tax_amt
            , subtotal
        from join_fixing_columns
    )

, union_reason as (
        select
            fixed_table.*
            , reason_type
            from fixed_table
            left join int_reason on int_reason.sales_order_id = fixed_table.sales_order_id
)

select * 
from union_reason
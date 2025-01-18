{{
    config(
        materialized='table'
    )
}}

with
    sales_person as (
        select
            businessentityid as businessentity_id
            , territoryid as territory_id
            , salesquota as sales_quota
            , bonus
            , commissionpct as commission_pct
            , salesytd as sales_ytd
            , saleslastyear as sales_last_year
            , date (modifieddate) as modified_date

        from adventureworks_database.raw_adventureworks_sales.salesperson
    )

select *
from sales_person
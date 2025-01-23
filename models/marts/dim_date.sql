{{
    config(
        materialized='table'
    )
}}

with date_series as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2011-01-01' as date)",
        end_date="cast(dateadd('day', 366, current_date()) as date)" 
    )
    }}

)

, date_columns as (
    select distinct
        date(date_day) as metric_date
	    , extract(day from date_day) as day
        , extract(month from date_day) as month
        , extract(year from date_day) as year
        , extract(quarter from date_day) as quarter
    from date_series
)

, month_columns as (
    select
    	*
		, case
            when month = 1 then 'Jan'
            when month = 2 then 'Feb'
            when month = 3 then 'Mar'
            when month = 4 then 'Apr'
            when month = 5 then 'May'
            when month = 6 then 'Jun'
            when month = 7 then 'Jul'
            when month = 8 then 'Aug'
            when month = 9 then 'Sep'
            when month = 10 then 'Oct'
            when month = 11 then 'Nov'
            when month = 12 then 'Dec'
        end as month_name
    from date_columns
)

select *
from month_columns
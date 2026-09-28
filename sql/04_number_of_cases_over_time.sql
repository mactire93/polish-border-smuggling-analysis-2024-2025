-- REQ1 : How did the number of smuggling cases change over time?

select
	count(*)
from smuggling;

select *
from smuggling;

-- number of cases per years
select
	year(event_datetime) as year,
	count(*) as case_count
from smuggling
group by year(event_datetime)
order by year;

-- number cases per months and years
select
	year(event_datetime) as year,
	month(event_datetime) as month,
	count(*) as case_count
from smuggling
group by year(event_datetime), month(event_datetime)
order by year, month;

select
	month(event_datetime) as month_num,
	monthname(event_datetime) as month_name,
	sum(year(event_datetime) = 2024) as cases_2024,
	sum(year(event_datetime) = 2025) as cases_2025
from smuggling
group by month_num, month_name
order by month_num;

-- checking by how many cases the situation has changed each month
select
    month(event_datetime) as month_num,
    monthname(event_datetime) as month_name,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025,
    sum(year(event_datetime) = 2025)
        - sum(year(event_datetime) = 2024) as change_cases
from smuggling
group by month_num, month_name
order by month_num;

-- checking an increase smuggling relative to commodities (march and april)
select
	month(event_datetime) as month_num,
	monthname(event_datetime) as month_name,
	commodity_category,
	commodity_type,
	sum(year(event_datetime) = 2024) as cases_2024,
	sum(year(event_datetime) = 2025) as cases_2025
from smuggling
where month(event_datetime) in (3, 4)
group by month_num, month_name, commodity_category, commodity_type
order by month_num;

-- March: what type of weapon was responsible for this increase?

select
    commodity_type,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025,
    sum(year(event_datetime) = 2025)
        - sum(year(event_datetime) = 2024) as change_cases
from smuggling
where month(event_datetime) = 3
  and commodity_category = 'Broń'
group by commodity_type
order by change_cases desc;

-- March: what type of ammunition was responsible for this increase?

select
    commodity_type,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025,
    sum(year(event_datetime) = 2025)
        - sum(year(event_datetime) = 2024) as change_cases
from smuggling
where month(event_datetime) = 3
  and commodity_category = 'Amunicja'
group by commodity_type
order by change_cases desc;

-- where did the March increase in cases occur?
select
    location,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025,
    sum(year(event_datetime) = 2025)
        - sum(year(event_datetime) = 2024) as change_cases
from smuggling
where month(event_datetime) = 3
group by location
order by change_cases desc;

-- what types of cases drove the increase in the "kraj" location?

select
    location,
    commodity_category,
    commodity_type,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025,
    sum(year(event_datetime) = 2025)
        - sum(year(event_datetime) = 2024) as change_cases
from smuggling
where month(event_datetime) = 3 and location='kraj'
group by location, commodity_category, commodity_type
order by change_cases desc, commodity_category;

-- Checking items of the ‘Inna’ type for 'Broń' in March
select
    location,
    commodity_category,
    commodity_type,
    description,
    unit,
    quantity,
    value_PLN,
    border_guard_unit,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025,
    sum(year(event_datetime) = 2025)
        - sum(year(event_datetime) = 2024) as change_cases
from smuggling
where month(event_datetime) = 3 
	and location='kraj' 
	and commodity_category = 'Broń' 
	and commodity_type = 'Inna'
group by location, commodity_category, commodity_type, description,
	unit, quantity, value_PLN, border_guard_unit
order by change_cases desc, commodity_category;

-- checking the date of incidents
select
    event_datetime,
    location,
    commodity_category,
    commodity_type,
    description,
    unit,
    quantity,
    value_pln,
    border_guard_unit
from smuggling
where month(event_datetime) = 3
  and year(event_datetime) = 2025
  and location = 'kraj'
  and commodity_category = 'Broń'
  and commodity_type = 'Inna'
order by event_datetime;

-- What was seized in the March 6, 2025 incident?
select
	event_datetime,
	commodity_category,
	commodity_type,
	border_guard_unit,
	count(*),
	sum(quantity)
from smuggling
where event_datetime = '2025-03-06 07:48:00'
group by commodity_category, commodity_type, border_guard_unit
order by event_datetime;

-- How many records are in the event from 2025-03-06 07:48:00?
select
    count(*) as records
from smuggling
where event_datetime = '2025-03-06 07:48:00'; -- 156 records

-- Compare all timestamps from March 2025 for the “kraj” location
select
    event_datetime,
    count(*) as records
from smuggling
where year(event_datetime) = 2025
  and month(event_datetime) = 3
  and location = 'kraj'
group by event_datetime
order by records desc;
	

-- calculation of growth in March 2025 (compared to March 2024)
select
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025,
    sum(year(event_datetime) = 2025)
        - sum(year(event_datetime) = 2024) as change_cases,
    sum(event_datetime = '2025-03-06 07:48:00') as march_6_records
from smuggling
where month(event_datetime) = 3;

-- percentage share of records set on March 6, 2025, at 7:48 a.m., in the increase for March 2025

with march_stats as (
	select
	    sum(year(event_datetime) = 2024) as cases_2024,
	    sum(year(event_datetime) = 2025) as cases_2025,
	    sum(year(event_datetime) = 2025)
	        - sum(year(event_datetime) = 2024) as change_cases,
	    sum(event_datetime = '2025-03-06 07:48:00') as march_6_records
	from smuggling
	where month(event_datetime) = 3
)
select
	cases_2024,
	cases_2025,
	change_cases,
	march_6_records,
	march_6_records/change_cases * 100 as share_of_increase
from march_stats;
	


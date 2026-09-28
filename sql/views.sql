--  REQ1 : How did the number of smuggling cases change over time?

create view vw_smuggling_cases_monthly as
select
	month(event_datetime) as month_num,
	monthname(event_datetime) as month_name,
	sum(year(event_datetime) = 2024) as cases_2024,
	sum(year(event_datetime) = 2025) as cases_2025
from smuggling
group by month_num, month_name;

-- validation view
select *
from vw_smuggling_cases_monthly;


-- checking an increase smuggling relative to commodities (march and april) - view

create view vw_march_april_inrease_by_commodities as
select
	month(event_datetime) as month_num,
	monthname(event_datetime) as month_name,
	commodity_category,
	commodity_type,
	sum(year(event_datetime) = 2024) as cases_2024,
	sum(year(event_datetime) = 2025) as cases_2025
from smuggling
where month(event_datetime) in (3, 4)
group by month_num, month_name, commodity_category, commodity_type;



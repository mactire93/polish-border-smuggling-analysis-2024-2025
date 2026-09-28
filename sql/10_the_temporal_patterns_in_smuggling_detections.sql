select *
from smuggling;

-- the analysis of time patterns by day of the week
select 
	dayofweek(event_datetime) as day_of_week,
	dayname(event_datetime) as day_name,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025
from smuggling
group by day_of_week
order by day_of_week asc;

-- checking the average number of records per day of the week
select
	dayofweek(event_datetime) as day_of_week,
	dayname(event_datetime) as day_name,
	count(distinct date(event_datetime)) as days_count,
	count(*) as records_count,
	round(
		count(*)/count(distinct date(event_datetime)),
		2
	) as avg_rec_per_day
from smuggling
group by day_of_week, day_name 
order by day_of_week;

-- is the higher number of records falling on a Thursday present in both 2024 and 2025?
select
	year(event_datetime) as year,
	dayofweek(event_datetime) as day_of_week,
	dayname(event_datetime) as day_name,
	count(distinct date(event_datetime)) as days_count,
	count(*) as records_count,
	round(
		count(*)/count(distinct date(event_datetime)),
		2
	) as avg_rec_per_day
from smuggling
group by year, day_of_week, day_name 
order by year, day_of_week;

-- the analysis of time patterns by hours

select
	hour(event_datetime) as records_hour,
    sum(year(event_datetime) = 2024) as cases_2024,
    sum(year(event_datetime) = 2025) as cases_2025
from smuggling
group by records_hour
order by records_hour;

-- average number of records per hour (normalization of the result by the number of observations)

select
	hour(event_datetime) as records_hour,
    count(*) as records_count,
    count(distinct date(event_datetime)) as days_count,
    round(
    	count(*)/count(distinct date(event_datetime)),
    	2
    ) avg_rec_per_hour
from smuggling
group by records_hour
order by records_hour;

-- avg num of records per hour and years

select
	year(event_datetime) as year,
	hour(event_datetime) as records_hour,
    count(*) as records_count,
    count(distinct date(event_datetime)) as days_count,
    round(
    	count(*)/count(distinct date(event_datetime)),
    	2
    ) avg_rec_per_hour
from smuggling
group by year, records_hour
order by year, records_hour;

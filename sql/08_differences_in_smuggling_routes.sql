-- How do smuggling directions differ in terms of frequency and value?

select *
from smuggling;

-- analysis of the smuggling route relative to the 'direction' column

select
	direction,
	count(*) as records_count,
	round(
		count(*) / (select count(*) from smuggling) * 100,
		2
	) as pct_share_of_frequency,
	sum(value_PLN) as total_value,
	round(
		sum(value_PLN) / (select sum(value_PLN) from smuggling) * 100,
		2
	) as pct_share_of_value
from smuggling
group by direction
order by total_value desc;

-- analysis of the smuggling route relative to the 'direction' and 'location' columns

select
	direction,
	location,
	count(*) as records_count,
	round(
		count(*) / sum(count(*)) over (partition by direction) * 100,
		2
	) as pct_share_within_direction,
	sum(value_PLN) as total_value,
	round(
		sum(value_PLN) / sum(sum(value_PLN)) over (partition by direction) * 100,
		2
	) as pct_share_within_direction_value
from smuggling
group by direction, location
order by direction, total_value desc;

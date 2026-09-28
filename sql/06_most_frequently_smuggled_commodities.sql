-- What types of commodities are most frequently smuggled?

select *
from smuggling;

select
	commodity_category,
	commodity_type,
	count(*) as records_count,
	round(count(*)/(select count(*) from smuggling) * 100,
	2) as pct_share
from smuggling
group by commodity_category, commodity_type
order by records_count desc
limit 10;
-- Which types of smuggled commodities represent the highest estimated value?

select *
from smuggling;

-- which commodity categories represent the highest estimated value?
select
	commodity_category,
	round(sum(value_PLN), 2) as total_estimated_value,
	round(sum(value_PLN) / (select sum(value_PLN) from smuggling) * 100,
	2) as pct_share,
	count(*) as total_records
from smuggling
group by commodity_category
order by total_estimated_value desc;

-- calculating value_PLN for each commodity_category and commodity_type

select
	commodity_category,
	commodity_type,
	concat(commodity_category, ' - ', commodity_type) as commodity,
	round(sum(value_PLN), 2) as total_estimated_value,
	round(sum(value_PLN) / (select sum(value_PLN) from smuggling) * 100,
	2) as pct_share,
	count(*) as total_records
from smuggling
group by commodity_category, commodity_type
order by total_estimated_value desc;

-- checking for the highest value_PLN for records in dataset

SELECT
    value_PLN,
    commodity_category,
    commodity_type,
    quantity,
    unit,
    description,
    round(
    	value_PLN / (select sum(value_PLN) from smuggling) * 100,
    	2) as pct_share
FROM smuggling
WHERE value_PLN IS NOT NULL
ORDER BY value_PLN DESC
LIMIT 10;

-- What percentage of the total estimated value do the Top 10 records account for?

select
	round(sum(value_PLN), 2) as top10_value,
	round(
		sum(value_PLN) / (select sum(value_PLN) from smuggling) * 100,
		2) as top10_pct_share
from (
	select value_PLN
	from smuggling
	where value_PLN is not null
	order by value_PLN desc
	limit 10
) as top10;
	

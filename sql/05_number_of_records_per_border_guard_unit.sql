-- Which Border Guard units recorded the highest number of records?

select *
from smuggling;

-- checking which Border Huard Unit recorded the highest number of records
select
	border_guard_unit,
	count(*) as record_count
from smuggling
group by border_guard_unit
order by record_count desc;

-- calculating percentage share each border Guard units

select
	border_guard_unit,
	count(*) as record_count,
	round(count(*)/(select count(*) from smuggling) * 100,
	2) as ptc_share
from smuggling
group by border_guard_unit
order by ptc_share desc;

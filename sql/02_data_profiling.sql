select *
from smuggling;

/* profiling categorical columns:
direction
commodity_category
commodity_type
location
border_guard_unit
border_crossing
border_section
unit
cooperating_agency */

-- profiling direction column

select
	direction,
	count(*) as record_count
from smuggling
group by direction 
order by record_count desc;

-- checking for empty strings instead of null
select
    count(*) as empty_strings
from smuggling
where direction = ''; -- 3 records are empty strings

select
    count(*) as null_values
from smuggling
where direction is null;

-- profiling commodity_category column

select
	commodity_category,
	count(*) as record_count
from smuggling
group by commodity_category
order by record_count desc;	

-- profilling comodity_type column

select
	commodity_type,
	count(*) as record_count
from smuggling
group by commodity_type
order by record_count desc;	

-- crossing commodity_category and commodity_type column for 'inny', 'inna', 'inne', 'inna/inne' values

select
    commodity_category,
    commodity_type,
    count(*) as record_count
from smuggling
where commodity_type in ('inny', 'inna', 'inne', 'inna/inne')
group by
    commodity_category,
    commodity_type
order by
    commodity_category,
    commodity_type;

-- profilling location column

select
	location,
	count(*) as record_count
from smuggling
group by location
order by record_count desc;

-- profilling border_guard_unit column

select 
	border_guard_unit,
	count(*) as record_count
from smuggling
group by border_guard_unit
order by record_count desc;

-- profilling border_crossing column

select
	border_crossing,
	count(*) as record_count
from smuggling
group by border_crossing
order by record_count desc;

-- checking for spelling inconsistencies 

select
	border_crossing,
	count(*) as record_count
from smuggling
group by border_crossing
order by border_crossing asc;

-- make crossing with location to check missing values 
	
select
	border_crossing,
	location,
	count(*) as record_count
from smuggling
group by 
	border_crossing,
	location
order by 
	border_crossing,
	location;

-- make crossing with border_section to check missing values 

select
	border_crossing,
	border_section,
	count(*) as record_count
from smuggling
group by 
	border_crossing,
	border_section
order by 
	border_crossing,
	border_section;

-- make crossing with border_guard_post to check missing values 
select
    border_guard_post,
    count(*) as total_records,
    count(border_crossing) as records_with_crossing
from smuggling
group by border_guard_post
order by total_records desc;

-- additional checking for empty strings
select
    count(*) as total,
    count(border_crossing) as not_null_crossing
from smuggling;

select
    count(*) as empty_strings
from smuggling
where border_crossing = '';

select
    count(*) as null_values
from smuggling
where border_crossing is null;

-- profilling border_section column

select
	border_section,
	count(*) as record_count
from smuggling
group by border_section 
order by record_count;

-- additional checking null or empty strings
select
    count(*) as empty_strings
from smuggling
where border_section = '';

select
    count(*) as null_values
from smuggling
where border_section is null;

-- profilling border_guard_post column

select 
	border_guard_post,
	count(*) as record_count
from smuggling
group by border_guard_post 
order by record_count;

-- additional checking null or empty strings
select
    count(*) as empty_strings
from smuggling
where border_guard_post = '';

select
    count(*) as null_values
from smuggling
where border_guard_post is null;

-- profilling unit column
select
	unit,
	count(*) as record_count
from smuggling
group by unit
order by record_count;

-- additional checking null or empty strings
select
    count(*) as empty_strings
from smuggling
where unit = '';

select
    count(*) as null_values
from smuggling
where unit is null;

-- profilling cooperating_agency column

select 
	cooperating_agency,
	count(*) as record_count
from smuggling
group by cooperating_agency
order by record_count;

-- additional checking null or empty strings
select
    count(*) as empty_strings
from smuggling
where cooperating_agency = '';

select
    count(*) as null_values
from smuggling
where cooperating_agency is null;


/* profiling numerical columns:
event_datetime,
value_PLN,
quantity 
*/

-- profilling event_datetime column

-- checking min and max values
select
	min(event_datetime) as the_earliest_date,
	max(event_datetime) as the_latest_date
from smuggling;

-- checking null
select
    count(*) as null_values
from smuggling
where event_datetime is null;

-- checking years, months and days hours
select
	year(event_datetime) as event_year,
	count(*) as record_count
from smuggling
group by event_year
order by record_count;

select
	month(event_datetime) as event_month,
	count(*) as record_count
from smuggling
group by event_month
order by event_month;

select 
	weekday(event_datetime) as event_day,
	dayname(event_datetime) as event_dayname,
	count(*) as record_count
from smuggling
group by event_day, event_dayname
order by event_day asc;

select
	hour(event_datetime) as event_hour,
	count(*) as record_count
from smuggling
group by event_hour
order by event_hour asc;

-- profilling value_PLN column

-- descriptiv statistics
select
	min(value_PLN) as min_value_PLN,
	max(value_PLN) as max_value_PLN,
	avg(value_PLN) as avg_value_PLN,
	stddev(value_PLN) as stddev_value_PLN
from smuggling;

-- checking zero values 

select
	count(*) as record_count
from smuggling
where value_PLN = 0;

-- crossing with multiple columns for checking if zero values are reasonable

select
    commodity_category,
    commodity_type,
    unit,
    quantity,
    description
from smuggling
where value_PLN = 0;

-- checking null values
select
	count(*) as null_values
from smuggling
where value_PLN is null;

select
	count(*) as total_records,
	count(value_PLN) as records_with_value,
	sum(value_PLN is null) as missing_value,
	round(
		100 * sum(value_PLN is null)/count(*),
		2
	) as missing_percentage
from smuggling;
	

-- crossing with commodity_category and commodity_type for checking null values 
select
    commodity_category,
    commodity_type,
    count(*) as record_count
from smuggling
where value_PLN is null
group by commodity_category, commodity_type
order by record_count desc;

-- checking negative values
select
	count(*) as negative_values
from smuggling
where value_PLN < 0;

-- checking outliers for positive values 
-- because zero and null were retained as reasonable values
-- (details in project journal)

-- 1. checking statistics without zero and null
select
	count(*) as record_count,
    min(value_PLN) as min_value,
    max(value_PLN) as max_value,
    avg(value_PLN) as avg_value
from smuggling
where value_PLN is not null
  and value_PLN > 0;

-- 2. checking top 20 records to deterimne scale of the data

select
    value_PLN,
    commodity_category,
    commodity_type,
    quantity,
    unit,
    description
from smuggling
where value_PLN is not null
  and value_PLN > 0
order by value_PLN desc
limit 20;

-- calculating the median
with ranked as (
	select
		value_PLN,
		row_number() over (order by value_PLN) as rn,
		count(*) over () as total_count
	from smuggling
	where value_PLN is not null
		and value_PLN > 0
)
select
	avg(value_PLN) as median_value
from ranked
where rn in (
	floor((total_count + 1)/2),
	ceil((total_count + 1)/2)
);

-- q1, q3, iqr

with ranked as (
	select
		value_PLN,
		row_number() over (order by value_PLN) as rn,
		count(*) over () as total_count
	from smuggling
	where value_PLN is not null
		and value_PLN > 0
),
quartile_positions as(
	select distinct
		total_count,
		1 + (total_count - 1) * 0.25 as q1_pos,
		1 + (total_count - 1) * 0.75 as q3_pos
	from ranked
),
quartile_values as (
	select
		qp.q1_pos,
		qp.q3_pos,
	    max(
	    	case
			    when r.rn = floor(qp.q1_pos)
			    then r.value_PLN
		    end 
	    )as q1_lower,
	    max(
		    case
		        when r.rn = ceil(qp.q1_pos)
		        then r.value_PLN
		    end
	    ) as q1_upper,
	    qp.q1_pos - floor(qp.q1_pos) as q1_fraction,
	    max(
		    case
		        when r.rn = floor(qp.q3_pos)
		        then r.value_PLN
		    end
		) as q3_lower,
		max(
		    case
		        when r.rn = ceil(qp.q3_pos)
		        then r.value_PLN
		    end
		) as q3_upper,
		qp.q3_pos - floor(qp.q3_pos) as q3_fraction
	from ranked r
	cross join quartile_positions qp
	where r.rn in (
		floor(qp.q1_pos),
		ceil(qp.q1_pos),
		floor(qp.q3_pos),
		ceil(qp.q3_pos)
	)
	group by qp.q1_pos, qp.q3_pos
),
statistics as (
    select
        q1_lower + q1_fraction * (q1_upper - q1_lower) as q1,
        q3_lower + q3_fraction * (q3_upper - q3_lower) as q3
    from quartile_values
),
iqr_stats as (
	select
		q1,
		q3,
		q3 - q1 as iqr
	from statistics
),
bounds as (
	select
		q1,
		q3,
		iqr,
	    q1 - 1.5 * iqr as lower_bound,
        q3 + 1.5 * iqr as upper_bound
    from iqr_stats
),
outliers as (
	select
		s.*,
		b.upper_bound
	from smuggling s
	cross join bounds b
	where s.value_PLN > b.upper_bound
),
clean_data as (
	select
        s.*
    from smuggling s
    cross join bounds b
    where s.value_PLN is not null
      and s.value_PLN > 0
      and s.value_PLN <= b.upper_bound
)
select *
from bounds;

-- profilling quantity column
-- checking NULL, zero, positive and negative values
select
	count(*) as total_records,
	count(quantity) as quantity_filled,
	count(*) - count(quantity) as quantity_NULL,
	sum(quantity = 0) as quantity_zero,
	sum(quantity > 0) as quantity_positive,
	sum(quantity < 0) as quantity_negative
from smuggling;

-- checking zero values
select 
	event_datetime,
    commodity_category,
    commodity_type,
    value_PLN,
    quantity,
    unit,
    description
from smuggling
where quantity = 0;

-- crossing with unit to checking  for unusual values
select
    unit,
    count(*) as record_count,
    round(
        count(*) * 100.0 / sum(count(*)) over (),
        2
    ) as percentage
from smuggling
group by unit
order by record_count desc;

-- crossing with commodity_category and unit for checking data distribution
select
    commodity_category,
    unit,
    count(*) as record_count
from smuggling
group by commodity_category, unit
order by commodity_category, record_count desc;

-- checking statistics
select
	unit,
	count(*) as record_count,
    min(quantity) as min_value,
    max(quantity) as max_value,
    avg(quantity) as avg_value
from smuggling
group by unit;

-- checking max_value with several columns
select
    commodity_type,
    commodity_category,
    value_PLN,
    quantity,
    unit
from smuggling
where quantity = (select max(quantity) from smuggling);








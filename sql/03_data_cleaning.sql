-- Data Cleaning

-- making backup

CREATE TABLE smuggling_backup_02 LIKE smuggling;

INSERT INTO smuggling_backup_02 SELECT * FROM smuggling;

-- backup validation
select count(*)
from smuggling_backup_02;

select *
from smuggling_backup_02;



/* columns:
direction
location
border_guard_unit
border_guard_post
border_crossing
border_section
commodity_category
commodity_type
description
unit
cooperating_agency
 */


select
	count(*) as total_records,
	sum(direction is NULL) as direction_null,
	sum(trim(direction = '')) as direction_empty,
	sum(location is NULL) as location_null,
	sum(trim(location = '')) as location_empty,
	sum(border_guard_unit is NULL) as border_guard_unit_null,
	sum(trim(border_guard_unit = '')) as border_guard_unit_empty,	
	sum(border_guard_post is NULL) as border_guard_post_null,
	sum(trim(border_guard_post = '')) as border_guard_post_empty,	
	sum(border_crossing is NULL) as border_crossing_null,
	sum(trim(border_crossing = '')) as border_crossing_empty,	
	sum(border_section is NULL) as border_section_null,
	sum(trim(border_section = '')) as border_section_empty,	
	sum(commodity_category is NULL) as commodity_category_null,
	sum(trim(commodity_category = '')) as commodity_category_empty,	
	sum(commodity_type is NULL) as commodity_type_null,
	sum(trim(commodity_type = '')) as commodity_type_null,	
	sum(description is NULL) as description_null,
	sum(trim(description = '')) as description_null,
	sum(unit is NULL) as unit_null,
	sum(trim(unit = '')) as unit_null,
	sum(cooperating_agency is NULL) as cooperating_agency_null,
	sum(trim(cooperating_agency = '')) as cooperating_agency_null
from smuggling;

-- DIRECTION COLUMN

-- checking empty strings in direction column
SELECT
    event_datetime,
    direction,
    location,
    border_section,
    commodity_category,
    commodity_type,
    description
FROM smuggling
WHERE TRIM(direction) = '';

-- cleaning empty strings in direction column
update smuggling
set direction = 'not specified'
where trim(direction = '');

-- validation after changing
select 
	direction,
	count(*) as record_count
from smuggling
group by direction 
order by record_count desc;

-- BORDER_CROSSING COLUMN

-- cleansing data in border_crossing column

-- checking problem with inconsistent entries
select 
    trim(substring_index(border_crossing, '(', 1)) as clean_border_crossing,
    group_concat(distinct border_crossing separator '  |  ') as original_border_crossing,
    count(*) as total_records
from smuggling
where location = 'przejście'
group by clean_border_crossing
having count(distinct border_crossing) > 1; -- show only these groups where was problem with inconsistent entries

select 
    border_crossing as border_crossing_before,
    concat(
        trim(substring_index(border_crossing, '(', 1)), -- take the name before the parenthesis and remove the trailing spaces
        ' (',                                           -- insert a single space before the parenthesis
        lower(trim(replace(substring_index(border_crossing, '(', -1), ')', ''))), -- clear the inside of the parentheses and make the letters smaller
        ')'
    ) as border_crossing_after
from smuggling
where border_crossing like '%(%';

-- update inconsistent records
update smuggling
set border_crossing = concat (
	trim(substring_index(border_crossing, '(', 1)),
	' (',
	lower(trim(replace(substring_index(border_crossing, '(', -1), ')', ''))),
	')'
)
where border_crossing like '%(%';

-- validation after changing
select 
	border_crossing,
	count(*) as record_count
from smuggling
group by border_crossing 
order by record_count desc;

select *
from smuggling
where location = 'przejście' and border_crossing is null;

-- checking problem with differen dash characters

-- testing regexp for replacing unconsistent dash characters
select 
    border_crossing as przed,
    regexp_replace(replace(replace(border_crossing, '—', '-'), '–', '-'), '[[:space:]]*-[[:space:]]*', ' - ') as po
from smuggling
where border_crossing regexp '[-–—]';

-- replace unconsistent dash characters

update smuggling
set border_crossing = regexp_replace(
	replace(replace(border_crossing, '—', '-'), '–', '-'),
	'[[:space:]]*-[[:space:]]*',
	' - '
)
where border_crossing regexp '[-–—]';

-- changed data validation

select
	border_crossing,
	count(*) as record_count
from smuggling
group by border_crossing;

select
	count(*)
from smuggling;


-- update data with empty strings
update smuggling
set border_crossing = NULL
where trim(border_crossing = '');

-- validation after changing
select
	border_crossing,
	count(*) as record_count
from smuggling
group by border_crossing
order by record_count desc;

-- DESCRIPTION COLUMN

-- cleaning empty strings in description column
update smuggling
set description = NULL
where trim(description = '');

-- validation after changing
select 
	description,
	count(*) as record_count
from smuggling
group by description 
order by record_count desc;


-- value_PLN COLUMN

-- checking NULL values
select
	commodity_category,
	commodity_type,
	value_PLN,
	unit,
	quantity,
	description
from smuggling
where value_PLN is null;

select
	count(*)
from smuggling
where value_PLN is null;

-- checking zero values:

select
	commodity_category,
	commodity_type,
	value_PLN,
	unit,
	quantity,
	description
from smuggling
where value_PLN = 0;

select
	count(*)
from smuggling
where value_PLN = 0;






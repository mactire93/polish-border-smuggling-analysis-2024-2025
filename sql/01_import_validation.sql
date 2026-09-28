-- checking rows count

select count(*) as row_count
from smuggling; -- result: 6626, ok

-- checking table structure

describe smuggling;

-- checking date range

select
	MIN(event_datetime) as min_date,
	MAX(event_datetime) as max_date
from smuggling;

-- checking numeric range

select * from smuggling;

select
	min(value_PLN) as min_value_PLN,
	max(value_PLN) as max_value_	PLN,
	min(quantity) as min_quantity,
	max(quantity) as max_quantity
from smuggling;

-- checking null values


SELECT GROUP_CONCAT(
    CONCAT('COUNT(*) - COUNT(', COLUMN_NAME, ') AS NULL_', COLUMN_NAME)
) AS generated_query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'smuggling' 
  AND TABLE_SCHEMA = 'border_smuggling_2024_2025';

select
	COUNT(*) - COUNT(event_datetime) AS NULL_event_datetime,COUNT(*) - COUNT(direction) AS NULL_direction,COUNT(*) - COUNT(location) AS NULL_location,COUNT(*) - COUNT(border_guard_unit) AS NULL_border_guard_unit,COUNT(*) - COUNT(border_guard_post) AS NULL_border_guard_post,COUNT(*) - COUNT(border_crossing) AS NULL_border_crossing,COUNT(*) - COUNT(border_section) AS NULL_border_section,COUNT(*) - COUNT(commodity_category) AS NULL_commodity_category,COUNT(*) - COUNT(commodity_type) AS NULL_commodity_type,COUNT(*) - COUNT(value_PLN) AS NULL_value_PLN,COUNT(*) - COUNT(description) AS NULL_description,COUNT(*) - COUNT(unit) AS NULL_unit,COUNT(*) - COUNT(quantity) AS NULL_quantity,COUNT(*) - COUNT(cooperating_agency) AS NULL_cooperating_agency
from smuggling;
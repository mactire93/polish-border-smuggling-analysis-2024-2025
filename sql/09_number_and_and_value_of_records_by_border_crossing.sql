-- Which border crossings recorded the highest number and value of smuggling cases?

select *
from smuggling;

-- analysis of number and total values of records

select
	border_crossing,
	count(*) as records_count,
	sum(value_PLN) as total_value
from smuggling
where border_crossing is not null and border_crossing <> 'nie dotyczy'
group by border_crossing
order by total_value desc;

-- checking how the names of all border crossings are written
select distinct
    border_crossing
from smuggling
where border_crossing is not null
  and border_crossing <> ''
order by border_crossing;

-- test of column transformation
select distinct
    border_crossing,
    case
        when border_crossing like '%(%)'
        then substring_index(
            substring_index(border_crossing, '(', -1),
            ')',
            1
        )
        else 'none'
    end as crossing_type
from smuggling
where border_crossing is not null
  and border_crossing <> ''
order by crossing_type, border_crossing;

-- test to see if removing parentheses will merge records with the same name
select
    case
        when border_crossing like '%(%)'
        then trim(
            substring_index(border_crossing, '(', 1)
        )
        else border_crossing
    end as border_crossing_clean,
    count(*) as records_count
from smuggling
where border_crossing is not null
  and border_crossing <> ''
group by border_crossing_clean
order by records_count desc;

-- data verification for ‘Kuźnica Białostocka - Bruzgi’ and 'Warszawa/Modlin''
select
    border_crossing,
    border_guard_unit,
    location,
    count(*) as records_count
from smuggling
where border_crossing in (
    'warszawa/modlin',
    'warszawa - modlin',
    'kuźnica - bruzgi',
    'kuźnica białostocka - bruzgi'
)
group by
    border_crossing,
    border_guard_unit,
    location
order by
    border_crossing,
    records_count desc;

-- checking how many records there are for Warszawa/Modlin, Warszawa–Modlin, Kuźnica–Bruzgi, and Kuźnica Białostocka–Bruzgi
select
    border_crossing,
    count(*) as records_count
from smuggling
where lower(border_crossing) in (
    'warszawa/modlin',
    'warszawa - modlin',
    'kuźnica - bruzgi',
    'kuźnica białostocka - bruzgi'
)
group by border_crossing
order by records_count desc;

-- STANDARDIZATION AND ANALYSIS

with base as(
	select
		case
			when border_crossing is null
				or trim(border_crossing) = ''
				then 'Unknown'
			else  trim(
				substring_index(border_crossing, '(', 1)
			)
		end as border_crossing_clean,
		value_PLN
	from smuggling
),
normalized as (
	select
		case
			when border_crossing_clean = 'Warszawa/Modlin'
				then 'Warszawa - Modlin'			 
		 	when border_crossing_clean = 'Kuźnica - Bruzgi'
		 		then 'Kuźnica Białostocka - Bruzgi'
			else border_crossing_clean
	 	end as border_crossing_clean,
	 	value_PLN
 	from base
)
select
	border_crossing_clean,
	count(*) as records_count,
	sum(value_PLN) as total_value_PLN
from normalized
group by border_crossing_clean 
order by records_count desc;


-- verifying the accuracy of the results from the first stage of cleaning 

with base as (
    select
        case
            when border_crossing is null
                or trim(border_crossing) = ''
                then 'unknown'
            else trim(
                substring_index(border_crossing, '(', 1)
            )
        end as border_crossing_clean
    from smuggling
)
select
    border_crossing_clean,
    count(*) as records_count
from base
where border_crossing_clean in (
    'dorohusk - jagodzin',
    'terespol - brześć',
    'korczowa - krakowiec'
)
group by border_crossing_clean
order by records_count desc;

-- what values were in the source column, and how many records were there in each one?
select
    border_crossing,
    count(*) as records_count
from smuggling
where
    border_crossing like 'dorohusk - jagodzin%'
    or border_crossing like 'terespol - brześć%'
    or border_crossing like 'korczowa - krakowiec%'
group by border_crossing
order by border_crossing;
/*
 Dorohusk - Jagodzin	367
Dorohusk - Jagodzin (drogowe)	280
(total: 647)
Korczowa - Krakowiec	291
Korczowa - Krakowiec (drogowe)	79
(total: 370)
Terespol - Brześć	329
Terespol - Brześć (drogowe)	213
Terespol - Brześć (kolej)	6
(total: 548)
the data matches the result of the previous script
*/

-- validating data from manual mapping

-- verification of original data
select
    border_crossing,
    count(*) as records_count
from smuggling
where border_crossing in (
    'warszawa/modlin',
    'warszawa/modlin (lotnicze)',
    'warszawa - modlin',
    'warszawa - modlin (lotnicze)',
    'kuźnica - bruzgi',
    'kuźnica - bruzgi (drogowe)',
    'kuźnica białostocka - bruzgi',
    'kuźnica białostocka - bruzgi (drogowe)'
)
group by border_crossing
order by border_crossing;

/*
results:
Kuźnica - Bruzgi (drogowe)	3
Kuźnica Białostocka - Bruzgi	2
(total: 5)
Warszawa - Modlin (lotnicze)	5
Warszawa/Modlin	9
Warszawa/Modlin (lotnicze)	9
(total: 23)

*/

-- veryfication cleaned data
with base as(
	select
		case
			when border_crossing is null
				or trim(border_crossing) = ''
				then 'Unknown'
			else  trim(
				substring_index(border_crossing, '(', 1)
			)
		end as border_crossing_clean,
		value_PLN
	from smuggling
),
normalized as (
	select
		case
			when border_crossing_clean = 'Warszawa/Modlin'
				then 'Warszawa - Modlin'			 
		 	when border_crossing_clean = 'Kuźnica - Bruzgi'
		 		then 'Kuźnica Białostocka - Bruzgi'
			else border_crossing_clean
	 	end as border_crossing_clean,
	 	value_PLN
 	from base
)
select
	border_crossing_clean,
	count(*) as records_count
from normalized
where border_crossing_clean in (
	'Warszawa - Modlin',
	'Kuźnica Białostocka - Bruzgi'
)
group by border_crossing_clean 
order by records_count desc;
/*
results:
Warszawa - Modlin	23
Kuźnica Białostocka - Bruzgi	5
the transformation was succesfull
*/

-- checking the completeness of data
with base as(
	select
		case
			when border_crossing is null
				or trim(border_crossing) = ''
				then 'Unknown'
			else  trim(
				substring_index(border_crossing, '(', 1)
			)
		end as border_crossing_clean,
		value_PLN
	from smuggling
),
normalized as (
	select
		case
			when border_crossing_clean = 'Warszawa/Modlin'
				then 'Warszawa - Modlin'			 
		 	when border_crossing_clean = 'Kuźnica - Bruzgi'
		 		then 'Kuźnica Białostocka - Bruzgi'
			else border_crossing_clean
	 	end as border_crossing_clean,
	 	value_PLN
 	from base
)
select
	count(*) as records_count
from normalized;
-- result: 6626 records, the data is complete

-- RESPONDING TO AN ANALYSIS REQUEST
-- Which border crossings recorded the highest number and value of smuggling cases?

with base as(
	select
		case
			when border_crossing is null
				or trim(border_crossing) = ''
				then 'Unknown'
			else  trim(
				substring_index(border_crossing, '(', 1)
			)
		end as border_crossing_clean,
		value_PLN
	from smuggling
),
normalized as (
	select
		case
			when border_crossing_clean = 'Warszawa/Modlin'
				then 'Warszawa - Modlin'			 
		 	when border_crossing_clean = 'Kuźnica - Bruzgi'
		 		then 'Kuźnica Białostocka - Bruzgi'
			else border_crossing_clean
	 	end as border_crossing_clean,
	 	value_PLN
 	from base
),
filtered as(
	select
		border_crossing_clean,
		value_PLN
	from normalized
	where border_crossing_clean not in ('Unknown', 'nie dotyczy')
)
select
	border_crossing_clean,
	count(*) as records_count,
	round(
		count(*) / (select count(*) from filtered) * 100,
        2
    ) as records_pct,
	sum(value_PLN) as total_value_PLN,
	round(
		sum(value_PLN) / (select sum(value_PLN) from filtered) * 100,
        2
	) as value_pct
from filtered
group by border_crossing_clean 
order by records_count desc;
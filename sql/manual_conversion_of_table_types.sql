-- Manual conversion of table types

-- Creation of smuggling_raw
CREATE TABLE smuggling_raw (
    event_datetime VARCHAR(50),
    direction VARCHAR(250),
    location VARCHAR(250),
    border_guard_unit VARCHAR(250),
    border_guard_post VARCHAR(250),
    border_crossing VARCHAR(250),
    border_section VARCHAR(250),
    commodity_category VARCHAR(250),
    commodity_type VARCHAR(250),
    value_PLN VARCHAR(100),
    description TEXT,
    unit VARCHAR(50),
    quantity VARCHAR(100),
    cooperating_agency VARCHAR(250)
);


-- Imported Data Test
SELECT
    value_PLN,
    quantity,
    description
FROM smuggling_raw
WHERE description LIKE '%Peugeot 3008%';

-- Test for Correct Decimal Limiter Conversion
SELECT
    value_PLN AS raw_value,
    REPLACE(TRIM(value_PLN), ',', '.') AS converted_value,
    quantity AS raw_quantity,
    REPLACE(TRIM(quantity), ',', '.') AS converted_quantity,
    description
FROM smuggling_raw
WHERE description LIKE '%Peugeot 3008%';


-- Empty Value Test
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN NULLIF(TRIM(value_PLN), '') IS NULL THEN 1 ELSE 0 END) AS empty_value,
    SUM(CASE WHEN NULLIF(TRIM(quantity), '') IS NULL THEN 1 ELSE 0 END) AS empty_quantity
FROM smuggling_raw;

-- Test for Outlier Values
SELECT
    value_PLN
FROM smuggling_raw
WHERE NULLIF(TRIM(value_PLN), '') IS NOT NULL
  AND TRIM(value_PLN) NOT REGEXP '^[0-9]+([,][0-9]+)?$';


SELECT
    quantity
FROM smuggling_raw
WHERE NULLIF(TRIM(quantity), '') IS NOT NULL
  AND TRIM(quantity) NOT REGEXP '^[0-9]+([,][0-9]+)?$';

-- Test for converting from varchar to decimal
SELECT
    value_PLN AS raw_value,
    CAST(
        REPLACE(TRIM(value_PLN), ',', '.')
        AS DECIMAL(65,30)
    ) AS converted_value,
    quantity AS raw_quantity,
    CAST(
        REPLACE(TRIM(quantity), ',', '.')
        AS DECIMAL(65,30)
    ) AS converted_quantity,
    description
FROM smuggling_raw
WHERE NULLIF(TRIM(value_PLN), '') IS NOT NULL
LIMIT 20;

-- Conversion test across the entire dataset (value_PLN)
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN NULLIF(TRIM(value_PLN), '') IS NULL THEN 1
            ELSE 0
        END
    ) AS null_values,
    SUM(
        CASE
            WHEN NULLIF(TRIM(value_PLN), '') IS NOT NULL
             AND CAST(
                    REPLACE(TRIM(value_PLN), ',', '.')
                    AS DECIMAL(65,30)
                 ) = 0
            THEN 1
            ELSE 0
        END
    ) AS zero_values,
    SUM(
        CASE
            WHEN NULLIF(TRIM(value_PLN), '') IS NOT NULL
             AND CAST(
                    REPLACE(TRIM(value_PLN), ',', '.')
                    AS DECIMAL(65,30)
                 ) > 0
            THEN 1
            ELSE 0
        END
    ) AS positive_values
FROM smuggling_raw;

-- Conversion Test On The Entire Set (Quantity)

SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN NULLIF(TRIM(quantity), '') IS NULL THEN 1
            ELSE 0
        END
    ) AS null_values,
    SUM(
        CASE
            WHEN NULLIF(TRIM(quantity), '') IS NOT NULL
             AND CAST(
                    REPLACE(TRIM(quantity), ',', '.')
                    AS DECIMAL(65,30)
                 ) = 0
            THEN 1
            ELSE 0
        END
    ) AS zero_values,
    SUM(
        CASE
            WHEN NULLIF(TRIM(quantity), '') IS NOT NULL
             AND CAST(
                    REPLACE(TRIM(quantity), ',', '.')
                    AS DECIMAL(65,30)
                 ) > 0
            THEN 1
            ELSE 0
        END
    ) AS positive_values
FROM smuggling_raw;

describe smuggling_raw;

-- Table Type Conversion Test
SELECT
    STR_TO_DATE(
        TRIM(event_datetime),
        '%d.%m.%Y %H:%i:%s'
    ) AS converted_datetime,
    direction,
    location,
    CASE
        WHEN NULLIF(TRIM(value_PLN), '') IS NULL THEN NULL
        ELSE CAST(
            REPLACE(TRIM(value_PLN), ',', '.')
            AS DECIMAL(65,30)
        )
    END AS converted_value,
    description,
    unit,
    CASE
        WHEN NULLIF(TRIM(quantity), '') IS NULL THEN NULL
        ELSE CAST(
            REPLACE(TRIM(quantity), ',', '.')
            AS DECIMAL(65,30)
        )
    END AS converted_quantity,
    cooperating_agency
FROM smuggling_raw
LIMIT 20;

-- Delete the “smuggling” Table
drop table smuggling;

-- Manually Creating a Table with The Correct Data Types

CREATE TABLE smuggling AS
SELECT
    STR_TO_DATE(
        NULLIF(TRIM(event_datetime), ''),
        '%d.%m.%Y %H:%i:%s'
    ) AS event_datetime,
    direction,
    location,
    border_guard_unit,
    border_guard_post,
    border_crossing,
    border_section,
    commodity_category,
    commodity_type,
    CASE
        WHEN NULLIF(TRIM(value_PLN), '') IS NULL THEN NULL
        ELSE CAST(
            REPLACE(TRIM(value_PLN), ',', '.')
            AS DECIMAL(65,30)
        )
    END AS value_PLN,
    description,
    unit,
    CASE
        WHEN NULLIF(TRIM(quantity), '') IS NULL THEN NULL
        ELSE CAST(
            REPLACE(TRIM(quantity), ',', '.')
            AS DECIMAL(65,30)
        )
    END AS quantity,
    cooperating_agency
FROM smuggling_raw;

describe smuggling;

-- Data Validity Check
-- Using a Detected Error as an Example

SELECT
    value_PLN,
    quantity,
    description
FROM smuggling
WHERE description LIKE '%Peugeot 3008%';

-- Checking The Number of Records

SELECT COUNT(*) AS record_count
FROM smuggling;

-- Checking for NULL values

SELECT
    COUNT(*) AS total_records,
    SUM(value_PLN IS NULL) AS null_value,
    SUM(quantity IS NULL) AS null_quantity
FROM smuggling;

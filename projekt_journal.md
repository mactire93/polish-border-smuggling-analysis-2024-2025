# Project Journal



## 2026-07-08



### 

### Dataset



Source:

https://dane.gov.pl

\---



### Data preparation



#### Issue 1



A trailing empty column was present in the source workbook.



Decision:

Removed before CSV export because it contained no data.



\---



#### Issue 2



The workbook contained a helper column ("Rodzaje organów współdziałających zamieniacz SG") generated with an Excel formula.



Decision:

Excluded from the analysis because it duplicated information and was not required for the business questions.



\---



#### Issue 3

The source workbook stores the event timestamp as a full datetime value.



Observation:

The loss of time information occurred during CSV export or MySQL import and will be investigated before analysis.



Solution:

Change the custom format in the xlsx file before importing it to CSV. Add hh:mm:ss (the Polish version of the file uses gg:mm:ss).



\---



#### Issue 4



The column 'wartość \[zł] za 1 szt. / za 1 kg towaru'  could not be imported into SQL as a DECIMAL due to the data format and the #DIV/0! error in the xlsx spreadsheet.



Decision:

The column 'wartość \[zł] za 1 szt. / za 1 kg towaru' was excluded from the analysis because it was a calculated field based on an Excel formula. It contained an error resulting from division by zero and did not provide any information that could not be derived from the 'wartość', 'ilość' i jednostka miary' columns.





### Import



Source file:

C:\\Data Analysis Projects\\border\_smuggling\_analysis\_2024-2025\_PL\\data\\processed\\przemyt\_2024\_2025\_import.csv



##### Target database:

border\_smuggling\_2024\_2025



##### Target table:

smuggling\_raw



##### Import settings:



Delimiter:

Semicolon (;)



Encoding:

UTF-8



Date format:

dd.MM.yyyy HH:mm:ss



##### Import decisions:



Column names changing:



| CSV                               | SQL                |

| --------------------------------- | ------------------ |

| data Czas Rozpoczecia             | event\_datetime     |

| kierunek                          | direction          |

| miejsce                           | location           |

| OSG                               | border\_guard\_unit  |

| PSG                               | border\_guard\_post  |

| PG                                | border\_crossing    |

| Odcienk granicy                   | border\_section     |

| rodzaj towaru                     | commodity\_category |

| typ towaru                        | commodity\_type     |

| wartość                           | value\_pln          |

| opis                              | description        |

| JEDNOSTKA MIARY                   | unit               |

| ILOŚĆ                             | quantity           |

| Rodzaje organów współdziałających | cooperating\_agency |





##### Import Validation:



Validation started.



Checks:

\- Row count

\- Column count

\- Data types

\- Date range

\- Numeric range

\- NULL values



Row count

Result: 6626 rows, passed.



Column count

Result: 14 column, passed.



Data types

Every data types are correct, passed.



Date range

min date 2024-01-01 07:10:00,

max date 2025-12-30 18:30:00.

Passed.



Numeric range

min value PLN: 0,

max value PLN: 7000000000.00,

min quantity: 0,

max quantity: 127433800000.00

no negative values.

Passed.



NULL values



null value\_PLN: 542,

other columns: 0





##### **Issues:**



Data quality issue discovered during Data Profiling:

Systematic numerical transformation error detected in value\_PLN and quantity. Decimal separators from the source data were not interpreted correctly during CSV import, causing decimal digits to be appended to integer values. The issue affects the entire dataset.



Decision:

Stop numerical profiling and correct the import process before continuing Data Profiling. Do not modify the imported values manually in SQL.



###### **Data Import Validation — value\_PLN and quantity**



During data validation, an import error was identified in the `smuggling` table.



The original CSV contained decimal values using a comma as the decimal separator:

\- value\_PLN: `190000,00`

\- quantity: `1,0000`



After the initial import, these values were incorrectly transformed:

\- value\_PLN: `19000000`

\- quantity: `10`



The error affected all records containing numeric values and resulted in incorrect multiplication of the original values.



The issue was caused by the CSV import process rather than the source data.



###### **RAW Data Layer**



To prevent further data corruption during import, the CSV was imported into a separate staging table: `smuggling\\\\\\\_raw`.



The following columns were intentionally stored as VARCHAR:

\- event\_datetime

\- value\_PLN

\- quantity



This allowed the original CSV values to be preserved and the conversions to be controlled explicitly in SQL.



The original `smuggling` table containing incorrectly converted values was replaced.



###### **Data Transformation and Validation**



Data was converted from `smuggling\_raw` into the final `smuggling` table using explicit SQL transformations.



Conversions:

\- event\_datetime → DATETIME

\- value\_PLN → DECIMAL

\- quantity → DECIMAL

\- comma decimal separators were converted to dots

\- empty numeric values were converted to NULL



Example validation:



Original:

`190000,00` → `190000.00`

`1,0000` → `1.0000`



The Peugeot 3008 record was used as a test case and confirmed that the conversion was correct.



###### **Import Validation — Final Checks**



Record count:

6,626 records



NULL values:

\- value\_PLN: 542

\- quantity: 0



The number of records remained unchanged after transformation.



The final `smuggling` table contains correctly converted numeric and datetime values.



Decision:

The import/transformation issue has been resolved. The dataset is ready for further profiling.



###### **Data Quality Decision**



The incorrect values were not treated as outliers because they were caused by an import/transformation error.



The source CSV was verified and the transformation logic was corrected before continuing with data profiling.



Outlier analysis will be performed only on the corrected `smuggling` table.







### Data Profiling



##### Goal



Understand the structure, quality and distribution of the dataset before cleaning and analysis.



\---



##### Findings



###### **Column: direction:**



* Category distribution:

  * wewnątrz kraju	2762
  * do RP	2703
  * z RP	1158
* 3 records contain empty strings



the 'direction' column contain a small number of missing values (3 records).

These records should be reviewed during the Data Cleaning stage.

Manual inspection of the source Excel file confirmed that these values are also missing in the original dataset.



**Decision:**

**During Data Cleaning stage, consider assigning the name 'not specified' to facilitate a clear analysis.**



\---



**Column: commodity\_category**



* Category distribution:

  * Papierosy	2246
  * Pojazdy	871
  * Inne	815
  * Narkotyki	797
  * Amunicja	751
  * Broń	386
  * Tytoń	378
  * Alkohol	243
  * Waluta	75
  * Płyn do e-papierosów	44
  * Odpady i materiały szkodliwe bądź promieniotwórcze	11
  * Zabytki	4
  * Materiały niebezpieczne	3
  * Nośniki	2
* No missing values found.
* No spelling inconsistencies detected.
* Cigarettes are most common category of contraband.



**Decision:**

**No cleaning required**



\---



**Column: commodity\_type**



* Category distribution:

  * Papierosy	2246
  * inna/inne	695
  * Ostra	667
  * Osobowy	604
  * Inne	421
  * Marihuana	385
  * Inna	262
  * Wódka	151
  * Podzespoły samochodowe	137
  * krajanka tytoniowa	122
  * Amfetamina	92
  * Tytoń do palenia	89
  * susz tytoniowy	71
  * Tytoń do palenia (wkłady)	64
  * Inny	60
  * Ciężarowy	53
  * Złoty - PLN	52
  * Kokaina	46
  * Płyn do e-papierosów	44
  * Palna	43
  * Motocykl	42
  * Naczepa	42
  * Haszysz	38
  * Tytoń	32
  * Spirytus	32
  * Extasy	26
  * Gazowa	20
  * Euro - EUR	18
  * Anaboliki	14
  * Bursztyn	8
  * Koniak	8
  * Whisky	6
  * Granat	5
  * Dolar amerykański - USD	5
  * LSD	5
  * Wino	5
  * Grzyby halucynogenne	4
  * Ikona	3
  * Heroina	3
  * Materiały wybuchowe	3
  * Likier	2
  * RTV	1
* No missing values found.
* Commodity types have different levels of granularity.
* The labels "Inna", "Inne", "Inny" and 'inna/inne' are associated with different commodity categories and appear to represent category-specific descriptions rather than inconsistent data.



**Decison:**

**No cleaning required**



**---**



**Column: location**



* Category distribution:

  * przejście	3513
  * kraj	1889
  * strefa	1224
* No missing values found.
* No spelling inconsistencies detected.



**Decision:**

**No cleaning required**



**---**



Column: border\_guard\_unit



* Category distribution:

  * Nadbużański	2831
  * Bieszczadzki	1338
  * Nadodrzański	617
  * Podlaski	455
  * Morski	386
  * Warmińsko-Mazurski	313
  * Śląski	284
  * Nadwiślański	226
  * Karpacki	176
* No missing values found.
* No spelling inconsistencies detected.



**Decision:**

**No cleaning required**



\---



Column: border\_crossing



* Category distribution:

  * &#x09;NULL 2711
  * nie dotyczy	367
  * Dorohusk - Jagodzin	345
  * Dorohusk – Jagodzin (drogowe)	280
  * Korczowa - Krakowiec	271
  * Terespol – Brześć (drogowe)	213
  * Terespol - Brześć	200
  * Medyka - Szeginie	150
  * Hrebenne - Rawa Ruska	142
  * Terespol – Brześć	129
  * Dołhobyczów - Uhrynów	120
  * Hrebenne – Rawa Ruska (drogowe)	110
  * Medyka – Szeginie (drogowe)	98
  * Zosin - Ustiług	88
  * Kukuryki – Kozłowiczy (drogowe)	84
  * Kukuryki - Kozłowiczy	80
  * Korczowa – Krakowiec (drogowe)	79
  * Rzeszów-Jasionka	69
  * Warszawa-Okęcie	69
  * Dołhobyczów – Uhrynów (drogowe)	60
  * Gdynia (morskie)	59
  * Warszawa-Okęcie (lotnicze)	49
  * Katowice-Pyrzowice (lotnicze)	48
  * Zosin – Ustiług (drogowe)	48
  * Katowice-Pyrzowice	44
  * Rzeszów-Jasionka (lotnicze)	44
  * Poznań-Ławica (lotnicze)	44
  * Budomierz - Hruszew	42
  * Hrebenne – Rawa Ruska	37
  * Kraków-Balice (lotnicze)	30
  * Zosin – Ustiług	28
  * Kraków-Balice	28
  * Poznań-Ławica	27
  * Bezledy – Bagrationowsk	27
  * Dołhobyczów – Uhrynów	23
  * Dorohusk – Jagodzin	22
  * Grzechotki – Mamonowo II (drogowe)	21
  * Kukuryki – Kozłowiczy	21
  * Korczowa – Krakowiec	20
  * Medyka – Szeginie	18
  * Grzechotki - Mamonowo II	18
  * Malhowice - Niżankowice	16
  * Przemyśl - Mościska	14
  * Warszawa-Okęcie(Lotnicze)	14
  * Bezledy – Bagrationowsk (drogowe)	13
  * Budomierz – Hruszew (drogowe)	13
  * Krościenko - Smolnica	12
  * Kraków-Balice(Lotnicze)	12
  * Poznań-Ławica(Lotnicze)	10
  * Świdnik k/Lublina	9
  * Warszawa/Modlin	9
  * Warszawa/Modlin (lotnicze)	9
  * Świecko – Frankfurt	9
  * Krościenko – Smolnica (drogowe)	8
  * Świnoujście	8
  * Wrocław-Strachowice	7
  * Słubice – Frankfurt nad Odrą	7
  * Przemyśl – Mościska (kolejowe)	6
  * Bezledy - Bagrationowsk	6
  * Terespol – Brześć(Kolej)	6
  * Budomierz – Hruszew	6
  * Warszawa-Modlin(Lotnicze)	5
  * Świecko - Frankfurt	4
  * Hrebenne – Rawa Ruska(Kolej)	4
  * Gdańsk-Rębiechowo (lotnicze)	4
  * Gubinek – Guben	4
  * Zielona Góra-Babimost	4
  * Rzeszów-Jasionka(Lotnicze)	4
  * Kuźnica – Bruzgi (drogowe)	3
  * Katowice-Pyrzowice(Lotnicze)	3
  * Bobrowniki - Bierestowica	3
  * Łódź-Lublinek (lotnicze)	2
  * Przemyśl – Mościska(Kolej)	2
  * Jędrzychowice – Ludwigsdorf	2
  * Świdnik k/Lublina(Lotnicze)	2
  * Ogrodniki – Lazdijaj	2
  * Radoszyce – Palota	2
  * Kuźnica Białostocka - Bruzgi	2
  * Świdnik k/Lublina (lotnicze)	1
  * Grzechotki – Mamonowo II	1
  * Gdańsk-Port	1
  * Warszawa-Babice(Lotnicze)	1
  * Wrocław-Strachowice (lotnicze)	1
  * Wrocław-Strachowice(Lotnicze)	1
  * Bobrowniki – Bierestowica	1
  * Siemianówka - Świsłocz	1
  * Mazury	1
  * Bydgoszcz (lotnicze)	1
  * Kostrzyn nad Odrą – Kietz	1
  * Hrubieszów - Włodzimierz Wołyński	1
  * Zgorzelec – Görlitz	1
  * Burbiszki	1
  * Gdynia	1
  * Hrubieszów – Włodzimierz Wołyński (kolejowe)	1
  * Budzisko	1
* 2711 missing values detected.

  * 1659 missing values are associated with location = 'kraj',
  * 1023 missing values are associated with locaton = 'strefa',
  * 29 missing values are associated with location = 'przejście',
  * 2711 missing values are not 'NULL" but empty strings ''.
* Several naming inconsistencies identified.
* Different dash characters (- / –).
* Different spacing before parentheses.
* Different capitalization ("Lotnicze" vs "lotnicze").
* Some border crossings include transport type in parentheses while others do not.
* Cross-column profiling between border\_crossin and border\_section suggests that missing border crossings may represent valid business cases rather than missing informaton, however, records with location = 'przejście' and missing border crossing required further investigation.



**Decision:**

**Further investigation required before standardization.**



**The meaning of suffixes such as "(drogowe)", "(kolejowe)" and "(lotnicze)" should be verified to determine whether they represent distinct border crossings or inconsistent naming.**



**The 2711 records should be changed to NULL values first. It's SQL standard and empty strings will skew the results.**



**The 29 records should be manually reviewed during the Data Cleaning stage to determine whether the missing border crossing represents inclomplete data or a valid business case.**





**---**



Column: border\_section



* Category distribution:

  * Słowacja	14
  * Litwa	32
  * Czechy	65
  * morska	93
  * Rosja	109
  * Niemcy	181
  * lotnicza	636
  * Białoruś	1204
  * wewnątrz kraju	1889
  * Ukraina	2403
* no missing values found



**Decison:**

**No cleaning required**



**---**



Column: border\_guard\_post



* Category distribution:

  * PSG w Horyńcu-Zdroju	1
  * PSG w Skryhiczynie	1
  * PSG w Huwnikach	1
  * PSG w Lubyczy Królewskiej	1
  * PSG w Częstochowie	1
  * PSG w Opolu	1
  * Nadodrzański	2
  * PSG w Dubiczach Cerkiewnych	2
  * PSG w Legnicy	2
  * PSG w Sanoku	3
  * PSG w Bydgoszczy	3
  * PSG w Gorzowie Wielkopolskim	3
  * PSG w Bielsku-Białej	3
  * Warmińsko-Mazurski	4
  * PSG w Słubicach	4
  * PSG w Janowie Podlaskim	4
  * PSG w Krakowie	5
  * Morski	6
  * PSG w Płaskiej	7
  * PSG w Węgorzewie	7
  * PSG w Michałowie	7
  * PSG w Kodniu	8
  * PSG w Woli Uhruskiej	8
  * Nadwiślański	9
  * Podlaski	9
  * Nadbużański	10
  * PSG w Łodzi	10
  * PSG w Lipsku	10
  * PSG w Krynkach	11
  * PSG w Mielniku	11
  * PSG w Tarnowie	11
  * PSG w Bohukałach	11
  * PSG w Warszawie	12
  * PSG w Zielonej Górze-Babimoście	12
  * PSG w Dołhobrodach	12
  * PSG w Sejnach	13
  * PSG we Włodawie	13
  * PSG w Szudziałowie	14
  * PSG w Białowieży	15
  * PSG w Czeremsze	18
  * PSG w Olsztynie	18
  * PSG w Narewce	18
  * PSG w Sosnowcu	20
  * PSG w Szczecinie	20
  * PSG w Rudzie Śląskiej	22
  * PSG we Władysławowie	22
  * PSG w Rutce-Tartak	22
  * PSG w Kielcach	23
  * PSG w Jeleniej Górze	23
  * Śląski	23
  * PSG w Tuplicach	23
  * PSG w Białej Podlaskiej	24
  * Karpacki	25
  * PSG w Zakopanem	26
  * PSG w Warszawie-Modlinie	30
  * PSG we Wrocławiu-Strachowicach	33
  * PSG w Ustce	35
  * PSG w Chłopiatynie	37
  * PSG w Zgorzelcu	42
  * PSG w Kołobrzegu	43
  * PSG w Sławatyczach	47
  * PSG w Elblągu	49
  * PSG w Gołdapi	52
  * PSG w Bobrownikach	52
  * PSG w Nowym Dworze	53
  * PSG w Augustowie	53
  * PSG w Grzechotkach	54
  * PSG w Lublinie	54
  * PSG w Hermanowicach	55
  * PSG w Gdańsku	58
  * PSG w Świnoujściu	58
  * PSG w Kaliszu	64
  * PSG w Braniewie	67
  * PSG w Krościenku	67
  * PSG w Krakowie-Balicach	77
  * PSG w Gdyni	80
  * PSG w Bezledach	92
  * Bieszczadzki	98
  * PSG w Poznaniu-Ławicy	99
  * PSG w Lubaczowie	102
  * PSG w Kłodzku	132
  * PSG w Kuźnicy	134
  * PSG w Warszawie-Okęciu	157
  * PSG w Rzeszowie–Jasionce	160
  * Wydział Operacyjno-Śledczy	163
  * PSG w Świecku	177
  * PSG w Katowicach-Pyrzowicach	214
  * PSG w Dołhobyczowie	260
  * PSG w Hrebennem	331
  * PSG w Medyce	362
  * PSG w Hrubieszowie	401
  * PSG w Korczowej	414
  * PSG w Dorohusku	681
  * PSG w Terespolu	895
* no missing values found.
* Most records contain Border Guard Posts (PSG), while a small number refer to Border Guard Units (OSG) or other organizational units (e.g. Operational and Investigation Department).



**Decison:**

**No cleaning required**



**---**



Column: unit



* Category distribution:

  * tabletka	24
  * litr	329
  * kg	1242
  * szt.	5031
* No missing values found.
* No spelling inconsistencies detected.



**Decison:**

**No cleaning required**



\---

Colum: cooperating\_agency

* Category distribution (first 10):

  * Kraj sąsiedni | Kraj sąsiedni	1
  * SC | SC | SG	1
  * Sąd | SG	1
  * Policja | Policja | SG | Policja	1
  * PIP	1
  * SC | SG | SC | SG	1
  * Policja | SC | SG | Policja	1
  * SC | SG | Policja | Policja	1
  * SC | inny | SG	1
  * Kraj sąsiedni	1
* No missing values found.
* Some records contain duplicated agency names (e.g. 'Policja|Policja'). The dupliactes originate from the source dataset and may reflect the data export process or the source system.



Decison:



No cleaning required.

The original values will be preserved because their business meaning cannot be determined with certainty.



\---



**Column: event\_datetime**

* No missing values found.
* The date range is consistent with source dataset.
* All years (2024, 2025) are represents in the dataset, the data distribution looks reasonable.
* All months (1-12) are represents in the dataset, the data distribution looks reasonable.
* All weekdays (Monday-Sunday) are represents in the dataset, the data distribution looks reasonable.
* All hours (0-23) are represents in the dataset, the data distribution looks reasonable.
* The dataset cointains record from both years and covers months, days and hours of the analyzed period.



**Decison:**

**No cleaning required.**



\---

Column: value\_PLN

* descriptive statistics:

  * min value: 0 PLN,
  * max value: 70,000,000 PLN,
  * mean: 119,723.997057856673241288625904010519 PLN.
  * stddev: 1,253,674.06751211 PLN,
  * median: 700 PLN,
  * outliers: 975 records are outliers above 60552.16 PLN,
  * IQR 24191.67 PLN,
  * Q1 72.98 PLN,
  * Q3 24264.65 PLN
* 542 missing values found.

  * total\_records      6626
  * records\_with\_value 6084
  * missing\_value       542
  * missing\_percentage  8.17
  * The source data indicates that no price was listed for the conficated items.
  * These records contains NULL values. Missing values occur across multiple commodity categories and types.
* 52 records have value\_PLN = 0.

  * Inspection of the records showed that zero values occur across several commodity categories and are associated with valid records.
* No negative values found.
* Value information was available for 91.8% of records. In 8.2% of records, the value was not provided in the source data. Missing values were retained as NULL and excluded from calculations requiring a known monetary value.



**Decison:**



Zero values were retained as valid observations. They were not treated as missing values or outliers.

Null values were retained as missing data. They were not replaced with zero because NULL and zero represent different meanings and replacing NULL values would introduce artificial data.



The value\_PLN distribution is heavily right-skewed. Applying the IQR rule identified 975 observations (16.16%) above the upper limit of 60,552.16 PLN. Due to the wide variety of categories and types of commodities, these values should not automatically be treated as data errors. The result should be interpreted as the identification of outliers in the entire dataset, rather than as confirmation of data irregularities.

\---



Column: quantity

* descriptive statistics:

  * szt.

    * min\_value = 0,
    * max\_value 12743380.00,
    * mean 35555.76,
  * kg

    * min\_value = 0,
    * max\_value 26140.00,
    * mean 283.99,
  * litr

    * min\_value = 0.013,
    * max\_value 2850.00,
    * mean 69.82,
  * tabletka

    * min\_value = 1,
    * max\_value 5974.00,
    * mean 350.54,
* 10 records have quantity = 0.
* No missing values found.
* No negative values found.
* The quantity logically related to the unit.
* max\_value in quantity is logically related to unit and commodity\_category



**Decision:**



6,626 out of 6,626 records contain a value. There are no negative values. 10 records (0.15%) contain the value 0. Analysis of these records indicates that some of them describe actual cases for which the quantity was not specified or cannot be reliably reconstructed based on the available data. The values were neither modified nor imputed.



Quantity is reported in four units: pieces, kilograms, liters, and tablets. The distribution of units is largely consistent with the nature of the individual product categories. Categories such as “Narkotyki” and “Inne” appear in multiple units, confirming that “quantity” values should not be analyzed as a single combined population without taking the unit of measure into account. No clear irregularities in the assignment of units were identified at this stage.



No cleaning required.





##### Categorical columns



direction

commodity\_category

commodity\_type

location

border\_guard\_unit

border\_crossing

border\_section

border\_guard\_post

unit

cooperating\_agency



##### Numerical columns



event\_datetime

value\_PLN

quantity



### Data Cleaning



The file 'smuggling\_backup\_02' was created.





**Column: direction**



* Empty strings have been replaced with 'not specified'



\---



**Column: border\_crossing**



* Empty strings have been replaced with NULL.
* Inconsistent enries were checked and the notation with parentheses was standarized. The text in parentheses was not removed. Data verifiaction indicates that the entries in parentheses may be relevant to the business and may be indicate the type of crossing (rail, road, air etc.)
* Inconsistent dashes have been standarized.



\---



**Column: description**



* Empty strings have been replaced with NULL.



\---



**Column: value\_PLN**



* 542 missing values retained as NULL. Source data does not provide a monetary value for these records. Missing values were not replacet with zero or imputed, as the actual value cannot be reliably determined from the available data.
* Known-value analyses exclude NULL records. Completeness of value\_PLN shuld by reported alongside monetary metrics where relevant.
* 52 zero values retained as valid observation. They were not treating as missing values or removed as outliers. Inspection confirmed that zero-valued records contain valid observation and reported quantities.


# Analysis of Smuggling Data at the Polish Border, 2024–2025

### 

This project presents an analysis of data on recorded smuggling incidents at the Polish border in 2024–2025. The aim of the analysis is to identify key patterns related to changes over time, location, types of smuggled commodities, their estimated value, as well as the direction and location of recorded incidents.



The analysis was conducted using \*\*MySQL\*\* for data preparation and analysis and \*\*Power BI\*\* for data visualization. The project covers the process from data import and profiling through SQL-based analysis to the visual presentation and interpretation of the results.



Particular attention is given to changes in the number of recorded incidents over time and to differences between the frequency of recorded incidents and the total estimated value of commodities.

### 

1. ### How did the number of smuggling records change over time?



#### SQL



The analysis was performed using the 'vw\_smuggling\_cases\_monthly'and '04\_number\_of\_cases\_over\_time.sql'.



#### Visualisation and findings



* the year 2024: 2966 records
* the year 2025: 3660 records
* an increase of 694 (21,37 %) in the number of records compared to 2024



!\[chart](images/req1-smuggling-cases-monthly-march.png)



!\[chart](images/req1-smuggling-cases-monthly-april.png)



In March and April 2025, there is a sudden increase in records compared to March and April 2024. In March 2025, 591 records were reported, compared to March 2024 (263 records). Similarly, in April 2025, 421 records were reported, compared to April 2024 (256 records).



!\[chart](images/req1-commodities-march-april.png)



!\[chart](images/req1-march-weapon-type.png)



!\[chart](images/req1-march-ammunition-type.png)



The increase in March (across all locations) was mostly associated with an increase in number of records involving weapons (+157) and ammunition (+47). In the 'Broń' ('Weapon') category, the increase was mostly associated with the 'inna' ('other') type (+137 records), and in the 'Amunicja' ('Ammunition') category was mostly associated with the 'Ostra' ('Live') type (+43 records).



!\[chart](images/req1-march-location-change.png)



The highest increase in records in March 2025 was reported in 'kraj'('country') location.



!\[chart](images/req1-march-commodity-kraj-change.png)



In the 'kraj' ('country') location, the largest increase in number of records was in 'Broń' ('Weapon') category of the 'Inna' ('Other') type. The increase compared to March 2024 was 132 records.



!\[chart](images/req1-march-broń-inna.png)



!\[chart](images/req1-march-sum-of-records-by-timestamps.png)



The results indicate that a large part of the March 2025 increase in number of records was related to one exceptionally large event on March 6, 2025, at 7:48 a.m. This event was responsible for approximately 47,6 % of the increase in the number of records in March 2025, compared to March 2024, and was located in an area under the jurisdiction of the Nadbużański Border Guard Unit.







#### 2\. Which Border Guard units recorded the highest number of records?



#### SQL



The analysis was performed using the '05\_number\_of\_records\_per\_border\_guard\_unit.sql'.



#### Visualisation and findings



!\[chart](images/req2-number-of-records-per-BGu.png)



The highest number of records was recorded in the Nadbużański Border Guard Unit - 2831 records, which represents approximately 42,73 % of all records in the analyzed dataset.

The number of records in Nadbużański Border Guard Unit was more than twice as large as the number of records in Bieszczadzki Border Guard Unit, which ranked second in terms of the number of records.





#### 3\. What types of commodities are most frequently smuggled?



#### SQL



The analysis was performed using the '06\_most\_frequently\_smuggled\_commodities.sql'.



#### Visualisation and findings



!\[chart](images/req3-most-frequently-smuggled.png)



The data shows that cigarettes are the most commonly recorded type of commodities - they appear in 2246 records and account for approximately 33,9 % of all records. This is more than three times as many as live ammunition, which is second most common type (approximately 10,07 % of records). Passengers vehicles (9,12 %) and marijuana (5,81 %) also account for a significant share. The top 10 results from the ranking were used for visualisation purposes.



The data includes general categories like 'other' and 'Other', which may refer to various types of commodities. Due to the lack of a more detailed classification, they were not grouped together or assigned to specific types. In total, records in these values account for 9,89 % of all records, therefore, they should be taken into account as limitation in interpreting the ranking of the most common types of commodities.



#### 4\. Which types of smuggled commodities represent the highest estimated value?





#### SQL



The analysis was performed using the '07\_the\_highest\_estimated\_value.sql'.



#### Visualisation and findings



!\[chart](images/req4-total-estimated-value-by-category-and-type.png)

*For visualisation purposes, the chart has been limited to the top 7 records*



The data shows that cigarettes, shredded tobacco, and narcotics (other) account for the highest total value of confiscated commodities. The total value of the seized cigarettes amounts to 145,733,099.58 PLN and accounts for 20.01 percent of the value of all seized commodities. The seized shredded tobacco was estimated at a total of 123,140,893.18 PLN. This amount represents 16.91 percent of the value of the commodities listed in the report. Drugs—other—account for 12.13 percent of the value of the seized commodities and were estimated at a total of 88,387,073.73 PLN.



Right behind them, in fourth place on the list, is dried tobacco, estimated at 77,566,938.83 PLN (10.65%), followed by passenger vehicles—75,436,004.15 PLN (10.36%), narcotics—cocaine estimated at 44,632,303.23 PLN (6.13%)—and narcotics—marijuana with a total value of 38,713,253.66 PLN (5.31%). These types account for 81.5% of the total value of the records in the entire list.



Note that cigarettes, which are at the top of the list, were recorded in 2,246 entries, while shredded tobacco, which ranks just below them, was recorded in only 122 records.



The summary of the highest values of seized commodities looks different when analyzed by the category of seized commodities:



!\[chart](images/req4-total-estimated-value-by-category.png)

*To make the chart easier to read, the top 10 results are displayed*



Tobacco ranks highest, with a total estimated value of 229,640,576.13 PLN (31.53% of the total value of all commodities) appearing in 378 records. Just below it are narcotics, estimated at a total of 185,599,225.12 PLN (25.48%) in 797 records; in third place are cigarettes at 145,733,099.58 PLN (20.01%, 2,246 records), and vehicles—101,619,032.76 PLN (13.95%, 871 records). These four categories account for 90.97% of the value of all records.



The results also show that the frequency of occurrence of a particular product does not have to correspond to its share of the total value. An example is shredded tobacco, which occurs in much smaller quantities than cigarettes, but its total estimated value is similar.



!\[chart](images/req4-top-10-records-by-value.png)



An additional review revealed a significant concentration of values in individual observations—the 10 records with the highest values account for 30.11% of the total estimated value. The high values were retained in the analysis because they represent actual observations in the dataset, and their presence must be taken into account when interpreting the aggregated value.



#### 5\. How do smuggling directions differ in terms of frequency and value?



#### SQL



The analysis was performed using the '08\_differences\_in\_smuggling\_routes.sql'.



#### Visualisation and findings



!\[chart](images/req5-differences-of-smuggling-routes.png)



According to the data set obtained, the largest number of recorded entries was noted for the 'wewnątrz kraju' category — 2,762 entries, accounting for approximately 41.68% of all entries.

The total value of recorded commodities in this category is 656,612,123.80 PLN, which accounts for as much as 90.14% of the total value of all records.



The second most frequent destination is 'do RP'. There are 2,703 records, accounting for approximately 40.79% of all records; however, the total value of the recorded transactions is 39,117,258.93 PLN, which represents 5.37% of the total value of all records. This means that the number of records is not proportional to their value.



The dataset contains 1,158 records of smuggling 'z RP' (more than half as many as those 'do RP'), accounting for approximately 17.48% of the total dataset; however, their value is comparable to that of smuggling to Poland, at 32,671,415.37 PLN (4.49% of the total dataset's value).



These three records have no specified direction. They were included in the analysis of the number of records, but because they lack a ‘value\_PLN’ value, they do not affect the analysis of values.



Within the 'wewnątrz kraju' category 'kraj' accounts for 68.39% of the records but represents 91.67% of their value. This indicates a significantly greater concentration of value than would be suggested by the number of records alone.



In contrast, within the 'do RP' direction, the location accounts for only 8.40% of the total number of records but represents 45.07% of the total value. Conclusion: Focusing solely on the number of records can lead to a misinterpretation of the meaning of a given direction or location.



For the 'z RP' direction, 'przejście' location accounts for 88.69% of the records in this dataset and represents 97.89% of its value, which gives us a more proportional distribution between the number of records and their value than in the case of 'do RP'.



#### 6\. Which border crossings recorded the highest number and value of smuggling records?



#### SQL



The analysis was performed using the '09\_number\_and\_and\_value\_of\_records\_by\_border\_crossing.sql'.



#### Visualisation and findings



!\[chart](images/req6-border-crossing-by-the-nr-of-rec-and-value.png)



The border crossings with the highest number of recorded entries are not necessarily the ones with the highest total estimated value of commodities.



The “border\_crossing” field contained many different names for the same border crossing. To avoid splitting records for the same location, the names were standardized before aggregation. Suffixes indicating the mode of transport, such as '(drogowe), (lotnicze), (kolej) i (kolejowe)', were removed from the border crossing names. In addition, the name “Kuźnica – Bruzgi” was standardized to “Kuźnica Białostocka – Bruzgi,” and “Warszawa/Modlin” to “Warszawa – Modlin,” since these variants refer to the same border crossings.



The border crossing with the highest number of recorded incidents is Dorohusk–Jagodzin (647 records). This accounts for 18.24% of the records assigned to border crossings. The second-highest in terms of the number of recorded incidents is the Terespol–Brest crossing, with 548 recorded incidents, accounting for 15.45% of the total number of records attributed to border crossings.



The ranking of border crossings with the highest estimated total value of goods, however, looks different. The Kukuryki–Kozłowiczy border crossing ranks first, with a total estimated value of commodities amounting to 10,361,884.06 PLN. This amount accounts for 19.22% of the value of all records attributed to border crossings. The Terespol–Brest border crossing remains in second place, with an estimated total value of 10,191,930.85 PLN for seized commodities. This value accounts for 18.90% of the value of records attributed to border crossings. It is worth noting that Terespol–Brest ranked among the top entries in both lists, while the overall leaders differed..



This means that the number of registered records does not directly reflect the total estimated value of the goods.



#### 7\. Are there any temporal patterns in smuggling detections?





#### SQL



The analysis was performed using the '10\_the\_temporal\_patterns\_in\_smuggling\_detections.sql'.



#### Visualisation and findings



!\[chart](images/req7-average-number-of-rec-per-days-and-years.png)



Changes in the number of records over time were analyzed in REQ1. REQ7 focuses on shorter time cycles—days of the week and hours



In the analyzed dataset, records occurred more frequently on Thursdays, and the average number of records per Thursday was higher than on any other day of the week.



A recurring pattern related to the day of the week is evident in the analyzed dataset: Thursdays are characterized by the highest average number of recorded events in both 2024 and 2025.



!\[chart](images/req7-avg-number-of-rec-by-hours.png)



During the period under analysis, differences in the number of recorded incidents were evident depending on the time of the event. In 2024, the highest average number of records per observed day occurred at 6:00 a.m. and amounted to 2.50 records. In 2025, the highest value was recorded at 7:00 a.m.—an average of 3.95 records per observed day. The lowest values occurred at 3:00 a.m. in 2024 (1.25) and at 4:00 a.m. in 2025 (1.20). However, the hourly distribution was not identical in both years; therefore, the data indicate differences in the time structure of the records rather than a single, consistent hourly pattern.


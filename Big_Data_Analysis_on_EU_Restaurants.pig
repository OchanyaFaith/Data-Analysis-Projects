
ANALYSIS ONE

--The Trip Advisor Restaurant dataset t is loaded and stored in a dataset called Restaurants

Restaurants = LOAD 'TA_Restaurant.csv'  USING PigStorage(',') AS (RestaurantID:int, Name:Chararray, City:Chararray, CuisineStyle:chararray,Ranking:int,Rating:float,PriceRange:chararray, NumberOfReviews:int, Reviews:chararray,URL_TA:chararray, ID_TA:chararray);

--FOREACH statement is used to generate fields RestaurantID,Name,City,CuisineStyle,Rating and PriceRange for each row

Rated= FOREACH Restaurants GENERATE RestaurantID,Name,City,CuisineStyle,Rating,PriceRange;

--THe dataset "Rated" is order by the fields Rating and the data is stored in the dataset "Top_rated"

Top_rated = ORDER Rated BY Rating DESC;

--The output is displayed using the Dump Command

dump Top_Rated


ANALYSIS TWO

--The Trip Advisor Restaurant dataset t is loaded and stored in a dataset called Restaurants

Restaurants = LOAD 'TA_Restaurant.csv'  USING PigStorage(',') AS (RestaurantID:int, Name:Chararray, City:Chararray, CuisineStyle:chararray,Ranking:int,Rating:float,PriceRange:chararray, NumberOfReviews:int, Reviews:chararray,URL_TA:chararray, ID_TA:chararray);

--FOREACH statement is used to generate fields RestaurantID,Name,City,CuisineStyle,Rating and PriceRange for each row

Rated= FOREACH Restaurants GENERATE RestaurantID,Name,City,CuisineStyle,Rating,PriceRange;

--THe dataset "Rated" is order by the fields Rating and the data is stored in the dataset "Least_Rated"

Least_Rated = ORDER Rated BY Rating ASC;

--The output is displayed using the Dump Command

dump Least_Rated;




ANALYSIS THREE

--The Trip Advisor Restaurant dataset t is loaded and stored in a dataset called Restaurants

Restaurants = LOAD 'TA_Restaurant.csv'  USING PigStorage(',') AS (RestaurantID:int, Name:Chararray, City:Chararray, CuisineStyle:chararray,Ranking:int,Rating:float,PriceRange:chararray, NumberOfReviews:int, Reviews:chararray,URL_TA:chararray, ID_TA:chararray);

--FOREACH statement is used to generate fields RestaurantID,City for each row

Restaurant_Cities = FOREACH Restaurants GENERATE RestaurantID,City;

--THe dataset "Restaurant_Cities" is grouped  by the fields Rating and the data is stored in the dataset "Grouped_RC"

Grouped_RC = GROUP Restaurant_Cities BY City;

/* a flatten group(city) and a count of the RestaurantIDs in the corresponding tuple is generated for each row and the data stored in a new dataset "Restaurants_PerCity" */

Restaurants_PerCity = FOREACH Grouped_RC GENERATE flatten (group), COUNT(Restaurant_Cities);

--the dataset "Restaurants_PerCity" is ordered by the total restaurant count per city

Order_R_PerCity = ORDER Restaurants_PerCity by $1 DESC;

--The output is displayed using the Dump Command

dump Order_R_PerCity;










						demo-09-QueryingSemiStructuredData

# Open up zomato_data.json

# Scroll a bit and show the contents

# Continue in SnowSQL
# We should already be in COMPANY_DB


CREATE OR REPLACE TABLE ZOMATO_RESTAURANTS (
    JSON_DATA VARIANT
);

CREATE OR REPLACE STAGE ZOMATO_STAGE;

PUT file:///Users/loonycorn/Desktop/AdvancedSnowflake/zomato_data.json @ZOMATO_STAGE;

LIST @ZOMATO_STAGE;

COPY INTO ZOMATO_RESTAURANTS
FROM @ZOMATO_STAGE/zomato_data.json.gz
FILE_FORMAT = (
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE
);


############################################################
### Switch to SnowSight

# Have the worksheet "Semi-structuredData" open

# Make sure you select COMPANY_DB.PUBLIC from the drop down

SELECT * FROM ZOMATO_RESTAURANTS;

# We can see the data

SELECT JSON_DATA:restaurant
FROM ZOMATO_RESTAURANTS;

SELECT JSON_DATA:restaurant.name, JSON_DATA:restaurant.user_rating
FROM ZOMATO_RESTAURANTS;

SELECT JSON_DATA:restaurant.name, JSON_DATA:restaurant.user_rating.rating_text
FROM ZOMATO_RESTAURANTS;

# We can specify the datatype


SELECT 
	JSON_DATA:restaurant.name::String, 
	JSON_DATA:restaurant.user_rating.rating_text::String AS RatingText, 
	JSON_DATA:restaurant.location as Location
FROM ZOMATO_RESTAURANTS
WHERE RatingText = 'Excellent' 
OR RatingText = 'Very Good';

#

SELECT JSON_DATA:restaurant.name::String, JSON_DATA:restaurant.offers
FROM ZOMATO_RESTAURANTS;

# 

SELECT JSON_DATA:restaurant.name::String, JSON_DATA:restaurant.offers[0]
FROM ZOMATO_RESTAURANTS;


#

SELECT JSON_DATA:restaurant.name::String, o.value::String AS Offer 
FROM ZOMATO_RESTAURANTS, LATERAL FLATTEN (INPUT => JSON_DATA:restaurant.offers) o;




















































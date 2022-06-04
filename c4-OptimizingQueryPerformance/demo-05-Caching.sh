# Let's upload a large dataset via COPY command
# https://www.kaggle.com/datasets/sibmike/iowaliquorsales2020
# For caching and these optimization techniques use a XS warehouse


						demo-05-CachingDataInSnowflake

# Start on a new worksheet called "Optimizations"

CREATE DATABASE LIQUOR_SALES;

USE DATABASE LIQUOR_SALES;

USE SCHEMA PUBLIC;

# Let's create a table

CREATE OR REPLACE TABLE IOWA_LIQUOR_SALES(
                        INVOICE_NUMBER VARCHAR(255),
                        DATE VARCHAR(255),
                        STORE_NUMBER INT,
                        STORE_NAME VARCHAR(255),
                        ADDRESS VARCHAR(255),
                        CITY VARCHAR(255),
                        ZIP_CODE VARCHAR(255),
                        STORE_LOCATION VARCHAR(255),
                        COUNTY_NUMBER INT,
                        COUNTY VARCHAR(255),
                        CATEGORY VARCHAR(255),
                        CATEGORY_NAME VARCHAR(255),
                        VENDOR_NUMBER INT,
                        VENDOR_NAME VARCHAR(255), 
                        ITEM_NUMBER INT,
                        ITEM_DESCRIPTION VARCHAR(255),
                        PACK INT,
                        BOTTLE_VOLUME INT, 
                        STATE_BOTTLE_COST FLOAT,   
                        STATE_BOTTLE_RETAIL FLOAT,   
                        BOTTLE_SOLD INT,   
                        SALES FLOAT,   
                        VOLUME_SOLD_LITERS FLOAT,   
                        VOLUME_SOLD_GALLONS FLOAT   
                       );

# Run the terminal on fullscreen

# Go to terminal and run the following

/Users/loonycorn/Applications/SnowSQL.app/Contents/MacOS/snowsql 
-a nr29734.central-us.azure
-u clouduser

USE DATABASE LIQUOR_SALES;

USE SCHEMA PUBLIC;


CREATE OR REPLACE STAGE SALES_STAGE;


PUT file:///Users/loonycorn/Desktop/AdvancedSnowflake/Iowa_Liquor_Sales.csv @SALES_STAGE;

LIST @SALES_STAGE;

COPY INTO IOWA_LIQUOR_SALES 
FROM @SALES_STAGE/Iowa_Liquor_Sales.csv.gz
FILE_FORMAT = (TYPE = 'CSV', 
               FIELD_DELIMITER = ',' 
               SKIP_HEADER = 1 
               FIELD_OPTIONALLY_ENCLOSED_BY='"') 
ON_ERROR = CONTINUE;


# 3 records of the dataset will not be loaded due to some format error in the column values


#################################################################
# Go back to UI and let's continue in UI from here


############## Clear all the previous queries from the query editor


# Run the following query 

SELECT * FROM IOWA_LIQUOR_SALES; 

# We see it takes around 50s to run this query

# While running this query, click on Query ID and we can see the history and we can see how much has been processed till now

# Once this is done go to Profile and observe the blocks


# Go back to worksheet and re-run the same query
# Now we see this runs within 40ms

SELECT * FROM IOWA_LIQUOR_SALES; 

# Click on Query ID and Profile and observe the blocks

# Note that the query id's of both the query is different

# We see only one block now


###### Create a new worksheet and run the same query in the new worksheet

# The query should again run quickly

SELECT * FROM IOWA_LIQUOR_SALES; 


####### Go back to the optimizations worksheet


# To disable caching run the following

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

# Now try re-running the last query we see it takes 2 mins to run the query

# Make sure you close "Result limit exceeded" and show the time for the query

# Unless you set the USE_CACHED_RESULT=TRUE it will not be using the cache

SELECT * FROM IOWA_LIQUOR_SALES; 

# Let's set cache as true from now on

ALTER SESSION SET USE_CACHED_RESULT = TRUE;


######

## Query Results Caching

# On the current worksheet run the following query

SELECT * FROM "LIQUOR_SALES"."PUBLIC"."IOWA_LIQUOR_SALES"
WHERE VOLUME_SOLD_LITERS >= 50 AND DATE LIKE '%2015'
ORDER BY CITY; 

# We see it take more than 700 ms to run the query

SELECT * FROM "LIQUOR_SALES"."PUBLIC"."IOWA_LIQUOR_SALES"
WHERE VOLUME_SOLD_LITERS >= 50 AND DATE LIKE '%2015'
ORDER BY CITY; 

# This time it take 37ms to run

# Let's change the order by statement a bit

SELECT * FROM "LIQUOR_SALES"."PUBLIC"."IOWA_LIQUOR_SALES"
WHERE VOLUME_SOLD_LITERS >= 50 AND DATE LIKE '%2015'
ORDER BY COUNTY, CITY;


# Click on Query ID and Profile, there we can see query is scanned by 'Result Query'





























































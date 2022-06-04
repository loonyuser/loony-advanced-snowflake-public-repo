# For this demo let's stick to SnowSQL for a while
# In this demo we can work with parquet data
# I have uploaded a csv file of the same parquet file just so we nderstand how the data looks like


						demo-08-SemiStructuredData

# Open cities.csv file first and view the format
# This is so we understand what the data looks like



# Open the terminal and run the following

/Users/loonycorn/Applications/SnowSQL.app/Contents/MacOS/snowsql 
-a nr29734.central-us.azure
-u clouduser

# Give password and we see SnowSQL shell is opened

# Let's create a database

CREATE OR REPLACE DATABASE COMPANY_DB;


# Create a new table named CITIES 

CREATE OR REPLACE TABLE CITIES(
  CONTINENT VARCHAR,
  COUNTRY VARCHAR,
  CITY VARIANT
 );

CREATE OR REPLACE FILE FORMAT PARQUET_FORMAT
TYPE = 'parquet';

CREATE OR REPLACE STAGE CITIES_STAGE
FILE_FORMAT = PARQUET_FORMAT;

# Let's list what ever is within the created stage

LIST @CITIES_STAGE;

PUT file:///Users/loonycorn/Desktop/AdvancedSnowflake/cities.parquet @CITIES_STAGE;


LIST @CITIES_STAGE;

# Let's try to copy it

COPY INTO CITIES FROM @cities_stage/cities.parquet 
FILE_FORMAT = PARQUET_FORMAT
ON_ERROR = CONTINUE;

# We see this throws error - SQL compilation error: PARQUET file format can produce one and only one column of type variant or object or array. Use CSV file format if you want to load more than one column.

# This is not the way to copy a parquet file. Now let's see the correct way

COPY INTO CITIES
FROM 
(SELECT
  $1:continent::varchar,
  $1:country:name::varchar,
  $1:country:city::variant
 FROM @cities_stage/cities.parquet);

# We see this works

SELECT * FROM CITIES;

###

# We saw that the third column is an array
# Let's see how to flatten the array 

SELECT CONTINENT, COUNTRY, c.value::string AS CITY 
FROM CITIES, LATERAL FLATTEN (INPUT => CITY) c;























































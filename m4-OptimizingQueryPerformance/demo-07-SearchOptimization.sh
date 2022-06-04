

						demo-07-SearchOptimization

# Continue in the same "Optimization" worksheet
# Make sure you clear all the existing queries


# For this demo aslo we can turn off caching so as we might need to re-run queries

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

# Create a new table so hat we can add search optimization to it and compare

CREATE OR REPLACE TABLE IOWA_LIQUOR_SALES_OPTIMIZED 
AS SELECT * FROM IOWA_LIQUOR_SALES; 


# Click on the row result and expand and show the JSON

SELECT system$estimate_search_optimization_costs('IOWA_LIQUOR_SALES');


SHOW TABLES LIKE 'IOWA_LIQUOR_SALES%';

# We see search optimization is off for both the tables
# Let's add search optimization to this table

ALTER TABLE IOWA_LIQUOR_SALES_OPTIMIZED ADD SEARCH OPTIMIZATION;


SHOW TABLES LIKE 'IOWA_LIQUOR_SALES%';

# We see its ON but search_optimization_progress is 0 wait a bit and rerun the query again so that the progress is 100

# This shows the percentage of the table that has been optimized so far


# Now let'a query both the tables and see how search optimization works

# https://docs.snowflake.com/en/user-guide/search-optimization-service.html#queries-that-benefit-from-search-optimization

SELECT * FROM IOWA_LIQUOR_SALES
WHERE INVOICE_NUMBER = 'INV-27805100025'; 

# We see this takes about 300ms to run for 1 row

SELECT * FROM IOWA_LIQUOR_SALES_OPTIMIZED
WHERE INVOICE_NUMBER = 'INV-27805100025'; 

# Where as this take about 236ms to run for 1 row
# Now let's run a query that will produce many rows

SELECT * FROM IOWA_LIQUOR_SALES
WHERE SALES >= 500;

# This runs within 1.6s and produces 536,837 rows

SELECT * FROM IOWA_LIQUOR_SALES_OPTIMIZED
WHERE SALES >= 500;

# This runs within 1.8s and produces 536,837 rows

# Search optimization does not work for range queries
	

SELECT * FROM IOWA_LIQUOR_SALES
WHERE CITY = 'Adair' AND PACK = 12;

SELECT * FROM IOWA_LIQUOR_SALES_OPTIMIZED
WHERE CITY = 'Adair' AND PACK = 12;




#######################################################
## Let's switch to another inbuilt table
# As it has more rows it's easier to understand the difference (this table has 4.3GB of data)



SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."ORDERS" LIMIT 10;


# let's create 2 tables from this

CREATE OR REPLACE TABLE ORDERS_CLUSTERED
AS SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."ORDERS";

CREATE OR REPLACE TABLE ORDERS_SEARCH_OPTIMIZED
AS SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."ORDERS";


# Add clustering and search optimization

ALTER TABLE ORDERS_CLUSTERED CLUSTER BY (O_CUSTKEY);

ALTER TABLE ORDERS_SEARCH_OPTIMIZED ADD search optimization;


# Show that clustering and search optimization are enabled for these two tables

SHOW TABLES LIKE 'ORDER%';

# Wait for 3-4 minutes and run this again

SHOW TABLES LIKE 'ORDER%';

# Search optimization progress should be 100


# Now let's start querying

SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."ORDERS"
WHERE O_CUSTKEY = 11004176; 

# This takes 574ms to run

SELECT * FROM ORDERS_CLUSTERED
WHERE O_CUSTKEY = 11004176; 

# This may be faster or slower than the original table

SELECT * FROM ORDERS_SEARCH_OPTIMIZED
WHERE O_CUSTKEY = 11004176; 

# This takes 263ms to run


# Run a range query

SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF100"."ORDERS"
WHERE O_CUSTKEY > 11004176 AND O_CUSTKEY < 13004176; 

# On the regular table this takes 22 seconds

SELECT * FROM ORDERS_CLUSTERED
WHERE O_CUSTKEY > 11004176 AND O_CUSTKEY < 13004176; 

# On the clustered table 19 seconds (so better!)

SELECT * FROM ORDERS_SEARCH_OPTIMIZED
WHERE O_CUSTKEY > 11004176 AND O_CUSTKEY < 13004176; 

# On the search optimized table this may or may not be better than the regular table




						









						








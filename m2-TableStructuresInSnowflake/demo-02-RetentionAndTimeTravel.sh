# -- We can use time travel by using "at" or "before".
# -- Inside of "at" and "before" we can use three types of parameters:- offset, timestamp and statement.
# -- we can use the query ids that we have taken from from the pervious two alterations in the table in the statement parameter.



						demo-02-UnderstandingTimeTravelWithSnowflake


# Switch over to the Production worksheet


###################################################################
# "Production" worksheet

# Minimize the left navigation window

# Make sure you have cleared all of the previous queries


SELECT TABLE_NAME, 
       TABLE_TYPE, 
       IS_TRANSIENT, 
       RETENTION_TIME, 
       AUTO_CLUSTERING_ON
FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'IN_PRODUCTION%';


# We see by default this table has a retention time of 1

# Now let's try to alter the retention time

ALTER TABLE IN_PRODUCTION SET DATA_RETENTION_TIME_IN_DAYS = 120;

# We see it throws error -SQL compilation error: Exceeds maximum allowable retention time (90).

ALTER TABLE IN_PRODUCTION SET DATA_RETENTION_TIME_IN_DAYS = 0;

# We see ths works but Time travel is disable for this table

# Now let's set the retention time as 7 days

ALTER TABLE IN_PRODUCTION SET DATA_RETENTION_TIME_IN_DAYS = 7;


SELECT TABLE_NAME, 
       TABLE_TYPE, 
       IS_TRANSIENT, 
       RETENTION_TIME, 
       AUTO_CLUSTERING_ON
FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'IN_%';


# Try to set the retention time for the transient table, this will work
ALTER TABLE IN_BETA SET DATA_RETENTION_TIME_IN_DAYS = 0;


ALTER TABLE IN_BETA SET DATA_RETENTION_TIME_IN_DAYS = 7;

# This will fail
# SQL compilation error: invalid value [7] for parameter 'DATA_RETENTION_TIME_IN_DAYS'




#######################################################################
# Time Travel

# Still in the production worksheet

# Clear all previous queries from the sheet


# Run this query and make sure to scroll

SELECT * FROM IN_PRODUCTION;


# To get the last query id run

SELECT last_query_id(); 

# Copy the Query Id
# -- 01a46dcd-0000-1a96-0000-354d0002d0b6


DELETE FROM IN_PRODUCTION WHERE BRAND = 'OPPO';

# After some minutes run the next query (give 5 mins)

UPDATE IN_PRODUCTION SET BRAND = 'GP' where BRAND = 'Google Pixel';


# Show that the live table has only 10 records

SELECT * FROM IN_PRODUCTION;

# This should show 14 records and "Google Pixel"

SELECT * FROM IN_PRODUCTION before(statement => '<select-statement-query_id>');


# This may show only 10 records

SELECT * FROM IN_PRODUCTION AT (offset => -60 * 5);

# This should show 14 records

SELECT * FROM IN_PRODUCTION AT (offset => -60 * 20);


DROP TABLE IN_PRODUCTION;
SELECT * FROM IN_PRODUCTION;


# Can restore dropped tables when time-travel enabled

UNDROP TABLE IN_PRODUCTION;
SELECT * FROM IN_PRODUCTION ;


# Change retention time to 0
ALTER TABLE IN_PRODUCTION SET DATA_RETENTION_TIME_IN_DAYS = 0;


SELECT TABLE_NAME, 
       TABLE_TYPE, 
       IS_TRANSIENT, 
       RETENTION_TIME, 
       AUTO_CLUSTERING_ON
FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'IN_%';


DROP TABLE IN_PRODUCTION;
SELECT * FROM IN_PRODUCTION;

# This will be an error, because we have disabled time travel on this table

UNDROP TABLE IN_PRODUCTION;












# In this demo let's understand different types of tables - Permanent, Transient and Temporary

# For this module let's use Flipkart dataset
# We will have 3 tables for different stages of mobile production
    # Mobiles in production mode - for permanent tables
    # Mobiles in development mode - for transient tables
    # Mobiles in testing mode - for temporary tables 


						demo-01-WorkingWithTables


# Start with you logged into Snowflake's classic console

# This demo we will perform in the classic console, the remaining demos in Snowsight

# Click on the ACCOUNTADMIN drop down on the top-right and show that we are using Enterprise Edition

# Click on Databases and show what databases we have by default (should be only the sample databases)

# Click on Warehouses and show that we have one COMPUTE_WH (this should be an XS warehouse)


# Click on Worksheets and get started

# Click on the worksheet on the top-left and rename it "Production"


# IMPORTANT: As you paste queries into the worksheet make sure you keep scrolling up so the query is fully and clearly visible


###################################################################
# "Production" worksheet


# Create a database 

CREATE DATABASE ECOMMERCE_DB;

USE DATABASE ECOMMERCE_DB;


# Refresh the left navigation pane so you can see this database

# IMPORTANT: Close the left navigation pane so you now have more space to see the queries


SELECT current_warehouse(), current_database(), current_schema();


# Create a new permanent table

CREATE OR REPLACE TABLE IN_PRODUCTION
("BRAND" STRING, 
 "MODEL" STRING, 
 "COLOR" STRING, 
 "MEMORY" STRING, 
 "STORAGE" STRING, 
 "RATING" FLOAT,
 "LAUNCH_DATE" DATE);


# Properties of the created table


SELECT TABLE_NAME, 
       TABLE_TYPE, 
       IS_TRANSIENT, 
       RETENTION_TIME, 
       AUTO_CLUSTERING_ON
FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'IN_PRODUCTION%';


# We see the TABLE_TYPE is BASE TABLE 

INSERT INTO IN_PRODUCTION VALUES
('OPPO', 'A53', 'Moonlight Black', '4 GB', '64 GB', 4.5, '2020-04-07'),
('OPPO', 'F17' ,'Red', '2 GB', '16 GB', 4.2, '2020-05-02'),
('Google Pixel', 'Quite Black', 'Black', '4 GB', '128 GB', 4.4, '2020-05-12'),
('IQOO','3', 'Quantum Silver', '8 GB', '128 GB', 4.4, '2020-09-27'),
('HTC', 'Wildfire X', 'Blue', '3 GB', '32 GB', 3.9, '2020-10-10'),
('LG', 'W11', 'Black', '3 GB', '32 GB', 4, '2020-04-01'),
('LG', 'Q Stylus+', 'Black', '4 GB', '64 GB', 4, '2020-04-30');


SELECT * FROM IN_PRODUCTION;

DESCRIBE TABLE IN_PRODUCTION;



###################################################################
# "Testing" worksheet


# Open a new worksheet, name it as Testing

# IMPORTANT: Close the left navigation bar so so we have more space for the queries

# In 'Testing' worksheet create a new table 


USE DATABASE ECOMMERCE_DB;

CREATE OR REPLACE TEMPORARY TABLE IN_TESTING
("BRAND" STRING, 
 "MODEL" STRING, 
 "COLOR" STRING, 
 "MEMORY" STRING, 
 "STORAGE" STRING, 
 "RATING" FLOAT,
 "LAUNCH_DATE" DATE);

# On the left hand side, click on the Database name and open Public schema
# We can see the two tables in there
# But note that IN_TESTING 's icon is different it has a clock symbol in it

SELECT TABLE_NAME, 
        TABLE_TYPE, 
        IS_TRANSIENT, 
        RETENTION_TIME, 
        AUTO_CLUSTERING_ON
FROM INFORMATION_SCHEMA.TABLES  
WHERE TABLE_NAME LIKE 'IN_%';

# We see the table_type for this table is LOCAL_TEMPORARY

INSERT INTO IN_TESTING VALUES
('OPPO', 'A12', 'Moonlight Black', '4 GB', '32 GB', 3.8, '2020-04-06'),
('ASUS', 'Zenfone Go' ,'Black', '4 GB', '64 GB', 3.9, '2020-05-01'),
('realme','C20', 'Cool Grey', '6 GB', '128 GB', 4.1, '2020-09-23'),
('HTC', 'Wildfire X', 'Blue', '3 GB', '32 GB', 3.9, '2020-10-02'),
('LG', 'W31', 'Black', '6 GB', '128 GB', 3.5, '2020-03-28');


SELECT * FROM IN_TESTING;

SELECT * FROM IN_PRODUCTION;


###################################################################
# "Production" worksheet

# We see values
# Now go to old worksheet ('Production' worksheet)
# There on the left hand side, click on Database name and Open Public schema
# We see only IN_PRODUCTION table

# Let's try to query our temp table in there

SELECT * FROM IN_TESTING;

# It throws error - SQL compilation error: Object 'IN_TESTING' does not exist or not authorized.
# because this temporary table is limited to that particular session/worksheet


# Now go back to Testing worksheet


###################################################################
# "Testing" worksheet


# Now let's try to clone a temp table to a permanent one

CREATE OR REPLACE TABLE IN_TESTING_CLONE CLONE IN_TESTING;



###################################################################
# "Beta" worksheet

# IMPORTANT: Close the left navigation bar so so we have more space for the queries

# Now let's create a transient table
# Create a new worksheet 'Beta' 

USE DATABASE ECOMMERCE_DB;

CREATE OR REPLACE TRANSIENT TABLE IN_BETA
("BRAND" STRING, 
 "MODEL" STRING, 
 "COLOR" STRING, 
 "MEMORY" STRING, 
 "STORAGE" STRING, 
 "RATING" FLOAT,
 "LAUNCH_DATE" DATE);
 
SELECT TABLE_NAME, 
        TABLE_TYPE, 
        IS_TRANSIENT, 
        RETENTION_TIME, 
        AUTO_CLUSTERING_ON
FROM INFORMATION_SCHEMA.TABLES  
WHERE TABLE_NAME LIKE 'IN_%';

# Here we see the table type is same for both permanent and transient one
# But IS_TRANSIENT is NO for permanent one

INSERT INTO IN_BETA VALUES
('LG', 'Q60', 'Blue', '3 GB', '64 GB', 4, '2021-04-01'),
('Google Pixel', '3a', 'Just Black', '4 GB', '128 GB', 4.4, '2020-12-20'),
('HTC','U11+', 'Amazing Silver', '6 GB', '128 GB', 4.7, '2020-09-27'),
('SAMSUNG', 'Galaxy A22', 'Sky Blue', '4 GB', '128 GB', 4.3, '2021-01-09'),
('Lenovo', 'S560', 'Deep Black', '4 GB', '64 GB', 4.1, '2020-04-07'),
('LG', 'Q60+', 'Blue', '4 GB', '64 GB', 3.9, '2020-03-28');


SELECT * FROM IN_BETA;                                


###################################################################
# "Production" worksheet

# Go to Production worksheet and run the same query

SELECT * FROM IN_BETA;                                

# We see this works


###################################################################
# "Beta" worksheet

# Go to the Beta worksheet

# Let's try to clone a transient table

CREATE OR REPLACE TABLE IN_BETA_CLONE CLONE IN_BETA;

# We see this throws error too
# SQL compilation error: Transient object cannot be cloned to a permanent object.


CREATE OR REPLACE TEMPORARY TABLE BETA_TO_TESTING CLONE IN_BETA;

# Transient can be cloned to temporary table



# Now go to each of the 3 worksheets

###################################################################
# "Production" worksheet


# Open up the left navigation pane
# Hit refresh and show ECOMMERCE_DB -> Public -> Tables

# Should be 2 tables IN_BETA and IN_PRODUCTION


###################################################################
# "Testing" worksheet


# Open up the left navigation pane
# Hit refresh and show ECOMMERCE_DB -> Public -> Tables

# Should be 3 tables IN_BETA, IN_PRODUCTION, IN_TESTING


###################################################################
# "Beta" worksheet


# Open up the left navigation pane
# Hit refresh and show ECOMMERCE_DB -> Public -> Tables

# Should be 3 tables IN_BETA, IN_PRODUCTION, BETA_TO_TESTING

























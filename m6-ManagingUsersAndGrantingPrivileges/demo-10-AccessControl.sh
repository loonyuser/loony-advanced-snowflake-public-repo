

						demo-10-AccessControlRoles

###########################################
#### clouduser ACCOUNTADMIN

# Understanding roles in Snowflake

# Run the query

SELECT current_role();

# We see its accountadmin

# Click on the top right and see the various roles possible and that ACCOUNTADMIN
# has access to the COMPUTE_WH

# Let's create a new user and this gets default role (which is public)

CREATE USER TestUser 
PASSWORD = 'Test@1234' 
COMMENT = 'This is a test user' 
MUST_CHANGE_PASSWORD = FALSE;


###########################################
#### TestUser PUBLIC

# Open a new chrome window and let's login in with this user
# If you are on a regular window open up an incognito window (if you are on an incognito window then open up a regular window)

https://app.snowflake.com/central-us.azure/nr29734/

# Give username: TestUser and Password: Test@1234

# Create a worksheet

# Click on the Database drop down and you can see that only the SNOWFLAKE_SAMPLE_DATA is visible

# Click on the top right and see that there is only the PUBLIC role and the user cannot use
# the COMPUTE_WH

# After logging in we can see this USER is with PUBLIC role
# Run the query

SELECT current_role();

# It sohws PUBLIC
# Let's look for the grants provided to this public role

SHOW GRANTS TO ROLE PUBLIC;

# We can see in the grants table, the user is only able to use default sample data and have no access to warehouse

# If we try to create a database it throws error

CREATE DATABASE TESTUSER_DB;

# This throws error - SQL access control error: Insufficient privileges to operate on account 'FJ06037'

SHOW GRANTS ON USER TESTUSER;



###########################################
#### clouduser ACCOUNTADMIN

# Let's create a new role and assign that role to the TestUser

CREATE ROLE BASIC_ROLE;

GRANT ROLE BASIC_ROLE TO USER TestUser;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE BASIC_ROLE;


###########################################
#### TestUser PUBLIC

# Refresh the page

# Click on the top-right and show that the BASIC_ROLE is available

# Show COMPUTE_WH is also available

# Select the BASIC_ROLE for this TestUser



###########################################
#### clouduser ACCOUNTADMIN


GRANT USAGE ON DATABASE LIQUOR_SALES TO ROLE BASIC_ROLE;


SELECT * FROM IOWA_LIQUOR_SALES; 



###########################################
#### TestUser PUBLIC

# Refresh the page

# Select the LIQUOR_SALES database from the drop down

# Run this query

SELECT * FROM IOWA_LIQUOR_SALES; 

# This is a SQL compilation error


###########################################
#### clouduser ACCOUNTADMIN

GRANT USAGE ON SCHEMA LIQUOR_SALES.PUBLIC TO ROLE BASIC_ROLE;

GRANT SELECT ON TABLE LIQUOR_SALES.PUBLIC.IOWA_LIQUOR_SALES TO ROLE BASIC_ROLE;


###########################################
#### TestUser PUBLIC

SELECT * FROM IOWA_LIQUOR_SALES; 

# The query should now run

CREATE DATABASE TEST_DB;

# Create should faile



###########################################
#### clouduser ACCOUNTADMIN

SHOW GRANTS TO USER TESTUSER;

SHOW GRANTS TO ROLE BASIC_ROLE;

SHOW GRANTS TO ROLE SYSADMIN;

# A sysadmin can create a database and warehouse

GRANT ROLE SYSADMIN TO USER TestUser;


###########################################
#### TestUser PUBLIC

# Click on the top-right to switch to the sysadmin role

# Note that the sysadmin does not have access to the LIQUOR_SALES database and other tables



###########################################
#### clouduser ACCOUNTADMIN


GRANT ROLE BASIC_ROLE TO ROLE SYSADMIN;



###########################################
#### TestUser PUBLIC


# Hit refresh

# Make sure the SYSADMIN role and COMPUTE_WH is selected

# Select the LIQUOR_SALES database

CREATE DATABASE TEST_DB

# Now the test DB will be created























						



































						



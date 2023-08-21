

						demo-04-MaterialisedNonMaterialisedAndSecureViews

# Continue on the same views worksheet

SELECT * FROM ORDER_SUMMARY
WHERE PROD_NAME LIKE 'S%'; 


# 509 ms for 4 rows

# Click on Query Details and click on View Query Profile

# Make sure you zoom out as much as possible so almost the entire tree can be seen

# Click on the 3 TableScan blocks at the bottom

# Then click on the 2 Join operations

# Then click on the sort operation

# Close the QueryProfiler and go back to the Views page


####

# Create a secure view

CREATE OR REPLACE SECURE VIEW ORDER_SUMMARY_SECURE
COMMENT = "This view is a secure version"
AS
SELECT * FROM ORDER_SUMMARY;


SELECT * FROM ORDER_SUMMARY_SECURE;


# Click on Query Details and click on View Query Profile

# Click on the 2 blocks and show what they contain



######################### Clear all the previous queries on the sheet



####

# Creating materialized views
	# Unsecured materialised views

# Original table contains 1.6GB of data

CREATE OR REPLACE TABLE LINEITEM AS
SELECT * FROM
"SNOWFLAKE_SAMPLE_DATA"."TPCH_SF10"."LINEITEM";

SELECT * FROM LINEITEM LIMIT 10;

# Scroll sideways and show the columns


# Create a regular view, this should be created in milliseconds

CREATE OR REPLACE VIEW HIGH_TAX_VIEW
AS
SELECT * FROM LINEITEM WHERE L_TAX > 0.05;

# Select from a regular view, (You will see result count exceeded, close that and show that the query took around 19 seconds to run)

SELECT * FROM HIGH_TAX_VIEW WHERE L_TAX > 0.06;


# Open up the QueryProfiler and show the blocks


# Create a materialized view (You will see result count exceeded, close that and show that the view took around 16 seconds to create)

CREATE OR REPLACE MATERIALIZED VIEW HIGH_TAX_VIEW_MATERIALIZED
AS
SELECT * FROM LINEITEM WHERE L_TAX > 0.05;


# Select from a materialized view, (You will see result count exceeded, close that and show that the query will be slightly faster)

SELECT * FROM HIGH_TAX_VIEW_MATERIALIZED WHERE L_TAX > 0.06;


# Open up the QueryProfiler and show the blocks


# Creaet a secure materialized view

CREATE OR REPLACE SECURE MATERIALIZED VIEW HIGH_TAX_VIEW_SECURE_MATERIALIZED
AS
SELECT * FROM LINEITEM WHERE L_TAX > 0.05;

# Query it 

SELECT * FROM HIGH_TAX_VIEW_SECURE_MATERIALIZED WHERE L_TAX > 0.06;

# Open up the QueryProfiler and show the blocks









































































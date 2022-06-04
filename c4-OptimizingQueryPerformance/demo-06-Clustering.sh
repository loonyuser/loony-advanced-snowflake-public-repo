

						demo-06-Clustering


# Start in a new worksheet named "Clustering"

SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'IOWA_LIQUOR_SALES';

# Make sure you scroll sideways to show the entire result

# We see that this table is not clustered and doesn't have a clustering key

# Let's go ahead and cluster this table

ALTER TABLE IOWA_LIQUOR_SALES CLUSTER BY(COUNTY);

SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'IOWA_LIQUOR_SALES';

# Now we can see the clustering key

# Let's understand how clustering works
# We can disable caching for this demo if needed, as we might need to re-run queries

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

# Clone the current table

CREATE OR REPLACE TABLE IOWA_LIQUOR_SALES_CLUSTERED CLONE IOWA_LIQUOR_SALES;


# We see the clustered key is also cloned 

SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'IOWA_LIQUOR_SALES_CLUSTERED';


# We can drop the cluster on IOWA_LIQUOR_SALES using alter statement as well

ALTER TABLE IOWA_LIQUOR_SALES DROP CLUSTERING KEY;

SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'IOWA_LIQUOR_SALES';

# We see the key is dropped


###################### Clear all the previous queries

#### Here paste the queries 2 at a time (on unclustered and clustered) and run one after another
#### You may have to run each pair several times in order to show the speed up on clustered


# Now we have two tables - IOWA_LIQUOR_SALES and IOWA_LIQUOR_SALES_CLUSTERED

SELECT * FROM IOWA_LIQUOR_SALES
WHERE COUNTY = 'CLINTON';

SELECT * FROM IOWA_LIQUOR_SALES_CLUSTERED
WHERE COUNTY = 'CLINTON';


# The query on the clustered table should run slightly faster than on the unclustered table
# The effect may be slight because the table is not large and the micro-partitions are very
# efficient

SELECT * FROM IOWA_LIQUOR_SALES
ORDER BY COUNTY;

SELECT * FROM IOWA_LIQUOR_SALES_CLUSTERED
ORDER BY COUNTY;


# The order by query is much faster on the clustered table compared to the unclustered table


SELECT * FROM IOWA_LIQUOR_SALES
WHERE CITY = 'Adair';

SELECT * FROM IOWA_LIQUOR_SALES_CLUSTERED
WHERE CITY = 'Adair';


# Here you should see a significant improvement when you query on the clustered table


# How can you examine which column works well for clustering?

SELECT SYSTEM$CLUSTERING_INFORMATION('IOWA_LIQUOR_SALES', '(DATE)');

# Select the result row and show the JSON


SELECT SYSTEM$CLUSTERING_INFORMATION('IOWA_LIQUOR_SALES', '(CITY)');

# Select the result row and show the JSON

SELECT SYSTEM$CLUSTERING_INFORMATION('IOWA_LIQUOR_SALES', '(COUNTY)');

# Select the result row and show the JSON


# The clustering depth for a populated table measures the average depth (1 or greater) of the overlapping micro-partitions for specified columns in a table. The smaller the average depth, the better clustered the table is with regards to the specified columns.













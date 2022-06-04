# Advantages of views:
	# Simplify complex SQL Queries
	# Security

# Let's understand view and how views are used

						demo-03-UnderstandingViews

# Start in the classic interface

# Click on Snowsight and go to the new interface

# Create a brand new worksheet with the name "Views"

# Make sure the drop down on top has ECOMMERCE_DB.PUBLIC selected


USE ECOMMERCE_DB;

# Create a customer details table

CREATE OR REPLACE TABLE CUSTOMER_DETAILS
(cust_id         VARCHAR(10) PRIMARY KEY,
 cust_name       VARCHAR(50) NOT NULL,
 phone           VARCHAR(50),
 email           VARCHAR(50),
 address         VARCHAR(250)
);

# Create a products table

CREATE OR REPLACE TABLE PRODUCT_INFO
(prod_id         VARCHAR(10) PRIMARY KEY,
 prod_name       VARCHAR(50) NOT NULL,
 brand           VARCHAR(50) NOT NULL,
 price           INT
);

# Let's create a orders table and reference product id and customer id from the respective tables

CREATE OR REPLACE TABLE ORDER_DETAILS
(ord_id          BIGINT PRIMARY KEY,
 prod_id         VARCHAR(10) REFERENCES PRODUCT_INFO(prod_id),
 cust_id         VARCHAR(10) REFERENCES CUSTOMER_DETAILS(cust_id),
 quantity        INT,
 discount        INT,
 date            DATE
);

SHOW TABLES;


################### Clear the screen of the previous queries


# Let's insert values into these tables

INSERT INTO CUSTOMER_DETAILS VALUES
('C1', 'Alice Johnson', '(646)890-590' , 'alice@demo.com', 'New York'),
('C2', 'James Xavier', '(647)340-132', 'james@demo.com', 'Boston'),
('C3', 'Bob Parker', '(645)456-724', 'bob@demo.com', 'Washington'),
('C4', 'Mark Cooper', '(647)989-555', 'eshal@demo.com', 'Boston');

INSERT INTO PRODUCT_INFO VALUES
('P1', 'Samsung S22', 'Samsung', 800),
('P2', 'Google Pixel 6 Pro', 'Google', 900),
('P3', 'Sony Bravia TV', 'Sony', 600),
('P4', 'Dell XPS 17', 'Dell', 2000),
('P5', 'iPhone 13', 'Apple', 800),
('P6', 'Macbook Pro 16', 'Apple', 5000);

INSERT INTO ORDER_DETAILS VALUES
(1, 'P1', 'C1', 2, 10, '20220-01-01'),
(2, 'P3', 'C1', 1, 0, '20220-01-01'),
(3, 'P2', 'C2', 1, 0, '2020-01-01'),
(4, 'P4', 'C3', 3, 20, '2020-02-01'),
(5, 'P3', 'C4', 1, 0, '2020-02-01'),
(6, 'P6', 'C1', 10, 30, '2020-03-01'),
(7, 'P4', 'C3', 5, 25, '2020-04-01');


################### Clear the screen of the previous queries


# Okay, now we can query these tables
# Join these tables and
# Let's say that we want to join these tables and get the cost of the products purchased


SELECT o.ord_id, o.date, c.cust_name, p.prod_name, 
       (p.price * o.quantity) - (p.price * o.quantity) * (o.discount::float/100) AS cost
FROM CUSTOMER_DETAILS c
JOIN ORDER_DETAILS o ON o.cust_id = c.cust_id
JOIN PRODUCT_INFO p ON p.prod_id = o.prod_id
ORDER BY o.ord_id, c.cust_name;


# Everytime we insert new value is insert in any of the table,
# each time we need to run a join query and have to calculate cost each time

# Instead we can create a view to save this particular query and each time a new value is inserted the view gets updated

CREATE OR REPLACE VIEW ORDER_SUMMARY
AS
SELECT o.ord_id, o.date, c.cust_name, p.prod_name, 
       (p.price * o.quantity) - (p.price * o.quantity) * (o.discount::float/100) AS cost
FROM CUSTOMER_DETAILS c
JOIN ORDER_DETAILS o ON o.cust_id = c.cust_id
JOIN PRODUCT_INFO p ON p.prod_id = o.prod_id
ORDER BY o.ord_id, c.cust_name;


# Run this and query from the view

SELECT * FROM ORDER_SUMMARY;

# We can see 7 rows in this view
# Now let's insert new values within order details with purchases about the next day

INSERT INTO ORDER_DETAILS VALUES
(8, 'P3', 'C1', 1, 0, '2020-04-02'),
(9, 'P5', 'C2', 1, 0, '2020-04-03'),
(10, 'P5', 'C3', 1, 0, '2020-04-04');

# Now just run the view again

SELECT * FROM ORDER_SUMMARY;

# We see this time the number of rows are 10. The inserted values are updated in the view


################### Clear the screen of the previous queries


# Create another view

CREATE OR REPLACE VIEW PREMIUM_PRODUCTS
AS
SELECT * FROM PRODUCT_INFO where price > 1000;

# Query the view

SELECT * FROM PREMIUM_PRODUCTS;


# Change the definition of the original table

ALTER TABLE PRODUCT_INFO ADD COLUMN CONFIGURATION VARCHAR(100);

# Querying the view will fail unless we recreate the view

SELECT * FROM PREMIUM_PRODUCTS;

# Recreate the view

CREATE OR REPLACE VIEW PREMIUM_PRODUCTS
AS
SELECT * FROM PRODUCT_INFO where price > 1000;

# Query the view again, this should succeed

SELECT * FROM PREMIUM_PRODUCTS;





























































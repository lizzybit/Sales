# Exploring Sales Data in SQL and Tableau | RFM Analysis in SQL
 
 ## 2. Data Retrieval

The dataset used in the project is available at: https://github.com/AllThingsDataWithAngelina/DataSource/blob/main/sales_data_sample.csv

The dataset you provided is called "sales_data_sample.csv" and contains 2,823 rows and 25 columns, where each row represents a sale made by a company. The columns in the dataset provide information about each sale, such as the order date, ship date, product category, product name, sales quantity, sales price, and customer information.

The dataset includes:

1. **ORDERNUMBER:** The unique identifier of the sales order.
2. **QUANTITYORDERED:** The quantity of the product ordered.
3. **PRICEEACH:** The price of each product.
4. **ORDERLINENUMBER:** The line number of the product in the order.
5. **SALES:** The total sales revenue for the product in the order.
6. **ORDERDATE:** The date when the order was placed.
7. **STATUS:** The status of the order.
8. **QTR_ID:** The quarter of the year when the order was placed.
9. **MONTH_ID:** The month when the order was placed.
10. **YEAR_ID:** The year when the order was placed.
11. **PRODUCTLINE:** The product line to which the product belongs.
12. **MSRP:** The manufacturer's suggested retail price of the product.
13. **PRODUCTCODE:** The unique identifier of the product.
14. **CUSTOMERNAME:** The name of the customer who placed the order.
15. **PHONE:** The phone number of the customer.
16. **ADDRESSLINE1:** The first line of the customer's address.
17. **ADDRESSLINE2:** The second line of the customer's address.
18. **CITY:** The city where the customer is located.
19. **STATE:** The state where the customer is located.
20. **POSTALCODE:** The postal code of the customer's address.
21. **COUNTRY:** The country where the customer is located.
22. **TERRITORY:** The territory where the sale was made.
23. **CONTACTLASTNAME:** The last name of the person who made the sale.
24. **CONTACTFIRSTNAME:** The first name of the person who made the sale.
25. **DEALSIZE:** The size of the sale, either small, medium or large.

The data in this projects and the license CC0: Public Domain. This means that it is released to the public domain, and anyone can use, modify, or distribute it for any purpose, including commercial purposes, without any restrictions or limitations.

## 4. Import Data
### 4.1 Create Table
> Input:
``` sql

CREATE TABLE sales (
	ORDERNUMBER integer,
        QUANTITYORDERED	integer,
        PRICEEACH decimal(10,2),
        ORDERLINENUMBER integer,
	SALES decimal(10,2),
	ORDERDATE varchar(255),
	STATUS varchar(255),
	QTR_ID integer,
	MONTH_ID integer,
	YEAR_ID integer,
	PRODUCTLINE varchar(255),
	MSRP integer,
	PRODUCTCODE varchar(255),
	CUSTOMERNAME varchar(255),
	PHONE varchar(255),
	ADDRESSLINE1 varchar(255),
	ADDRESSLINE2 varchar(255),
	CITY varchar(255),
	STATE varchar(255),
	POSTALCODE varchar(255),
	COUNTRY varchar(255),
	TERRITORY varchar(255),
	CONTACTLASTNAME varchar(255),
	CONTACTFIRSTNAME varchar(255),
	DEALSIZE varchar(255)
    );
```
### 4.2 Load Data
> Input:
``` sql
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Sales/Data/Raw/Sales Data.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

## 5. Data Cleaning and Inpection
### 5.1 Data Inspection
> Input:
``` sql
-- Inspecting Data
SELECT *
FROM sales;

SELECT COUNT(*)
FROM sales

--  Checking unique values
SELECT DISTINCT STATUS 
FROM sales;
SELECT DISTINCT YEAR_ID
FROM sales;
SELECT DISTINCT PRODUCTLINE 
FROM sales;
SELECT DISTINCT COUNTRY 
FROM sales;
SELECT DISTINCT TERRITORY
FROM sales;
SELECT DISTINCT DEALSIZE
FROM sales;
```
### 5.2 Initial Data Cleaning in Excel
#### 5.2.1 Time Removed from ORDERDATE Column in Excel
> Before:
<p align = "left">
  <img src="https://user-images.githubusercontent.com/128324837/231852725-e515f12e-1e51-4718-a56e-c6f02a294be7.png" width=20% height=20%>
</p>

> After:

<p align = "left">
  <img src="https://user-images.githubusercontent.com/128324837/231853253-52fbbb35-3b12-4146-b8b6-04c3e83d72d2.png" width=20% height=20%>
</p>

#### 5.2.2 \N Added to the Blanks
> Before:
<p align = "left">
  <img src="https://user-images.githubusercontent.com/128324837/231854581-02cdd078-cc8a-4f1b-a8f1-d5b6264e92fc.png" width=20% height=20%>
</p>

> After: 
<p align = "left">
  <img src="https://user-images.githubusercontent.com/128324837/231854678-d523d9f7-7b1a-4075-a27a-e593f48a89b9.png" width=20% height=20%>
</p>

### 5.3 Data Cleaning in SQL
#### 5.3.1 Standardize Date Format
> Input:
``` sql
SELECT ORDERDATE
FROM sales
LIMIT 10;

-- Change format from dd/mm/yyyy to yyyy-mm-dd
UPDATE sales
SET ORDERDATE = STR_TO_DATE(ORDERDATE, '%m/%d/%Y');

-- Change datatype from varchar to date
ALTER TABLE sales
MODIFY COLUMN ORDERDATE date;

SELECT ORDERDATE
FROM sales
LIMIT 10;
```
## 6. Exploratory Data Analysis
### 6.1 Grouping Sales by Product Line, Year and Dealsize
> Input:
``` sql
SELECT PRODUCTLINE, SUM(SALES) AS Revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

SELECT YEAR_ID, SUM(SALES) AS Revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

SELECT DEALSIZE, SUM(SALES) AS Revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC;
```
### 6.2 What is the Best Month for Sales in Each Year? How Much was Earned That Month? 
> Input:
``` sql
SELECT  MONTH_ID, SUM(SALES) AS Revenue, COUNT(ORDERNUMBER) AS Frequency
FROM sales
WHERE YEAR_ID = 2003 
GROUP BY 1
ORDER BY 2 DESC;

SELECT  MONTH_ID, SUM(SALES) AS Revenue, COUNT(ORDERNUMBER) AS Frequency
FROM sales
WHERE YEAR_ID = 2004
GROUP BY 1
ORDER BY 2 DESC;
```
### 6.3 What is the Best Selling Product in the Month With the Most Revenue?
> Input:
``` sql
-- November Seems to Be the Month With the Most Revenue, What Product Do They Sell in November?

SELECT  MONTH_ID, PRODUCTLINE, SUM(SALES) AS Revenue, COUNT(ORDERNUMBER) AS Frequency
FROM sales
WHERE YEAR_ID LIKE "2003" AND MONTH_ID = 11
GROUP BY 1,2
ORDER BY 3 DESC;

SELECT  MONTH_ID, PRODUCTLINE, SUM(SALES) AS Revenue, COUNT(ORDERNUMBER) AS Frequency
FROM sales
WHERE YEAR_ID LIKE "2004" AND MONTH_ID = 11
GROUP BY 1,2
ORDER BY 3 DESC;
```

### 6.4 What City Has the Highest Number of Sales in a Specific Country?
> Input:
``` sql
-- Let's Take the UK for Example:
SELECT CITY, SUM(SALES) Revenue
FROM sales
WHERE COUNTRY = 'UK'
GROUP BY 1
ORDER BY 2 DESC;
```
### 6.5 Which is the Best Selling Product in a Specific Country?
> Input:
``` sql
-- Let's Take the USA for Example:
SELECT COUNTRY, PRODUCTLINE, SUM(SALES) Revenue
FROM sales
WHERE COUNTRY = 'USA'
GROUP BY 1,2
ORDER BY 3 DESC;
```
### 6.6 Which Products are Most Often Sold Together? 
> Input:
```sql
SELECT DISTINCT s1.ORDERNUMBER, GROUP_CONCAT(s2.PRODUCTCODE SEPARATOR ',') AS ProductCodes
FROM sales s1
JOIN sales s2 ON s1.ORDERNUMBER = s2.ORDERNUMBER
WHERE s1.STATUS = 'Shipped' AND s2.ORDERNUMBER IN (
  SELECT m.ORDERNUMBER
  FROM (
    SELECT ORDERNUMBER, COUNT(*) AS rn
    FROM sales
    WHERE STATUS = 'Shipped'
    GROUP BY ORDERNUMBER
  ) m
  WHERE m.rn = 3
)
GROUP BY s1.ORDERNUMBER
ORDER BY ProductCodes DESC;
```
## 7.
> Input:
``` sql
SELECT
	CUSTOMERNAME, 
	SUM(SALES) AS MonetaryValue,
	AVG(SALES) AS AvgMonetaryValue,
	COUNT(ORDERNUMBER) AS Frequency,
	MAX(ORDERDATE) last_order_date,
	(select MAX(ORDERDATE) FROM sales) AS max_order_date,
	DATEDIFF((select MAX(ORDERDATE) FROM sales),MAX(ORDERDATE)) AS Recency
FROM sales
GROUP BY CUSTOMERNAME;

WITH RFM AS (
	SELECT
		CUSTOMERNAME, 
		SUM(SALES) AS MonetaryValue,
		AVG(SALES) AS AvgMonetaryValue,
		COUNT(ORDERNUMBER) AS Frequency,
		MAX(ORDERDATE) last_order_date,
		(select MAX(ORDERDATE) FROM sales) AS max_order_date,
		DATEDIFF((select MAX(ORDERDATE) FROM sales),MAX(ORDERDATE)) AS Recency
	FROM sales
	GROUP BY CUSTOMERNAME
)
SELECT r.*,
	NTILE(4) OVER (ORDER BY Recency DESC) AS rfm_recency,
	NTILE(4) OVER (ORDER BY Frequency) AS rfm_frequency,
	NTILE(4) OVER (ORDER BY AVGMonetaryValue) AS rfm_monetary
FROM RFM r;

DROP TABLE rfm_temp;

CREATE TEMPORARY TABLE rfm_temp (
    CUSTOMERNAME varchar(255),
    MonetaryValue decimal(10,2),
    AvgMonetaryValue decimal(10,2),
    Frequency integer,
    last_order_date date,
    max_order_date date,
    Recency integer,
    rfm_recency integer,
    rfm_frequency integer,
    rfm_monetary integer,
    rfm_cell integer
);

INSERT INTO rfm_temp
WITH RFM AS (
    SELECT
        CUSTOMERNAME, 
        SUM(SALES) AS MonetaryValue,
        AVG(SALES) AS AvgMonetaryValue,
        COUNT(ORDERNUMBER) AS Frequency,
        MAX(ORDERDATE) last_order_date,
        (SELECT MAX(ORDERDATE) FROM sales) AS max_order_date,
        DATEDIFF((SELECT MAX(ORDERDATE) FROM sales), MAX(ORDERDATE)) AS Recency
    FROM sales
    GROUP BY CUSTOMERNAME
), RFM_CALC AS (
    SELECT 
        r.*, 
        NTILE(4) OVER (ORDER BY Recency DESC) AS rfm_recency,
        NTILE(4) OVER (ORDER BY Frequency) AS rfm_frequency,
        NTILE(4) OVER (ORDER BY MonetaryValue) AS rfm_monetary
    FROM RFM r
)
SELECT 
    c.CUSTOMERNAME, 
    c.MonetaryValue, 
    c.AvgMonetaryValue, 
    c.Frequency, 
    c.last_order_date, 
    c.max_order_date, 
    c.Recency, 
    c.rfm_recency, 
    c.rfm_frequency, 
    c.rfm_monetary,
    c.rfm_recency + c.rfm_frequency + c.rfm_monetary AS rfm_cell
FROM RFM_CALC c;

SELECT CUSTOMERNAME, rfm_recency, rfm_frequency, rfm_monetary,
    CASE 
        WHEN rfm_cell IN (1, 2, 5, 6, 9, 10, 13, 14) THEN 'lost_customers'
        WHEN rfm_cell IN (11, 12, 15, 16, 20, 21, 24, 25) THEN 'slipping_away'
        WHEN rfm_cell IN (3, 4, 7) THEN 'new_customers'
        WHEN rfm_cell IN (17, 18, 22, 23) THEN 'potential_churners'
        WHEN rfm_cell IN (8, 19) THEN 'active'
        WHEN rfm_cell IN (26, 27, 30, 31) THEN 'loyal'
    END AS rfm_segment
FROM rfm_temp;
```

-- Inspecting Data
SELECT *
FROM sales;

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

-- Cleaning Data

### Time removed from ORDERDATE column in excel
### \N added to the blanks

### Standardize Date Format

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

 -------------------------------------------------------------------------------------------------------------------------
-- Exploratory Analysis
--- Grouping Sales by Product Line, Year and Dealsize
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

--- What is the Best Month for Sales in Each Year? How Much was Earned That Month? 
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

--- November Seems to Be the Month With the Most Revenue, What Product Do They Sell in November
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

--- What City Has the Highest Number of Sales in a Specific Country
SELECT CITY, SUM(SALES) Revenue
FROM sales
WHERE COUNTRY = 'UK'
GROUP BY 1
ORDER BY 2 DESC;

--- Which is the Best Selling Product in a Specific Country
SELECT COUNTRY, PRODUCTLINE, SUM(SALES) Revenue
FROM sales
WHERE COUNTRY = 'USA'
GROUP BY 1,2
ORDER BY 3 DESC;

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

 -------------------------------------------------------------------------------------------------------------------------
 -- RFM Analysis
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

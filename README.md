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



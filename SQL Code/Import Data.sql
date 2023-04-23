CREATE SCHEMA `sales_data`;

DROP TABLE sales;

CREATE TABLE sales (
	ORDERNUMBER	integer,
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
    
LOAD DATA LOCAL INFILE '/Users/elizabeth/Documents/GitHub/Sales/Data/Raw/Sales Data.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM sales;



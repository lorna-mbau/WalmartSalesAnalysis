CREATE DATABASE WALMARTSALES;

select *
from dbo.WalmartSalesData

--Change Data Type--
ALTER TABLE dbo.WalmartSalesData
ALTER COLUMN Payment_method varchar(30);

--Rename the Column--
sp_rename 'dbo.WalmartSalesData.Payment', 'Payment_method', 'COLUMN';

--Checking Data Type--
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH AS MAX_LENGTH, 
    CHARACTER_OCTET_LENGTH AS OCTET_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE  COLUMN_NAME = 'Payment_method';

--Time of Day--

select Time
from dbo.WalmartSalesData

SELECT
	Time,
	(CASE
		WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 16 THEN 'Afternoon'
		ELSE 'Evening'
		END) AS time_of_day
FROM dbo.WalmartSalesData;

ALTER TABLE dbo.WalmartSalesData
ADD time_of_day VARCHAR(20);

UPDATE dbo.WalmartSalesData
SET time_of_day = (CASE
					WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 11 THEN 'Morning'
					WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 16 THEN 'Afternoon'
					ELSE 'Evening'
					END);

--Day of the Week--
SELECT Date,
		DATENAME(dw, Date) AS day_of_week
FROM dbo.WalmartSalesData;

ALTER TABLE WalmartSalesData
ADD day_of_week varchar(10);

UPDATE WalmartSalesData
SET day_of_week=DATENAME(dw, Date);


--Month Name--
SELECT Date, 
		DATENAME(month, Date) AS month_name
FROM dbo.WalmartSalesData;

ALTER TABLE dbo.WalmartSalesData
ADD month_name varchar(10);

UPDATE dbo.WalmartSalesData
SET month_name= DATENAME(month, Date);

--Unique Cities--
SELECT DISTINCT City
FROM dbo.WalmartSalesData

--Unique Branches--
SELECT DISTINCT Branch
FROM dbo.WalmartSalesData

SELECT DISTINCT City, Branch
FROM dbo.WalmartSalesData

--Product Analysis (No. of unique products)--
SELECT COUNT (DISTINCT Product_line)
FROM dbo.WalmartSalesData;

SELECT DISTINCT Product_line
FROM dbo.WalmartSalesData;

--Common Payment Method--
SELECT Payment_method, COUNT (Payment_method) AS cnt
FROM dbo.WalmartSalesData
GROUP BY Payment_method
ORDER BY cnt dESC;

--Most Selling Product Line--
SELECT Product_line, COUNT (Product_line) AS cnt
FROM dbo.WalmartSalesData
GROUP BY Product_line
ORDER BY cnt DESC;

--Total Revenue per month--
SELECT month_name, SUM(Total) AS Total_Revenue
FROM dbo.WalmartSalesData
GROUP BY month_name
ORDER BY Total_Revenue DESC;

--Month with the largest COGS--
SELECT month_name, SUM(cogs) AS COGS
FROM dbo.WalmartSalesData
GROUP BY month_name
ORDER BY COGS DESC;

--Product Line with the Largest Revenue--
SELECT Product_line, SUM(Total) AS Total_Revenue
FROM dbo.WalmartSalesData
GROUP BY Product_line
ORDER BY Total_Revenue DESC;

--City with Largest Revenue--
SELECT Branch, City, SUM(Total) AS Total_Revenue
FROM dbo.WalmartSalesData
GROUP BY Branch, City
ORDER BY Total_Revenue DESC;

--Product Line with Largest VAT--
sp_rename 'dbo.WalmartSalesData.Tax_5', 'VAT', 'COLUMN';

SELECT Product_line, ROUND(AVG(VAT),2) AS AVG_VAT
FROM DBO.WalmartSalesData
GROUP BY Product_line
ORDER BY AVG_VAT DESC;

--Branches that sold more than average--
SELECT Branch, SUM(Quantity) AS Qty
FROM dbo.WalmartSalesData
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM dbo.WalmartSalesData);

--Common Product Line per Gender--
SELECT DISTINCT Gender, COUNT(Product_line) AS cnt, Product_line
FROM dbo.WalmartSalesData
GROUP BY Gender, Product_line
ORDER BY cnt DESC;

--Average Rating per Product Line--
SELECT Product_line, ROUND(AVG(Rating),2) AS avg_rating
FROM dbo.WalmartSalesData
GROUP BY Product_line
ORDER BY avg_rating DESC;

--Number of Sales made at different times of the day--
SELECT time_of_day, COUNT(Invoice_ID) AS Sales
FROM WalmartSalesData
WHERE day_of_week = 'Monday'
GROUP BY time_of_day
ORDER BY Sales DESC;

--Customer Type that brings the most revenue--
SELECT Customer_type, ROUND(SUM(Total),2) AS Revenue
FROM WalmartSalesData
GROUP BY Customer_type
ORDER BY Revenue DESC;

--City with the highest VAT--
SELECT City, ROUND(AVG(VAT),2) AS VAT
FROM WalmartSalesData
GROUP BY City
ORDER BY VAT DESC;

--Customers paying the most VAT--
SELECT Customer_type, ROUND(AVG(VAT),2) AS VAT
FROM WalmartSalesData
GROUP BY Customer_type
ORDER BY VAT DESC;

--Unique Customer Types--
SELECT DISTINCT Customer_type
FROM WalmartSalesData
GROUP BY Customer_type;

--Unique Payment Methods--
SELECT DISTINCT Payment_method, COUNT(Payment_method) AS cnt 
FROM WalmartSalesData
GROUP BY Payment_method
ORDER BY cnt;

--Most Common Customer Type--
SELECT DISTINCT Customer_type, COUNT(Customer_type) AS cnt
FROM WalmartSalesData
GROUP BY Customer_type
ORDER BY cnt;

--Customer Type buying the most--
SELECT Customer_type, COUNT(*) AS Count_Customer
FROM WalmartSalesData
GROUP BY Customer_type
ORDER BY Count_Customer;

--Gender of most customers--
SELECT Gender, COUNT(*) AS Customers
FROM WalmartSalesData
GROUP BY Gender
ORDER BY Customers DESC;

--Gender Distribution per Branch--
SELECT Gender, COUNT(*) AS Gender_Count
FROM WalmartSalesData
WHERE Branch = 'A'
GROUP BY Gender
ORDER BY Gender_Count;

--Time of the day with most customer ratings--
SELECT time_of_day, AVG(Rating) AS Rate
FROM WalmartSalesData
GROUP BY time_of_day
ORDER BY Rate DESC;

--Time of the day with most customer ratings per branch--
SELECT time_of_day, AVG(Rating) AS Rate
FROM WalmartSalesData
WHERE Branch = 'B'
GROUP BY time_of_day
ORDER BY Rate DESC;

--Day of the week with the best average customer ratings--
SELECT day_of_week, AVG(Rating) AS Rate
FROM WalmartSalesData
GROUP BY day_of_week
ORDER BY Rate DESC;

--Day of the week with the best average customer ratings per branch--
SELECT day_of_week, AVG(Rating) AS Rate
FROM WalmartSalesData
WHERE Branch = 'A'
GROUP BY day_of_week
ORDER BY Rate DESC;
-- comment
/* 
* multi-line comments
*/

CREATE DATABASE GETTrainingEvening 

USE GETTrainingEvening

CREATE SCHEMA SSM

CREATE TABLE SSM.Employees(
Eid TINYINT,
Ename Varchar(40)
)

INSERT INTO SSM.Employees 
	VALUES (1,'Sakshi')

INSERT INTO SSM.Employees (Eid, Ename)
	VALUES (2,'SakshiS')

INSERT INTO SSM.Employees (Eid)
	VALUES (3)

INSERT INTO SSM.Employees
	VALUES (4,'')

INSERT INTO SSM.Employees
	VALUES (5,null)

SELECT Ename,Salary FROM SSM.Employee\
SELECT * FROM SSM.Employee

DROP TABLE SSM.Employees 

DROP SCHEMA SSM

DROP DATABASE GETTrainingEvening

CREATE TABLE SSM.Employee(
Eid INT PRIMARY KEY IDENTITY(1,1),
Ename VARCHAR(20) NOT NULL,
Email NVARCHAR(50) UNIQUE,
Number BIGINT CHECK(LEN(Number)=10),
Salary MONEY CHECK(Salary>0),
DOJ DATE DEFAULT GETDATE()
)

INSERT INTO SSM.Employee (Ename, Email, Number, Salary)
	VALUES ('Diya', 'd@test.com', 1234567809, 2510)

SELECT * FROM SSM.Employee

ALTER TABLE SSM.Employee ADD Address VARCHAR(50)
ALTER TABLE SSM.Employee ADD Addresss1 VARCHAR(50) DEFAULT 'TEST'

ALTER TABLE SSM.Employee DROP Constraint DF__Employee__Addres__3B75D760

ALTER TABLE SSM.Employee DROP COLUMN Address

TRUNCATE TABLE SSM.Employee

/*
1. Arithmetic Operators: Perform mathematical calculations. +, -, *, /, % (Remainder)
2. Comparison Operators: Compare two values.
	 =, !=, >, <, >=, <=
3. Logical Operators: Combine multiple conditions.
	 AND, OR, NOT
4. BETWEEN: Selects values within a range.
5. IN: Matches one of several possible values.
6. LIKE: Searches for a specified pattern.
7. IS NULL / IS NOT NULL: Checks for NULL values.
8. Aggregate Functions: Perform calculations on multiple rows of data.
	COUNT(), SUM(), AVG(), MIN(), MAX()
*/

--Rename a column
EXECUTE sp_rename 'SSM.Employee','Employees'

EXECUTE sp_rename 'SSM.Employees.Number','MNumber','COLUMN'

Alter table SSM.Employees DROP constraint CK__Employee__Number__38996AB5

SELECT * FROM SSM.Employees

INSERT INTO SSM.Employees (Ename, Email, MNumber, Salary)
	VALUES ('Diya', 'd1@test.com', 1234567809, 2510)

UPDATE SSM.Employees 
SET EName ='Devanshu'

--DATA CLONING: copying your data
/* 1. SELECT INTO: Selects the given value from table and clones into another table. No Table structure required.
	2. INSERT INTO...SELECT: Clones by Inserting value in another table from values you used in select. Table Structure required.
	*/
	
--1. SELECT INTO:
SELECT *
INTO TargetTable
FROM SSM.Employees

SELECT * FROM TargetTable

DROP Table TargetTable

TRUNCATE Table TargetTable

--Insert Into... SELECT:

INSERT INTO TargetTable (Ename,Email)
	SELECT Ename,Email 
	FROM SSM.Employees

--WHERE: Filter Data

SELECT * FROM production.products 
WHERE product_id>=10+2

SELECT * FROM sales.order_items
WHERE list_price<1000-(500+200)

SELECT 100*2, product_id
FROM sales.order_items

--Alias
SELECT Ename AS [Name] from SSM.Employees

SELECT *
From sales.staffs
WHERE manager_id>2 AND active=1

SELECT *
From sales.staffs
WHERE manager_id>2 OR active!=1

SELECT *
From sales.staffs
WHERE not manager_id>=2

SELECT *
FROM sales.order_items
WHERE product_id BETWEEN 2 AND 5 
AND list_price>500

SELECT * 
FROM sales.order_items
WHERE order_id IN (4,6,6,8,9)

--LIKE: Filteration of values - %, _

SELECT *
FROM production.products 
WHERE product_name LIKE 'EL% 2018'

SELECT *
FROM production.products
WHERE product_name LIKE '_r_k%'

SELECT *
FROM production.products
WHERE product_name LIKE '%20__'

SELECT *
FROM production.products
WHERE product_name LIKE '%s''%'

SELECT *
FROM production.products
WHERE product_name LIKE '%[0-7]%'

--NOT, NOT NULL
SELECT *
FROM sales.orders
WHERE shipped_date is NULL

SELECT *
FROM sales.orders
WHERE shipped_date is NOT NULL

--DISTINCT

SELECT DISTINCT(category_id)
FROM production.products

SELECT DISTINCT(category_id), brand_id
FROM production.products

SELECT DISTINCT category_id, brand_id
FROM production.products

--ORDER BY: ASC, DESC

SELECT * 
FROM production.products
ORDER BY product_id desc

SELECT product_name, model_year, list_price 
FROM production.products
ORDER BY list_price, product_id desc

SELECT * 
FROM production.products
ORDER BY LEN(product_name) desc

--TOP: fetch first n values from the top

SELECT TOP 5 * 
FROM production.products
order by list_price desc

SELECT TOP 10 * 
FROM production.products
ORDER BY NEWID() --to get random products

SELECT TOP (10) PERCENT * 
FROM production.products

SELECT TOP 5 WITH TIES * 
FROM production.products
order by list_price

SELECT *
FROM production.products
ORDER BY 1,2

--DATA AGGREGATION: 

SELECT MAX(list_price) as MaxPrice
FROM production.products

SELECT MIN(list_price) as Minprice	
	FROM production.products ;

SELECT SUM(list_price) as Sumprice
	FROM production.products ;

SELECT AVG(list_price) as AVGprice	
	FROM production.products ;

SELECT  COUNT(product_id) as prod_count	
	FROM production.products ;

SELECT product_name,
list_price,
MAX(list_price)as MaxPrice,
MIN(list_price) as MinPrice,
SUM(list_price) as SumPrice,
AVG(list_price) as AVGPrice,
COUNT(Product_id) as ProductCount
FROM production.products
GROUP BY product_name, list_price

SELECT product_name,
list_price,
MAX(list_price)as MaxPrice,
MIN(list_price) as MinPrice,
SUM(list_price) as SumPrice,
AVG(list_price) as AVGPrice,
COUNT(Product_id) as ProductCount
FROM production.products
GROUP BY product_name, list_price
HAVING list_price>1500

-- Fetch year only
SELECT DISTINCT(YEAR(required_date)) as [Year] 
	FROM sales.orders

--CONCATENATE 2 Strings
SELECT first_name+' '+last_name
FROM sales.customers

SELECT CONCAT(first_name,' ', last_name) as 'Customer Name', email
FROM sales.customers

/* JOINS: Used for joining multiple tables
1. Inner Join/Join - returns only the rows that have matching values in both tables. No match, no value
2. Left Join/ Left Outer Join - returns all the rows from the left table (first table), and the matched rows
from the right table (second table). If there is no match, NULL values are returned for
columns from the right table.
3. Right Join/ Right Outer Join - e opposite of a LEFT JOIN. It returns all the rows from the right table
and the matching rows from the left table. If there is no match, NULL values are
returned for columns from the left table.
4. CROSS JOIN - returns the Cartesian product of the two tables. This means it returns all
possible combinations of rows between the two tables. It doesn’t require any condition
or matching columns. 
5. Self JOIN
*/

SELECT *
FROM sales.customers
INNER JOIN sales.orders
ON sales.customers.customer_id = sales.orders.customer_id

SELECT *
FROM sales.customers [sc]
INNER JOIN sales.orders [so]
ON [sc].customer_id = [so].customer_id

SELECT [sc].customer_id, first_name, email, order_date
FROM sales.customers [sc]
INNER JOIN sales.orders [so]
ON [sc].customer_id = [so].customer_id

SELECT *
FROM sales.customers [sc]
LEFT JOIN sales.orders [so]
ON [sc].customer_id = [so].customer_id

SELECT *
FROM sales.customers [sc]
RIGHT JOIN sales.orders [so]
ON [sc].customer_id = [so].customer_id

SELECT *
FROM sales.customers [sc]
CROSS JOIN sales.orders [so]

SELECT CONCAT(sc.first_name,' ', sc.last_name) as [Customer Name],
order_date, order_status,
CONCAT(sf.first_name,' ', sf.last_name) as [Staff Name]
FROM sales.customers sc
JOIN sales.orders so ON sc.customer_id = so.customer_id
JOIN sales.staffs sf ON  sf.staff_id = so.staff_id
GROUP BY sc.first_name, sc.last_name, order_date, order_status, sf.first_name, sf.last_name

SELECT 
ss.store_id,store_name,product_name,sf.first_name,
SUM(quantity*soi.list_price*(1-discount)) AS [Net Sales Product]
from sales.stores ss
CROSS JOIN production.products pp
LEFT JOIN sales.order_items soi ON pp.product_id =  soi.product_id
INNER JOIN sales.orders so ON so.order_id = soi.order_id
INNER JOIN sales.staffs sf ON sf.staff_id = so.staff_id
GROUP BY ss.store_id,store_name,product_name,sf.first_name
ORDER BY [Net Sales Product]

--SELF JOIN

SELECT * FROM sales.staffs

SELECT s.staff_id, CONCAT(s.first_name,' ', s.last_name) as [Staff Name], s.manager_id,
CONCAT(ss.first_name,' ', ss.last_name) as [Manager Name]
FROM sales.staffs s
LEFT JOIN sales.staffs ss
ON ss.staff_id = s.manager_id

--SUBQUERY: Nested Query
--SELECT, FROM, WHERE

SELECT first_name, COUNT(order_id)
FROM sales.customers sc
INNER JOIN sales.orders so
ON so.customer_id = sc.customer_id
GROUP BY first_name

SELECT sc.first_name,
(SELECT COUNT(so.order_id) 
FROM sales.orders so
WHERE so.customer_id = sc.customer_id) AS [Total Order]
FROM sales.customers sc
ORDER BY first_name

-- WHERE Clause

SELECT * 
FROM sales.order_items
WHERE list_price <
( SELECT AVG(list_price)
FROM sales.order_items
)

SELECT product_id, product_name
FROM production.products
WHERE product_id IN (
SELECT distinct(product_id) 
FROM sales.order_items
)

--FROM CLause
SELECT pp.product_name, sq.[Total Qty]
FROM production.products pp
INNER JOIN
( SELECT product_id, SUM(quantity) as [Total Qty]
FROM sales.order_items
GROUP BY product_id
)sq
ON sq.product_id = pp.product_id

--CTE (Common Table Expression)
/* A CTE is a temporary result set that you can refer within a SELECT, UPDATE, INSERT or DELETE statement.

SYNTAX:
WITH CTE_Name(Column1, Column2,...)
AS(
--INNER Query
SELECT ...
)

--OUTER Query
SELECT * FROM CTE_Name
*/

WITH cte_prodQuantity
As (
SELECT pp.product_name, sq.[Total Qty]
FROM production.products pp
INNER JOIN
( SELECT product_id, SUM(quantity) as [Total Qty]
FROM sales.order_items
GROUP BY product_id
)sq
ON sq.product_id = pp.product_id
)

SELECT * FROM cte_prodQuantity

--sales amounts by sales staffs in 2018
WITH cte_StaffSales(staff, sales, year)
As(
SELECT first_name + ' '+ last_name,
SUM(quantity * list_price * (1-discount)),
YEAR(order_date)
FROM sales.orders o
INNER JOIN sales.order_items i ON i.order_id = o.order_id
INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
GROUP BY first_name, last_name, YEAR(order_date)
)

SELECT staff, sales, year FROM cte_StaffSales
WHERE YEAR=2018

-- Report averages based on counts

WITH cte_sales
AS(
SELECT staff_id, 
COUNT(order_id) as order_count
FROM sales.orders
WHERE YEAR(order_date) = 2018
GROUP BY staff_id
)

select AVG(order_count) as [Average order]
FROM cte_sales

--Multiple CTE in Single query
WITH cte_CategoryWiseProductCount
(c_id,c_name,p_count)
AS
(
SELECT 
c.category_id, 
c.category_name, 
COUNT(p.product_id)
FROM production.products p
INNER JOIN production.categories c 
ON c.category_id = p.category_id
GROUP BY  c.category_id, c.category_name
),
cte_CategoryWiseProductSales (cat_id,sales)
AS
(
	SELECT    
			p.category_id, 
			SUM(i.quantity * i.list_price * (1 - i.discount))
		FROM    
			sales.order_items i
			INNER JOIN production.products p 
				ON p.product_id = i.product_id
			INNER JOIN sales.orders o 
				ON o.order_id = i.order_id
		WHERE order_status = 4 -- completed
		GROUP BY 
			p.category_id
)

SELECT cc.c_id, cc.c_name, cc.p_count, cs.sales As [NET Sales]
from cte_CategoryWiseProductCount cc
INNER JOIN cte_CategoryWiseProductSales cs
ON cc.c_id = cs.cat_id

--CTE insert example (Data cloning)
CREATE TABLE SourceData
(
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Amount DECIMAL(10, 2)
);

CREATE TABLE TargetData
(
    TargetID INT PRIMARY KEY,
    TargetName NVARCHAR(100),
    TargetAmount DECIMAL(10, 2)
);

-- Sample data in SourceData
INSERT INTO SourceData (ID, Name, Amount)
VALUES
(1, 'Alice', 100.00),
(2, 'Bob', 200.00),
(3, 'Charlie', 150.00),
(4, 'David', 300.00);

WITH cte_FilterData
As (
SELECT ID as TargetID,
Name as TargetName,
Amount As TargetAmount
From SourceData WHERE Amount>150
)

INSERT INTO TargetData(TargetID, TargetName, TargetAmount)
SELECT TargetID, TargetName, TargetAmount FROM cte_FilterData

SELECt * FROM TargetData

--UPDATE CTE
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

CREATE TABLE Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100)
);

-- Sample data in Departments
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');	

-- Sample data in Employees
INSERT INTO Employees (EmployeeID, EmployeeName, DepartmentID, Salary)
VALUES
(1, 'Alice', 1, 50000.00),
(2, 'Bob', 2, 60000.00),
(3, 'Charlie', 2, 70000.00),
(4, 'David', 3, 80000.00);


select * from Departments;
select * from Employees

WITH UpdatedSalaries AS(
SELECT e.EmployeeID, e.EmployeeName,
e.salary * 1.5 As NewSalary
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT'
)

UPDATE e
SET e.Salary = us.NewSalary
FROM Employees e
INNER JOIN UpdatedSalaries us
ON e.EmployeeID = us.EmployeeID

-- Built-In Functions
--Aggregate Functions: COUNT, MIN, MAX< SUM, AVG

--String Functions: CONCAT(), LEN(), UPPER(), LOWER(), SUBSTRING(), REPLACE(), REVERSE()

SELECT LEN(first_name) FROM sales.customers

SELECT SUBSTRING(first_name, 3, 4) from Sales.customers

SELECT REPLACE(product_name, 'Trek','Trek2') FROM production.products

SELECT UPPER(first_name) FROM sales.customers

--DATE and TIME Functions : YEAR, MONTH, DAY, GETDATE

SELECT GETDATE()

SELECT DATEADD(YEAR, 2, GETDATE())
SELECT DATEADD(MONTH, 2, GETDATE())
SELECT DATEADD(DAY, 2, '2023-12-04 09:00:00')

SELECT DATEDIFF(YEAR, '2024-04-09', GETDATE())

SELECT FORMAT(GETDATE(),'yyyy-MM,dd')
SELECT FORMAT(GETDATE(),'dd/MM/yy HH:mm:ss')

SELECT CONVERT(VARCHAR, GETDATE(), 102) 
SELECT CONVERT(VARCHAR, GETDATE()-5, 102) 

--Mathematical Functions: AVG, SUM,ABS, FLOOR, CEILING, ROUND
SELECT ABS(-48.7)

SELECT AVG(list_price) FROM sales.order_items

SELECT ROUND(AVG(list_price),3) FROM sales.order_items

SELECT CAST(ROUND(AVG(list_price),3) As DEC(10,2)) FROM sales.order_items

--Logical Functions: ISNULL, COALESCE

SELECT ISNULL(phone,'N/A') As Phone 
FROM sales.customers

SELECT COALESCE(phone,'N/A') As Phone 
FROM sales.customers

SELECT COALESCE(NULL, NULL, 200,NULL,20, NULL)

/*

CAST – Cast a value of one type to another.
CONVERT – Convert a value of one type to another.
CHOOSE – Return one of the two values based on the result of the first argument.
ISNULL – Replace NULL with a specified value.
ISNUMERIC – Check if an expression is a valid numeric type.
IIF – Add if-else logic to a query.
TRY_CAST – Cast a value of one type to another and return NULL if the cast fails.
TRY_CONVERT – Convert a value of one type to another and return the value to be translated into the specified type. It returns NULL if the cast fails.
TRY_PARSE – Convert a string to a date/time or a number and return NULL if the conversion fails.
   Convert datetime to string – Show you how to convert a datetime value to a string in a specified format.
   Convert string to datetime – Describe how to convert a string to a datetime value.
Convert datetime to date – Convert a datetime to a date.
GENERATE_SERIES() – Generate a series of numbers within a specific range.
*/

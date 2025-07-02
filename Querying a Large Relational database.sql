--Problem Statement:
--How to get details about customers by querying a database?
--Topics:
--In this project, you will work on downloading a database and restoring it on the
--server. You will then query the database to get customer details like name, phone
----number, email ID, sales made in a particular month, increase in month-on-month
--sales and even the total sales made to a particular customer.
--Highlights:
--Table basics and data types
--Various SQL operators
--Various SQL functions
--Tasks To Be Performed:
--1. Download the AdventureWorks database from the following location and
--restore it in your server:
--Location:
--https://github.com/Microsoft/sql-server-samples/releases/tag/adventurewor
--ks
--File Name: AdventureWorks2012.bak
--AdventureWorks is a sample database shipped with SQL Server and it can
--be downloaded from the GitHub site. AdventureWorks has replaced
--Northwind and Pubs sample databases that were available in SQL Server
--in 2005. Microsoft keeps updating the sample database as it releases new
--versions.
--2. Restore Backup:
--Follow the below steps to restore a backup of your database using SQL
--Server Management Studio:
--a. Open SQL Server Management Studio and connect to the target
--SQL Server instance
--b. Right-click on the Databases Node and select Restore Database
--c. Select Device and click on the ellipsis (...)
--d. In the dialog box, select Backup devices, click on Add, navigate to
--the database backup in the file system of the server, select the
--backup, and click on OK.
--e. If needed, change the target location for the data and log files in the
--Files pane
--Note: It is a best practice to place the data and log files on different
--drives.
--f. Now, click on OK
--This will initiate the database restore. After it completes, you will have the
--AdventureWorks database installed on your SQL Server instance.
--3. Perform the following with help of the above database:
--a. Get all the details from the person table including email ID, phone
--number and phone number type
--b. Get the details of the sales header order made in May 2011
--c. Get the details of the sales details order made in the month of May
--2011
--d. Get the total sales made in May 2011
--e. Get the total sales made in the year 2011 by month order by
--increasing sales
--f. Get the total sales made to the customer with FirstName='Gustavo'





use AdventureWorks2012

--Get all the details from the person table including email ID, phone
--number and phone number Type
SELECT 
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    ea.EmailAddress,
    pp.PhoneNumber,
    pnt.Name AS PhoneNumberType
FROM 
    Person.Person p
LEFT JOIN 
    Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID
LEFT JOIN 
    Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
LEFT JOIN 
    Person.PhoneNumberType pnt ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID;

--Get the details of the sales header order made in May 2011
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2011-05-01' AND '2011-05-31';

--Get the details of the sales details order made in the month of May
--2011
SELECT sod.*
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate BETWEEN '2011-05-01' AND '2011-05-31';

--Total sales made in May 2011
SELECT SUM(TotalDue) AS TotalSalesMay2011
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2011-05-01' AND '2011-05-31';

--Total monthly sales for 2011, ordered by increasing sales
SELECT 
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalDue) AS MonthlySales
FROM 
    Sales.SalesOrderHeader
WHERE 
    YEAR(OrderDate) = 2011
GROUP BY 
    MONTH(OrderDate)
ORDER BY 
    MonthlySales ASC;

 --Total sales to customer 
 SELECT SUM(soh.TotalDue) AS TotalSalesToGustavo
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE 
    p.FirstName = 'Gustavo' AND p.LastName = 'Achong';

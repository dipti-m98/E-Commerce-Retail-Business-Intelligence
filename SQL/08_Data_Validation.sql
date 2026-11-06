
USE EcommerceRetailDB;
GO

-- 1. Record count validation

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRecords FROM Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderDetails', COUNT(*) FROM OrderDetails
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payments
UNION ALL
SELECT 'Returns', COUNT(*) FROM Returns;
GO

-- 2. Check duplicate primary keys

SELECT CustomerID, COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;

SELECT ProductID, COUNT(*) AS DuplicateCount
FROM Products
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- 3. Check missing important values

SELECT *
FROM Customers
WHERE CustomerName IS NULL
   OR City IS NULL
   OR State IS NULL;

SELECT *
FROM Products
WHERE ProductName IS NULL
   OR UnitPrice IS NULL
   OR UnitCost IS NULL;

-- 4. Check invalid prices

SELECT *
FROM Products
WHERE UnitPrice <= 0
   OR UnitCost <= 0;

-- 5. Check invalid quantities and discounts

SELECT *
FROM OrderDetails
WHERE Quantity <= 0
   OR Discount < 0
   OR Discount > 100;

-- 6. Check orphan customer records

SELECT O.*
FROM Orders O
LEFT JOIN Customers C
    ON O.CustomerID = C.CustomerID
WHERE C.CustomerID IS NULL;

-- 7. Check orphan product records

SELECT OD.*
FROM OrderDetails OD
LEFT JOIN Products P
    ON OD.ProductID = P.ProductID
WHERE P.ProductID IS NULL;

-- 8. Check payments without orders

SELECT Pay.*
FROM Payments Pay
LEFT JOIN Orders O
    ON Pay.OrderID = O.OrderID
WHERE O.OrderID IS NULL;

-- 9. Check returns without order details

SELECT R.*
FROM Returns R
LEFT JOIN OrderDetails OD
    ON R.OrderDetailID = OD.OrderDetailID
WHERE OD.OrderDetailID IS NULL;
GO

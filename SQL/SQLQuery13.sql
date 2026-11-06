
-- 6.1 Create the views
USE EcommerceRetailDB;
GO

-- 1. Detailed sales view
CREATE OR ALTER VIEW vw_OrderLineDetails
AS
SELECT
    O.OrderID,
    O.OrderDate,
    O.OrderStatus,
    O.CustomerID,
    C.CustomerName,
    C.Gender,
    C.City,
    C.State,

    OD.OrderDetailID,
    OD.ProductID,
    P.ProductName,
    P.Category,
    P.SubCategory,

    OD.Quantity,
    OD.UnitPrice,
    OD.Discount,
    P.UnitCost,

    CAST(
        OD.Quantity * OD.UnitPrice *
        (1 - OD.Discount / 100.0)
        AS DECIMAL(14,2)
    ) AS Revenue,

    CAST(
        OD.Quantity * P.UnitCost
        AS DECIMAL(14,2)
    ) AS TotalCost,

    CAST(
        OD.Quantity *
        (OD.UnitPrice * (1 - OD.Discount / 100.0)
         - P.UnitCost)
        AS DECIMAL(14,2)
    ) AS GrossProfit,

    R.ReturnStatus,
    R.ReturnReason,

    CASE
        WHEN R.ReturnStatus IN ('Approved', 'Completed')
        THEN 1 ELSE 0
    END AS AcceptedReturnFlag

FROM Orders O
INNER JOIN Customers C
    ON O.CustomerID = C.CustomerID
INNER JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
INNER JOIN Products P
    ON OD.ProductID = P.ProductID
LEFT JOIN Returns R
    ON OD.OrderDetailID = R.OrderDetailID;
GO


-- 2. Monthly sales view
CREATE OR ALTER VIEW vw_MonthlySales
AS
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(Revenue) AS TotalRevenue,
    SUM(GrossProfit) AS GrossProfit,
    SUM(Quantity) AS UnitsSold,
    COUNT(DISTINCT OrderID) AS TotalOrders
FROM vw_OrderLineDetails
WHERE OrderStatus = 'Delivered'
GROUP BY YEAR(OrderDate), MONTH(OrderDate);
GO


-- 3. Category performance view
CREATE OR ALTER VIEW vw_CategoryPerformance
AS
SELECT
    Category,
    SUM(Quantity) AS UnitsSold,
    SUM(Revenue) AS TotalRevenue,
    SUM(TotalCost) AS TotalCost,
    SUM(GrossProfit) AS GrossProfit
FROM vw_OrderLineDetails
WHERE OrderStatus = 'Delivered'
GROUP BY Category;
GO


-- 4. Product performance view
CREATE OR ALTER VIEW vw_ProductPerformance
AS
SELECT
    ProductID,
    ProductName,
    Category,
    SubCategory,
    SUM(Quantity) AS UnitsSold,
    SUM(Revenue) AS TotalRevenue,
    SUM(GrossProfit) AS GrossProfit
FROM vw_OrderLineDetails
WHERE OrderStatus = 'Delivered'
GROUP BY
    ProductID,
    ProductName,
    Category,
    SubCategory;
GO


-- 5. Customer performance view
CREATE OR ALTER VIEW vw_CustomerPerformance
AS
SELECT
    CustomerID,
    CustomerName,
    Gender,
    City,
    State,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    SUM(Revenue) AS TotalRevenue,
    SUM(GrossProfit) AS GrossProfit
FROM vw_OrderLineDetails
WHERE OrderStatus = 'Delivered'
GROUP BY
    CustomerID,
    CustomerName,
    Gender,
    City,
    State;
GO

-- 6.2 Verify that all five views were created
-- Execute this query:


SELECT
    TABLE_NAME AS ViewName
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME LIKE 'vw_%'
ORDER BY TABLE_NAME;
GO

-- 6.3 Test your views

SELECT TOP 10 * FROM vw_OrderLineDetails;
SELECT * FROM vw_MonthlySales;
SELECT * FROM vw_CategoryPerformance;
SELECT TOP 10 * FROM vw_ProductPerformance;
SELECT TOP 10 * FROM vw_CustomerPerformance;


--KPI 1 — Overall business performance
USE EcommerceRetailDB;
GO

-- Overall business performance
-- Only delivered orders are included.

SELECT
    COUNT(DISTINCT O.OrderID) AS TotalOrders,

    SUM(OD.Quantity) AS UnitsSold,

    CAST(
        SUM(OD.Quantity * OD.UnitPrice *
            (1 - OD.Discount / 100.0))
        AS DECIMAL(14,2)
    ) AS TotalRevenue,

    CAST(
        SUM(OD.Quantity * P.UnitCost)
        AS DECIMAL(14,2)
    ) AS TotalCost,

    CAST(
        SUM(
            OD.Quantity *
            (OD.UnitPrice * (1 - OD.Discount / 100.0)
             - P.UnitCost)
        )
        AS DECIMAL(14,2)
    ) AS GrossProfit,

    CAST(
        100.0 * SUM(
            OD.Quantity *
            (OD.UnitPrice * (1 - OD.Discount / 100.0)
             - P.UnitCost)
        )
        / NULLIF(
            SUM(OD.Quantity * OD.UnitPrice *
                (1 - OD.Discount / 100.0)), 0
        )
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercentage,

    CAST(
        SUM(OD.Quantity * OD.UnitPrice *
            (1 - OD.Discount / 100.0))
        / NULLIF(COUNT(DISTINCT O.OrderID), 0)
        AS DECIMAL(12,2)
    ) AS AverageOrderValue

FROM Orders O
INNER JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
INNER JOIN Products P
    ON OD.ProductID = P.ProductID
WHERE O.OrderStatus = 'Delivered';
GO


--------------------------------
--KPI 2 — Monthly revenue trend

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,

    DATENAME(MONTH, O.OrderDate) AS MonthName,

    CAST(
        SUM(OD.Quantity * OD.UnitPrice *
            (1 - OD.Discount / 100.0))
        AS DECIMAL(14,2)
    ) AS MonthlyRevenue

FROM Orders O
INNER JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID

WHERE O.OrderStatus = 'Delivered'

GROUP BY
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)

ORDER BY SalesYear, SalesMonth;
GO

-----------------------
--KPI 3 — Category-wise sales and profit

SELECT
    P.Category,

    SUM(OD.Quantity) AS UnitsSold,

    CAST(
        SUM(OD.Quantity * OD.UnitPrice *
            (1 - OD.Discount / 100.0))
        AS DECIMAL(14,2)
    ) AS Revenue,

    CAST(
        SUM(
            OD.Quantity *
            (OD.UnitPrice * (1 - OD.Discount / 100.0)
             - P.UnitCost)
        )
        AS DECIMAL(14,2)
    ) AS GrossProfit

FROM Orders O
INNER JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
INNER JOIN Products P
    ON OD.ProductID = P.ProductID

WHERE O.OrderStatus = 'Delivered'

GROUP BY P.Category
ORDER BY Revenue DESC;
GO

-------------
--KPI 4 — Top 10 best-selling products

SELECT TOP 10
    P.ProductName,
    P.Category,

    SUM(OD.Quantity) AS UnitsSold,

    CAST(
        SUM(OD.Quantity * OD.UnitPrice *
            (1 - OD.Discount / 100.0))
        AS DECIMAL(14,2)
    ) AS Revenue

FROM Orders O
INNER JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
INNER JOIN Products P
    ON OD.ProductID = P.ProductID

WHERE O.OrderStatus = 'Delivered'

GROUP BY
    P.ProductName,
    P.Category

ORDER BY UnitsSold DESC;
GO

-----------------
--KPI 5 — Return rate

SELECT
    COUNT(DISTINCT OD.OrderDetailID) AS TotalDeliveredLines,

    COUNT(DISTINCT CASE
        WHEN R.ReturnStatus IN ('Approved', 'Completed')
        THEN OD.OrderDetailID
    END) AS AcceptedReturnLines,

    CAST(
        100.0 * COUNT(DISTINCT CASE
            WHEN R.ReturnStatus IN ('Approved', 'Completed')
            THEN OD.OrderDetailID
        END)
        / NULLIF(COUNT(DISTINCT OD.OrderDetailID), 0)
        AS DECIMAL(10,2)
    ) AS ReturnRatePercentage

FROM Orders O
INNER JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
LEFT JOIN Returns R
    ON OD.OrderDetailID = R.OrderDetailID

WHERE O.OrderStatus = 'Delivered';
GO





USE EcommerceRetailDB;
GO

-- Check that customers exist
IF (SELECT COUNT(*) FROM Customers) < 1000
BEGIN
    THROW 50001, 'Please insert 1,000 customers first.', 1;
END;
GO

-- Generate 2,000 synthetic orders

;WITH Numbers AS
(
    SELECT TOP (2000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO Orders
(
    CustomerID,
    OrderDate,
    OrderStatus,
    ShippingCity,
    ShippingState
)
SELECT
    C.CustomerID,

    DATEADD(
        DAY,
        -(ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 730),
        CAST(GETDATE() AS DATE)
    ),

    CASE ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 10
        WHEN 0 THEN 'Cancelled'
        WHEN 1 THEN 'Pending'
        ELSE 'Delivered'
    END,

    C.City,
    C.State

FROM Numbers N

CROSS APPLY
(
    SELECT TOP 1
        CustomerID,
        City,
        State
    FROM Customers
    ORDER BY NEWID()
) C;
GO

-- Verify order records
SELECT COUNT(*) AS TotalOrders
FROM Orders;

-- Check order status distribution
SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus;

-- Preview orders with customer details
SELECT TOP 10
    O.OrderID,
    O.CustomerID,
    C.CustomerName,
    O.OrderDate,
    O.OrderStatus,
    O.ShippingCity,
    O.ShippingState
FROM Orders O
INNER JOIN Customers C
    ON O.CustomerID = C.CustomerID
ORDER BY O.OrderID;
GO

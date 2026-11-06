
USE EcommerceRetailDB;
GO

-- Check existing data
IF (SELECT COUNT(*) FROM Orders) < 2000
    THROW 50001, 'Please insert orders first.', 1;

IF (SELECT COUNT(*) FROM Products) < 200
    THROW 50002, 'Please insert products first.', 1;

IF EXISTS (SELECT 1 FROM OrderDetails)
    THROW 50003, 'OrderDetails already contains data.', 1;
GO

-- Generate 6,000 OrderDetails records

INSERT INTO OrderDetails
(
    OrderID,
    ProductID,
    Quantity,
    UnitPrice,
    Discount
)
SELECT
    O.OrderID,
    P.ProductID,
    1 + ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 4,
    P.UnitPrice,
    (ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 7) * 5

FROM Orders AS O

CROSS JOIN
(
    VALUES (1), (2), (3)
) AS L(ItemNumber)

INNER JOIN Products AS P
    ON P.ProductID =
       ((O.OrderID + L.ItemNumber * 67 - 1) % 200) + 1;
GO

-- Verify the result
SELECT COUNT(*) AS TotalOrderDetails
FROM OrderDetails;

SELECT TOP 10 *
FROM OrderDetails
ORDER BY OrderDetailID;
GO

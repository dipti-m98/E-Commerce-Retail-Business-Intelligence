
USE EcommerceRetailDB;
GO

-- Check required data
IF (SELECT COUNT(*) FROM Orders) < 2000
    THROW 50001, 'Please create 2,000 orders first.', 1;

IF (SELECT COUNT(*) FROM OrderDetails) < 5000
    THROW 50002, 'Please create OrderDetails records first.', 1;

IF EXISTS (SELECT 1 FROM Payments)
    THROW 50003, 'Payments already contains data. Do not run again.', 1;
GO

-- Generate one payment per order

INSERT INTO Payments
(
    OrderID,
    PaymentDate,
    PaymentMethod,
    PaymentStatus,
    Amount
)
SELECT
    O.OrderID,
    O.OrderDate,

    CASE ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 4
        WHEN 0 THEN 'UPI'
        WHEN 1 THEN 'Credit Card'
        WHEN 2 THEN 'Debit Card'
        ELSE 'Net Banking'
    END,

    CASE
        WHEN O.OrderStatus = 'Cancelled' THEN 'Refunded'
        WHEN O.OrderStatus = 'Pending' THEN 'Pending'
        ELSE 'Successful'
    END,

    CAST(
        SUM(
            OD.Quantity * OD.UnitPrice *
            (1 - OD.Discount / 100.0)
        )
        AS DECIMAL(12,2)
    )

FROM Orders O
INNER JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID

GROUP BY
    O.OrderID,
    O.OrderDate,
    O.OrderStatus;
GO

-- Verify payment records
SELECT COUNT(*) AS TotalPayments
FROM Payments;

-- Payment status analysis
SELECT
    PaymentStatus,
    COUNT(*) AS PaymentCount,
    SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY PaymentStatus;

-- Preview payment data
SELECT TOP 10 *
FROM Payments
ORDER BY PaymentID;
GO

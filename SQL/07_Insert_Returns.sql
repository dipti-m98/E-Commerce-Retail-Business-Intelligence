
USE EcommerceRetailDB;
GO

-- Check required data
IF (SELECT COUNT(*) FROM OrderDetails) < 5000
    THROW 50001, 'Please generate OrderDetails data first.', 1;

IF (SELECT COUNT(*) FROM Payments) < 2000
    THROW 50002, 'Please generate Payments data first.', 1;

IF EXISTS (SELECT 1 FROM Returns)
    THROW 50003, 'Returns already contains data. Do not run again.', 1;
GO

-- Generate 250 returns for delivered orders

;WITH EligibleReturns AS
(
    SELECT TOP (250)
        OD.OrderDetailID,
        O.OrderDate
    FROM OrderDetails OD
    INNER JOIN Orders O
        ON OD.OrderID = O.OrderID
    WHERE O.OrderStatus = 'Delivered'
    ORDER BY NEWID()
)
INSERT INTO Returns
(
    OrderDetailID,
    ReturnDate,
    ReturnReason,
    ReturnStatus
)
SELECT
    OrderDetailID,

    DATEADD(
        DAY,
        ABS(CONVERT(BIGINT, CHECKSUM(NEWID())))
        % (DATEDIFF(DAY, OrderDate, CAST(GETDATE() AS DATE)) + 1),
        OrderDate
    ),

    CASE ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 5
        WHEN 0 THEN 'Damaged Product'
        WHEN 1 THEN 'Wrong Product'
        WHEN 2 THEN 'Size Issue'
        WHEN 3 THEN 'Quality Issue'
        ELSE 'Changed Mind'
    END,

    CASE ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 3
        WHEN 0 THEN 'Approved'
        WHEN 1 THEN 'Completed'
        ELSE 'Rejected'
    END

FROM EligibleReturns;
GO

-- Verify return records
SELECT COUNT(*) AS TotalReturns
FROM Returns;

-- Return reason analysis
SELECT
    ReturnReason,
    COUNT(*) AS ReturnCount
FROM Returns
GROUP BY ReturnReason
ORDER BY ReturnCount DESC;

-- Return status analysis
SELECT
    ReturnStatus,
    COUNT(*) AS StatusCount
FROM Returns
GROUP BY ReturnStatus;
GO

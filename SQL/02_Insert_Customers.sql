
USE EcommerceRetailDB;
GO

-- Generate 1,000 synthetic customers

;WITH Numbers AS
(
    SELECT TOP (1000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO Customers
(
    CustomerName,
    Gender,
    Age,
    City,
    State,
    RegistrationDate
)
SELECT
    CASE ID % 10
        WHEN 0 THEN 'Aarav'
        WHEN 1 THEN 'Priya'
        WHEN 2 THEN 'Rahul'
        WHEN 3 THEN 'Sneha'
        WHEN 4 THEN 'Rohan'
        WHEN 5 THEN 'Ananya'
        WHEN 6 THEN 'Vikram'
        WHEN 7 THEN 'Neha'
        WHEN 8 THEN 'Arjun'
        ELSE 'Pooja'
    END
    + ' ' +
    CASE ID % 8
        WHEN 0 THEN 'Sharma'
        WHEN 1 THEN 'Patil'
        WHEN 2 THEN 'Verma'
        WHEN 3 THEN 'Deshmukh'
        WHEN 4 THEN 'Gupta'
        WHEN 5 THEN 'Joshi'
        WHEN 6 THEN 'Kulkarni'
        ELSE 'Mehta'
    END,

    CASE ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 3
        WHEN 0 THEN 'Male'
        WHEN 1 THEN 'Female'
        ELSE 'Other'
    END,

    18 + ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 48,

    CASE ID % 10
        WHEN 0 THEN 'Mumbai'
        WHEN 1 THEN 'Pune'
        WHEN 2 THEN 'Delhi'
        WHEN 3 THEN 'Bengaluru'
        WHEN 4 THEN 'Hyderabad'
        WHEN 5 THEN 'Chennai'
        WHEN 6 THEN 'Kolkata'
        WHEN 7 THEN 'Ahmedabad'
        WHEN 8 THEN 'Jaipur'
        ELSE 'Nagpur'
    END,

    CASE ID % 10
        WHEN 0 THEN 'Maharashtra'
        WHEN 1 THEN 'Maharashtra'
        WHEN 2 THEN 'Delhi'
        WHEN 3 THEN 'Karnataka'
        WHEN 4 THEN 'Telangana'
        WHEN 5 THEN 'Tamil Nadu'
        WHEN 6 THEN 'West Bengal'
        WHEN 7 THEN 'Gujarat'
        WHEN 8 THEN 'Rajasthan'
        ELSE 'Maharashtra'
    END,

    DATEADD
    (
        DAY,
        - (ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 1460),
        CAST(GETDATE() AS DATE)
    )
FROM Numbers;
GO

-- Verify customer records
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

SELECT TOP 10 *
FROM Customers
ORDER BY CustomerID;
GO

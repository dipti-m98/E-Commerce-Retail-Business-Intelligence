
USE EcommerceRetailDB;
GO

-- Generate 200 synthetic products

;WITH Numbers AS
(
    SELECT TOP (200)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID
    FROM sys.all_objects
)
INSERT INTO Products
(
    ProductName,
    Category,
    SubCategory,
    UnitPrice,
    UnitCost,
    StockQuantity
)
SELECT
    V.SubCategory + ' Model ' + CAST(N.ID AS VARCHAR(10)),

    V.Category,
    V.SubCategory,

    P.UnitPrice,

    CAST(P.UnitPrice * 0.60 AS DECIMAL(10,2)),

    ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 501
FROM Numbers N

CROSS APPLY
(
    SELECT
        CASE N.ID % 10
            WHEN 0 THEN 'Electronics'
            WHEN 1 THEN 'Clothing'
            WHEN 2 THEN 'Beauty'
            WHEN 3 THEN 'Home & Kitchen'
            WHEN 4 THEN 'Sports'
            WHEN 5 THEN 'Electronics'
            WHEN 6 THEN 'Clothing'
            WHEN 7 THEN 'Beauty'
            WHEN 8 THEN 'Home & Kitchen'
            ELSE 'Sports'
        END AS Category,

        CASE N.ID % 10
            WHEN 0 THEN 'Mobile Accessories'
            WHEN 1 THEN 'Mens Wear'
            WHEN 2 THEN 'Skincare'
            WHEN 3 THEN 'Kitchen Appliances'
            WHEN 4 THEN 'Fitness Equipment'
            WHEN 5 THEN 'Audio Devices'
            WHEN 6 THEN 'Womens Wear'
            WHEN 7 THEN 'Makeup'
            WHEN 8 THEN 'Home Decor'
            ELSE 'Outdoor Sports'
        END AS SubCategory
) V

CROSS APPLY
(
    SELECT
        CAST(
            500 + (ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) % 19501)
            AS DECIMAL(10,2)
        ) AS UnitPrice
) P;
GO

-- Verify product records
SELECT COUNT(*) AS TotalProducts
FROM Products;

SELECT Category, COUNT(*) AS ProductCount
FROM Products
GROUP BY Category
ORDER BY Category;

SELECT TOP 10 *
FROM Products
ORDER BY ProductID;
GO

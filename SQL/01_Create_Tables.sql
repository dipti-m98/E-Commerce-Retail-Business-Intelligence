
USE EcommerceRetailDB;
GO

-- 1. Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Gender VARCHAR(20),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    RegistrationDate DATE
);
GO

-- 2. Products
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    UnitCost DECIMAL(10,2),
    StockQuantity INT
);
GO

-- 3. Orders
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE,
    OrderStatus VARCHAR(30),
    ShippingCity VARCHAR(50),
    ShippingState VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- 4. Order Details
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(5,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- 5. Payments
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATE,
    PaymentMethod VARCHAR(30),
    PaymentStatus VARCHAR(30),
    Amount DECIMAL(12,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- 6. Returns
CREATE TABLE Returns (
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDetailID INT NOT NULL,
    ReturnDate DATE,
    ReturnReason VARCHAR(100),
    ReturnStatus VARCHAR(30),
    FOREIGN KEY (OrderDetailID) REFERENCES OrderDetails(OrderDetailID)
);
GO

-- Verify tables
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

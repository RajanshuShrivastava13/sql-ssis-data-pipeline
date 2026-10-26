-- 1. Database Creation
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'RetailECommerceDB')
BEGIN
    CREATE DATABASE RetailECommerceDB;
END
GO

USE RetailECommerceDB;
GO

-- 2. Drop Tables if already exist (Clean Script Practice)
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

-- 3. Customers Table
CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    City VARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 4. Products Table
CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(101,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice > 0),
    StockQuantity INT DEFAULT 0
);

-- 5. Orders Table (Relational Table)
CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1001,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES dbo.Products(ProductID),
    OrderDate DATETIME DEFAULT GETDATE(),
    Quantity INT CHECK (Quantity > 0),
    TotalAmount DECIMAL(12,2),
    OrderStatus VARCHAR(20) DEFAULT 'Completed'
);
GO
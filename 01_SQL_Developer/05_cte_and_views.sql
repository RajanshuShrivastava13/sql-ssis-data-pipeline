USE RetailECommerceDB;
GO

-- 1. Common Table Expression (CTE): हाई वैल्यू कस्टमर्स ढूँढना
WITH HighValueOrders AS (
    SELECT 
        CustomerID,
        SUM(TotalAmount) AS TotalSpent,
        COUNT(OrderID) AS TotalOrders
    FROM dbo.Orders
    WHERE OrderStatus = 'Completed'
    GROUP BY CustomerID
)
SELECT 
    c.FirstName + ' ' + c.LastName AS CustomerName,
    hv.TotalSpent,
    hv.TotalOrders
FROM HighValueOrders hv
JOIN dbo.Customers c ON hv.CustomerID = c.CustomerID
WHERE hv.TotalSpent > 10000;
GO

-- 2. CREATE VIEW: सेल्स समरी व्यू (Reporting ready)
CREATE OR ALTER VIEW dbo.vw_SalesSummary AS
SELECT 
    o.OrderID,
    o.OrderDate,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.City,
    p.ProductName,
    p.Category,
    o.Quantity,
    o.TotalAmount,
    o.OrderStatus
FROM dbo.Orders o
JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
JOIN dbo.Products p ON o.ProductID = p.ProductID;
GO

-- View से डेटा देखने के लिए:
-- SELECT * FROM dbo.vw_SalesSummary;
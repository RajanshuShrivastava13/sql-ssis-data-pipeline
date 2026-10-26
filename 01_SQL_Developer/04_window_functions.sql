USE RetailECommerceDB;
GO

-- 1. ROW_NUMBER, RANK, DENSE_RANK: प्रोडक्ट्स को प्राइस के हिसाब से रैंक करना
SELECT 
    ProductID,
    ProductName,
    Category,
    UnitPrice,
    ROW_NUMBER() OVER(PARTITION BY Category ORDER BY UnitPrice DESC) AS RowNum,
    RANK() OVER(PARTITION BY Category ORDER BY UnitPrice DESC) AS RankNum,
    DENSE_RANK() OVER(PARTITION BY Category ORDER BY UnitPrice DESC) AS DenseRankNum
FROM dbo.Products;

-- 2. SUM() OVER(): रनिंग टोटल (Cumulative Sales) निकालना
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER(ORDER BY OrderDate) AS RunningTotalSales
FROM dbo.Orders
WHERE OrderStatus = 'Completed';

-- 3. LAG() and LEAD(): पिछले और अगले ऑर्डर का अमाउंट देखना
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount, 1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderAmount,
    LEAD(TotalAmount, 1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrderAmount
FROM dbo.Orders;
GO
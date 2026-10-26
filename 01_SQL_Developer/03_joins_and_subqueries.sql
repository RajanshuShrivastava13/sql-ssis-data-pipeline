USE RetailECommerceDB;
GO

-- 1. INNER JOIN: केवल वे ऑर्डर्स जिनका कस्टमर और प्रोडक्ट मौजूद है
SELECT 
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.ProductName,
    o.Quantity,
    o.TotalAmount,
    o.OrderDate
FROM dbo.Orders o
INNER JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
INNER JOIN dbo.Products p ON o.ProductID = p.ProductID;

-- 2. LEFT JOIN: सभी कस्टमर्स और उनके ऑर्डर्स (अगर ऑर्डर नहीं भी किया तो भी दिखेंगे)
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderID,
    o.TotalAmount
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON c.CustomerID = o.CustomerID;

-- 3. SUBQUERY: उन प्रोडक्ट्स की लिस्ट जिनका प्राइस एवरेज प्राइस से ज्यादा है
SELECT ProductName, Category, UnitPrice
FROM dbo.Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM dbo.Products);

-- 4. CORRELATED SUBQUERY: प्रत्येक कस्टमर का कुल खर्चा (Total Spent)
SELECT 
    c.CustomerID,
    c.FirstName,
    (SELECT ISNULL(SUM(TotalAmount), 0) 
     FROM dbo.Orders o 
     WHERE o.CustomerID = c.CustomerID AND o.OrderStatus = 'Completed') AS TotalSpent
FROM dbo.Customers c;
GO
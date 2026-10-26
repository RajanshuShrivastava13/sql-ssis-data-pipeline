USE RetailECommerceDB;
GO

-- 1. Inserting 30 Records into Customers Table
INSERT INTO dbo.Customers (FirstName, LastName, Email, City, CreatedDate)
VALUES 
('Rahul', 'Sharma', 'rahul.sharma@gmail.com', 'Bhopal', '2024-01-15'),
('Priya', 'Verma', 'priya.verma@yahoo.com', 'Indore', '2024-01-18'),
('Amit', 'Patel', 'amit.patel@gmail.com', 'Jabalpur', '2024-01-20'),
('Neha', 'Singh', 'neha.singh@outlook.com', 'Delhi', '2024-01-25'),
('Rohan', 'Gupta', 'rohan.gupta@gmail.com', 'Mumbai', '2024-02-01'),
('Suresh', 'Kumar', 'suresh.kumar@gmail.com', 'Bhopal', '2024-02-05'),
('Ananya', 'Roy', 'ananya.roy@yahoo.com', 'Kolkata', '2024-02-10'),
('Vikram', 'Rathore', 'vikram.r@gmail.com', 'Jaipur', '2024-02-12'),
('Pooja', 'Mishra', 'pooja.mishra@outlook.com', 'Indore', '2024-02-15'),
('Karan', 'Joshi', 'karan.j@gmail.com', 'Pune', '2024-02-18'),
('Sneha', 'Reddy', 'sneha.reddy@yahoo.com', 'Hyderabad', '2024-02-20'),
('Deepak', 'Yadav', 'deepak.y@gmail.com', 'Delhi', '2024-02-22'),
('Ritu', 'Saxena', 'ritu.s@outlook.com', 'Bhopal', '2024-02-25'),
('Manish', 'Chouhan', 'manish.c@gmail.com', 'Jabalpur', '2024-03-01'),
('Kavita', 'Thakur', 'kavita.t@yahoo.com', 'Indore', '2024-03-04'),
('Sanjay', 'Dube', 'sanjay.d@gmail.com', 'Gwalior', '2024-03-08'),
('Aarti', 'Mehta', 'aarti.m@outlook.com', 'Mumbai', '2024-03-10'),
('Alok', 'Pandey', 'alok.p@gmail.com', 'Satna', '2024-03-12'),
('Shweta', 'Tiwari', 'shweta.t@yahoo.com', 'Rewa', '2024-03-15'),
('Gaurav', 'Bhatt', 'gaurav.b@gmail.com', 'Delhi', '2024-03-18'),
('Monika', 'Jain', 'monika.j@outlook.com', 'Indore', '2024-03-20'),
('Nitin', 'Agarwal', 'nitin.a@gmail.com', 'Bhopal', '2024-03-22'),
('Preeti', 'Deshmukh', 'preeti.d@yahoo.com', 'Nagpur', '2024-03-25'),
('Rajesh', 'Soni', 'rajesh.s@gmail.com', 'Ujjain', '2024-03-28'),
('Divya', 'Srivastava', 'divya.s@outlook.com', 'Prayagraj', '2024-04-01'),
('Tarun', 'Kapoor', 'tarun.k@gmail.com', 'Chandigarh', '2024-04-03'),
('Megha', 'Bansal', 'megha.b@yahoo.com', 'Delhi', '2024-04-05'),
('Ashish', 'Nair', 'ashish.n@gmail.com', 'Bangalore', '2024-04-08'),
('Komal', 'Tripathi', 'komal.t@outlook.com', 'Varanasi', '2024-04-10'),
('Sunil', 'Verma', 'sunil.v@gmail.com', 'Bhopal', '2024-04-12');

-- 2. Inserting 30 Records into Products Table
INSERT INTO dbo.Products (ProductName, Category, UnitPrice, StockQuantity)
VALUES 
('Laptop', 'Electronics', 55000.00, 15),
('Smartphone', 'Electronics', 25000.00, 30),
('Wireless Mouse', 'Accessories', 800.00, 100),
('Mechanical Keyboard', 'Accessories', 3500.00, 50),
('Office Chair', 'Furniture', 8500.00, 20),
('USB-C Cable', 'Accessories', 450.00, 200),
('Gaming Monitor', 'Electronics', 18500.00, 25),
('Bluetooth Speaker', 'Electronics', 3200.00, 40),
('Ergonomic Desk', 'Furniture', 14500.00, 12),
('HD Webcam', 'Electronics', 2800.00, 60),
('External Hard Drive 1TB', 'Storage', 4200.00, 45),
('Pen Drive 64GB', 'Storage', 650.00, 150),
('Laptop Stand', 'Accessories', 1200.00, 80),
('Over-Ear Headphones', 'Electronics', 4900.00, 35),
('Wireless Earbuds', 'Electronics', 2900.00, 70),
('Power Bank 20000mAh', 'Electronics', 1800.00, 90),
('Study Lamp', 'Furniture', 1100.00, 50),
('Smartwatch', 'Electronics', 5200.00, 40),
('MicroSD Card 128GB', 'Storage', 950.00, 120),
('Graphic Tablet', 'Electronics', 7500.00, 18),
('HDMI Cable 2m', 'Accessories', 350.00, 180),
('Screenguard Pack', 'Accessories', 250.00, 250),
('Backpack for Laptop', 'Accessories', 1600.00, 65),
('Bookshelf Unit', 'Furniture', 6800.00, 15),
('Wi-Fi Router', 'Electronics', 2200.00, 55),
('Surge Protector', 'Electronics', 850.00, 85),
('Wireless Presenter', 'Accessories', 1400.00, 30),
('Cleaning Kit', 'Accessories', 300.00, 200),
('Adjustable Stool', 'Furniture', 3200.00, 25),
('Cable Organizer Clip', 'Accessories', 150.00, 300);

-- 3. Inserting 35 Records into Orders Table
INSERT INTO dbo.Orders (CustomerID, ProductID, OrderDate, Quantity, TotalAmount, OrderStatus)
VALUES 
(1, 101, '2024-04-01', 1, 55000.00, 'Completed'),
(2, 102, '2024-04-02', 2, 50000.00, 'Completed'),
(3, 103, '2024-04-03', 5, 4000.00, 'Completed'),
(1, 104, '2024-04-05', 1, 3500.00, 'Pending'),
(4, 105, '2024-04-10', 2, 17000.00, 'Completed'),
(5, 102, '2024-04-12', 1, 25000.00, 'Cancelled'),
(6, 106, '2024-04-13', 3, 1350.00, 'Completed'),
(7, 107, '2024-04-14', 1, 18500.00, 'Completed'),
(8, 108, '2024-04-15', 2, 6400.00, 'Completed'),
(9, 109, '2024-04-15', 1, 14500.00, 'Pending'),
(10, 110, '2024-04-16', 1, 2800.00, 'Completed'),
(11, 111, '2024-04-17', 2, 8400.00, 'Completed'),
(12, 112, '2024-04-18', 4, 2600.00, 'Completed'),
(13, 113, '2024-04-18', 1, 1200.00, 'Cancelled'),
(14, 114, '2024-04-19', 1, 4900.00, 'Completed'),
(15, 115, '2024-04-20', 2, 5800.00, 'Completed'),
(16, 116, '2024-04-21', 1, 1800.00, 'Pending'),
(17, 117, '2024-04-22', 2, 2200.00, 'Completed'),
(18, 118, '2024-04-22', 1, 5200.00, 'Completed'),
(19, 119, '2024-04-23', 3, 2850.00, 'Completed'),
(20, 120, '2024-04-24', 1, 7500.00, 'Completed'),
(21, 101, '2024-04-25', 1, 55000.00, 'Completed'),
(22, 103, '2024-04-25', 2, 1600.00, 'Completed'),
(23, 105, '2024-04-26', 1, 8500.00, 'Pending'),
(24, 108, '2024-04-26', 1, 3200.00, 'Completed'),
(25, 121, '2024-04-27', 5, 1750.00, 'Completed'),
(26, 123, '2024-04-27', 2, 3200.00, 'Completed'),
(27, 125, '2024-04-28', 1, 2200.00, 'Cancelled'),
(28, 115, '2024-04-28', 1, 2900.00, 'Completed'),
(29, 102, '2024-04-29', 1, 25000.00, 'Completed'),
(30, 107, '2024-04-29', 1, 18500.00, 'Completed'),
(2, 111, '2024-04-30', 1, 4200.00, 'Completed'),
(5, 114, '2024-04-30', 1, 4900.00, 'Completed'),
(8, 118, '2024-05-01', 1, 5200.00, 'Completed'),
(12, 104, '2024-05-01', 2, 7000.00, 'Pending');
GO

-- Verification Queries
SELECT COUNT(*) AS TotalCustomers FROM dbo.Customers;
SELECT COUNT(*) AS TotalProducts FROM dbo.Products;
SELECT COUNT(*) AS TotalOrders FROM dbo.Orders;
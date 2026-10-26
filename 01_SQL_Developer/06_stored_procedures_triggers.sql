USE RetailECommerceDB;
GO

-- 1. STORED PROCEDURE: नया ऑर्डर प्लेस करना और स्टॉक ऑटो-अपडेट करना (Corrected TRY...CATCH)
CREATE OR ALTER PROCEDURE dbo.usp_PlaceNewOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @UnitPrice DECIMAL(10,2);
        DECLARE @Stock INT;
        
        SELECT @UnitPrice = UnitPrice, @Stock = StockQuantity 
        FROM dbo.Products WHERE ProductID = @ProductID;
        
        -- स्टॉक चेक करें
        IF @Stock < @Quantity
        BEGIN
            RAISERROR('पर्याप्त स्टॉक उपलब्ध नहीं है!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- इंसर्ट ऑर्डर
        INSERT INTO dbo.Orders (CustomerID, ProductID, OrderDate, Quantity, TotalAmount, OrderStatus)
        VALUES (@CustomerID, @ProductID, GETDATE(), @Quantity, (@UnitPrice * @Quantity), 'Completed');

        -- अपडेट स्टॉक
        UPDATE dbo.Products
        SET StockQuantity = StockQuantity - @Quantity
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;
        PRINT 'ऑर्डर सफलतापूर्वक दर्ज किया गया!';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- एरर थ्रो करें
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- 2. TRIGGER: जब नया कस्टमर आए तो लॉग मैसेजेस या डिफ़ॉल्ट एक्शन लेना
CREATE OR ALTER TRIGGER dbo.trg_AfterCustomerInsert
ON dbo.Customers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'नया कस्टमर सफलतापूर्वक जोड़ा गया!';
END;
GO
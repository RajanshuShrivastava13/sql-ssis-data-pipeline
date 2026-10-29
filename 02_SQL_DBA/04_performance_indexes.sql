-- =====================================================================
-- File: 04_performance_indexes.sql
-- Module: 02_SQL_DBA
-- Description: Index Maintenance, Fragmentation Analysis & Statistics Update
-- =====================================================================

USE Inventory_DB;
GO

-- Sample Table for Index Demonstration
CREATE TABLE InventoryItems (
    ItemID INT IDENTITY(1,1),
    ItemSKU VARCHAR(50),
    ItemName VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT
);

CREATE CLUSTERED INDEX CIX_InventoryItems_ItemID ON InventoryItems(ItemID);
CREATE NONCLUSTERED INDEX NCIX_InventoryItems_Category ON InventoryItems(Category);
GO

-- 1. Check Index Fragmentation Status (Using sys.dm_db_index_physical_stats)
SELECT 
    object_name(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.index_type_desc AS IndexType,
    ips.avg_fragmentation_in_percent AS FragmentationPercent,
    ips.page_count AS PageCount
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 10;
GO

-- 2. Index Maintenance Decision Logic
-- Rule:
-- If Fragmentation > 30%  --> REBUILD
-- If Fragmentation 10-30% --> REORGANIZE

-- Reorganize Index (Low Fragmentation)
ALTER INDEX NCIX_InventoryItems_Category ON InventoryItems REORGANIZE;
GO

-- Rebuild Index (High Fragmentation)
ALTER INDEX CIX_InventoryItems_ItemID ON InventoryItems REBUILD WITH (ONLINE = OFF);
GO

-- 3. Update Statistics
UPDATE STATISTICS InventoryItems WITH FULLSCAN;
GO
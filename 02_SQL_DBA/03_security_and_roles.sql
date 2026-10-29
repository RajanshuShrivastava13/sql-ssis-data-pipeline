-- =====================================================================
-- File: 03_security_and_roles.sql
-- Module: 02_SQL_DBA
-- Description: Server Logins, Database Users, Custom Roles & Permissions
-- =====================================================================

USE master;
GO

-- 1. Server Logins Creation
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'DBA_Analyst')
    CREATE LOGIN DBA_Analyst WITH PASSWORD = 'StrongPassword123!', CHECK_POLICY = ON;

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'App_Service_User')
    CREATE LOGIN App_Service_User WITH PASSWORD = 'StrongPassword123!', CHECK_POLICY = ON;
GO

-- 2. Database Users Creation in Finance_DB
USE Finance_DB;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'User_Analyst')
    CREATE USER User_Analyst FOR LOGIN DBA_Analyst;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'User_AppService')
    CREATE USER User_AppService FOR LOGIN App_Service_User;
GO

-- 3. Creating Custom Database Role
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'db_finance_operator' AND type = 'R')
    CREATE ROLE db_finance_operator;
GO

-- Granting Permissions to Role
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO db_finance_operator;
DENY DELETE ON SCHEMA::dbo TO db_finance_operator;
GO

-- Assigning Users to Roles
IF NOT EXISTS (SELECT * FROM sys.database_role_members WHERE role_principal_id = USER_ID('db_finance_operator') AND member_principal_id = USER_ID('User_Analyst'))
    ALTER ROLE db_finance_operator ADD MEMBER User_Analyst;

IF NOT EXISTS (SELECT * FROM sys.database_role_members WHERE role_principal_id = USER_ID('db_datareader') AND member_principal_id = USER_ID('User_AppService'))
    ALTER ROLE db_datareader ADD MEMBER User_AppService;
GO

-- 4. Verification Query for User Permissions
SELECT 
    dp.name AS DatabaseUser,
    dp.type_desc AS UserType,
    drm.name AS AssociatedRole
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members rm ON dp.principal_id = rm.member_principal_id
LEFT JOIN sys.database_principals drm ON rm.role_principal_id = drm.principal_id
WHERE dp.type IN ('S', 'U');
GO
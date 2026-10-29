-- =====================================================================
-- File: 01_database_setup.sql
-- Module: 02_SQL_DBA
-- Author: Rajanshu Shrivastava
-- Description: Creating 3 DBA practice databases with custom filegroups
-- =====================================================================

USE master;
GO

-- 1. Finance_DB (Custom Filegroups & Multi-file Architecture)
IF DB_ID('Finance_DB') IS NOT NULL
BEGIN
    ALTER DATABASE Finance_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Finance_DB;
END
GO

CREATE DATABASE Finance_DB
ON PRIMARY 
(
    NAME = N'Finance_DB_Primary',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Finance_DB_Prm.mdf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
),
FILEGROUP Finance_FG_Data
(
    NAME = N'Finance_DB_Data',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Finance_DB_Data.ndf',
    SIZE = 20MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 10MB
)
LOG ON 
(
    NAME = N'Finance_DB_Log',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Finance_DB_Log.ldf',
    SIZE = 10MB,
    MAXSIZE = 200MB,
    FILEGROWTH = 5MB
);
GO

-- 2. Healthcare_DB (Full Recovery Model for Production / Point-in-Time Recovery)
IF DB_ID('Healthcare_DB') IS NOT NULL
BEGIN
    ALTER DATABASE Healthcare_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Healthcare_DB;
END
GO

CREATE DATABASE Healthcare_DB;
GO
ALTER DATABASE Healthcare_DB SET RECOVERY FULL;
GO

-- 3. Inventory_DB (Simple Recovery Model for High Throughput / Reporting)
IF DB_ID('Inventory_DB') IS NOT NULL
BEGIN
    ALTER DATABASE Inventory_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Inventory_DB;
END
GO

CREATE DATABASE Inventory_DB;
GO
ALTER DATABASE Inventory_DB SET RECOVERY SIMPLE;
GO

-- Verification Query
SELECT name AS DatabaseName, recovery_model_desc AS RecoveryModel, state_desc AS State
FROM sys.databases
WHERE name IN ('Finance_DB', 'Healthcare_DB', 'Inventory_DB');
GO
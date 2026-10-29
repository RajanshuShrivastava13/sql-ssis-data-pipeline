-- =====================================================================
-- File: 02_backup_recovery.sql
-- Module: 02_SQL_DBA
-- Description: Full, Differential, Log Backups, Integrity Check & Restoration
-- =====================================================================

USE Healthcare_DB;
GO

-- Table Drop check if exists, then Create
IF OBJECT_ID('dbo.PatientRecords', 'U') IS NOT NULL
    DROP TABLE dbo.PatientRecords;
GO

CREATE TABLE PatientRecords (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    PatientName VARCHAR(100),
    AdmissionDate DATETIME DEFAULT GETDATE()
);
GO

INSERT INTO PatientRecords (PatientName) VALUES ('Rahul Verma'), ('Anjali Sharma');
GO

-- 1. Database Integrity Check
DBCC CHECKDB('Healthcare_DB') WITH NO_INFOMSGS, ALL_ERRORMSGS;
GO

-- 2. FULL BACKUP (Make sure 'F:\SQL_Backups\' folder exists on your PC)
BACKUP DATABASE Healthcare_DB
TO DISK = 'F:\SQL_Backups\Healthcare_DB_Full.bak'
WITH FORMAT, INIT, NAME = 'Healthcare_DB Full Backup', STATS = 10;
GO

-- Insert More Records (Simulating Day Transactions)
INSERT INTO PatientRecords (PatientName) VALUES ('Suresh Patel');
GO

-- 3. DIFFERENTIAL BACKUP
BACKUP DATABASE Healthcare_DB
TO DISK = 'F:\SQL_Backups\Healthcare_DB_Diff.bak'
WITH DIFFERENTIAL, INIT, NAME = 'Healthcare_DB Diff Backup', STATS = 10;
GO

-- Insert Urgent Log Data
INSERT INTO PatientRecords (PatientName) VALUES ('Priya Gupta');
GO

-- 4. TRANSACTION LOG BACKUP (Note: Database must be in FULL Recovery mode)
ALTER DATABASE Healthcare_DB SET RECOVERY FULL;
GO

BACKUP LOG Healthcare_DB
TO DISK = 'F:\SQL_Backups\Healthcare_DB_Log.trn'
WITH INIT, NAME = 'Healthcare_DB Log Backup', STATS = 10;
GO

-- 5. RESTORE DEMO
RESTORE DATABASE Healthcare_DB_Restored
FROM DISK = 'F:\SQL_Backups\Healthcare_DB_Full.bak'
WITH NORECOVERY,
MOVE 'Healthcare_DB' TO 'F:\SQL_Backups\Healthcare_DB_Restored.mdf',
MOVE 'Healthcare_DB_log' TO 'F:\SQL_Backups\Healthcare_DB_Restored.ldf';

RESTORE DATABASE Healthcare_DB_Restored
FROM DISK = 'F:\SQL_Backups\Healthcare_DB_Diff.bak'
WITH NORECOVERY;

RESTORE LOG Healthcare_DB_Restored
FROM DISK = 'F:\SQL_Backups\Healthcare_DB_Log.trn'
WITH RECOVERY;
GO
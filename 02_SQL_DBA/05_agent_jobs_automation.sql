-- =====================================================================
-- File: 05_agent_jobs_automation.sql
-- Module: 02_SQL_DBA
-- Description: SQL Server Agent Job Automation for Daily Maintenance
-- =====================================================================

USE msdb;
GO

-- 1. Create Job Category
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
    EXEC msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance';
END
GO

-- 2. Create Agent Job: "Daily_FinanceDB_FullBackup"
EXEC dbo.sp_add_job
    @job_name = N'Daily_FinanceDB_FullBackup',
    @enabled = 1,
    @description = N'Automated Daily Full Backup for Finance_DB',
    @category_name = N'Database Maintenance';
GO

-- 3. Add Job Step (T-SQL Backup Command)
EXEC sp_add_jobstep
    @job_name = N'Daily_FinanceDB_FullBackup',
    @step_name = N'Execute_Full_Backup',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE Finance_DB TO DISK = ''C:\SQL_Backups\Finance_DB_Daily.bak'' WITH FORMAT, INIT;',
    @database_name = N'Finance_DB';
GO

-- 4. Create Schedule (Everyday at 01:00 AM)
EXEC sp_add_schedule
    @schedule_name = N'Daily_Nightly_1AM',
    @freq_type = 4,              -- Daily
    @freq_interval = 1,          -- Every 1 Day
    @active_start_time = 010000; -- 01:00:00 AM
GO

-- 5. Attach Schedule to Job
EXEC sp_attach_schedule
   @job_name = N'Daily_FinanceDB_FullBackup',
   @schedule_name = N'Daily_Nightly_1AM';
GO

-- 6. Add Target Server (Local Server)
EXEC sp_add_jobserver
    @job_name = N'Daily_FinanceDB_FullBackup',
    @server_name = N'(LOCAL)';
GO
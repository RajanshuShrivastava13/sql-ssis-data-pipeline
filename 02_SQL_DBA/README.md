चलिए, अब हमारे DBA प्रोजेक्ट की पाँचवीं और अंतिम महत्वपूर्ण फाइल **`05_agent_jobs_automation.sql`** को बिल्कुल विस्तार से line-by-line समझते हैं।

इस फाइल का मुख्य उद्देश्य **ऑटोमेशन (Automation), शेड्यूलिंग (Scheduling)** और **एंटरप्राइज़ मॉनिटरिंग (Enterprise Monitoring)** है। एक डेटाबेस एडमिनिस्ट्रेटर (DBA) के रूप में हम रोज़ाना मैन्युअल रूप से बैकअप, इंडेक्स मेंटेनेंस या इंटीग्रिटी चेक नहीं चला सकते। इसलिए SQL Server Agent का उपयोग करके इन सभी जरूरी कामों को स्वचालित (Automate) किया जाता है।

---

### **मॉड्यूल 05: `05_agent_jobs_automation.sql` (SQL Server Agent जॉब्स और ऑटोमेशन)**

इस स्क्रिप्ट को हम तार्किक चरणों में बांटकर समझते हैं:

#### **1. ऑपरेटर का निर्माण (Creating an Operator for Alerts)**

* **कोड स्वरूप:**
```sql
USE msdb;
GO

EXEC msdb.dbo.sp_add_operator
    @name = N'DBA_Team',
    @enabled = 1,
    @email_address = N'db_admin_alert@company.com';
GO

```


* **विस्तार:**
* **`msdb`** डेटाबेस वह सिस्टम डेटाबेस है जहाँ SQL Server Agent की सारी सेटिंग, जॉब्स और अलर्ट सेव होते हैं।
* **`sp_add_operator`** के जरिए एक ऑपरेटर (`DBA_Team`) बनाया जाता है। यदि रात में कभी कोई बैकअप फेल होता है या कोई गंभीर एरर आती है, तो SQL Server इसी ऑपरेटर (ईमेल या अलर्ट सिस्टम) को सूचना भेजता है।



---

#### **2. ऑटोमेटेड जॉब का निर्माण (Creating a SQL Server Agent Job)**

* **कोड स्वरूप:**
```sql
EXEC msdb.dbo.sp_add_job
    @job_name = N'Daily_DBA_Maintenance_Job',
    @enabled = 1,
    @description = N'Daily automated job for backup, integrity check, and index maintenance.';
GO

```


* **विस्तार:**
* **`sp_add_job`** के जरिए एक नया खाली जॉब शेड्यूलर तैयार किया जाता है जिसका नाम **`Daily_DBA_Maintenance_Job`** रखा गया है। `@enabled = 1` यह सुनिश्चित करता है कि यह जॉब एक्टिव है और निर्धारित समय पर चलेगा।



---

#### **3. जॉब स्टेप्स जोड़ना (Adding Job Steps)**

* **कोड स्वरूप:**
```sql
-- स्टेप 1: डेटाबेस इंटीग्रिटी चेक चलाना
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Daily_DBA_Maintenance_Job',
    @step_name = N'Step 1 - Run DBCC CHECKDB',
    @subsystem = N'TSQL',
    @command = N'DBCC CHECKDB(''Finance_DB'') WITH NO_INFOMSGS;',
    @on_success_action = 3; -- अगले स्टेप पर जाओ (Go to next step)
GO

-- स्टेप 2: फुल बैकअप लेना
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Daily_DBA_Maintenance_Job',
    @step_name = N'Step 2 - Take Full Backup',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE Finance_DB TO DISK = ''F:\SQL_Backups\Finance_DB_AutoFull.bak'' WITH INIT;',
    @on_success_action = 1; -- सफलता पर जॉब समाप्त करें
GO

```


* **विस्तार:**
* एक जॉब के अंदर कई चरण (Steps) हो सकते हैं।
* **Step 1** में डेटाबेस का हेल्थ चेक (`DBCC CHECKDB`) किया जाता है।
* **Step 2** में उसी डेटाबेस का सुरक्षित फुल बैकअप (`BACKUP DATABASE`) लिया जाता है।
* `@on_success_action = 3` का मतलब है कि अगर पहला स्टेप सफल होता है, तो वह स्वतः अगले स्टेप पर चला जाएगा।



---

#### **4. शेड्यूलिंग कॉन्फ़िगरेशन (Setting Up Job Schedule)**

* **कोड स्वरूप:**
```sql
EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'Nightly_Maintenance_Schedule',
    @freq_type = 4, -- दैनिक (Daily)
    @freq_interval = 1, -- हर 1 दिन पर
    @active_start_time = 010000; -- रात के 1:00 बजे (HHMMSS format)
GO

-- जॉब को शेड्यूल के साथ जोड़ना
EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'Daily_DBA_Maintenance_Job',
    @schedule_name = N'Nightly_Maintenance_Schedule';
GO

```


* **विस्तार:**
* **`sp_add_schedule`** के माध्यम से यह तय किया जाता है कि यह ऑटोमेशन कब चलना चाहिए। यहाँ `@freq_type = 4` का अर्थ दैनिक (Daily) है और `@active_start_time = 010000` का मतलब है कि यह हर रात ठीक **1:00 बजे** अपने आप रन होगा जब सर्वर पर यूजर ट्रैफिक कम होता है।
* **`sp_attach_schedule`** इस शेड्यूल को हमारे मुख्य जॉब (`Daily_DBA_Maintenance_Job`) के साथ बांध देता है।



---

#### **5. जॉब को सर्वर से जोड़ना (Enabling Job Server Target)**

* **कोड स्वरूप:**
```sql
EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'Daily_DBA_Maintenance_Job',
    @server_name = N'(LOCAL)';
GO

```


* **विस्तार:**
* अंत में, इस कमांड के जरिए SQL Server Agent को यह बताया जाता है कि इस जॉब को किस लोकल सर्वर पर एक्टिवेट करना है।



इस तरह, **`05_agent_jobs_automation.sql`** स्क्रिप्ट हमारे पूरे DBA प्रोजेक्ट को मैन्युअल मेहनत से निकालकर पूरी तरह ऑटोमेटेड और एंटरप्राइज़-रेडी बना देती है!
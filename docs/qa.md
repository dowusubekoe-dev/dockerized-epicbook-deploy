# Design a backup/restore routine:

## 🛡️ The EpicBook Backup & Restore Plan

### 1. Strategy Overview
We will use a **hybrid approach** to ensure data can be recovered from either a simple accidental deletion or a total VM failure.

* **What to Snapshot/Dump:** * **SQL Dump:** A logical backup of the `bookstore` database. This is portable and can be restored to any MySQL instance.
    * **Volume Snapshot:** A block-level backup of the `db_data` volume via the Cloud Provider (AWS EBS Snapshot or Azure Disk Backup).
* **When (Schedule):**
    * **Daily (3:00 AM):** Automated `mysqldump` triggered by a Cron job.
    * **Weekly (Sunday):** Full Cloud Disk Snapshot for disaster recovery.
* **Where (Location):**
    * **Primary:** Local VM directory (`~/backups/`) for quick restores.
    * **Secondary:** Object Storage (AWS S3 or Azure Blob Storage) to protect against VM termination.

---

### 2. Manual Test Proof (Execution Steps)

To provide the **before/after screenshots** required for your assignment, perform these steps:

#### **Step A: The "Before" Screenshot**
Run this command to show your 54 books are present:
```bash
docker exec epicbook-db mysql -u root -pyourpassword -e "SELECT COUNT(*) FROM bookstore.Book;"
```
> **📸 Capture Screenshot 1:** Terminal showing the count of 54.

#### **Step B: Perform the Backup**
Create the SQL dump file on your host machine:
```bash
docker exec epicbook-db mysqldump -u root -pyourpassword bookstore > ~/backups/epicbook_manual_balup.sql
```

#### **Step C: Simulate Data Loss**
Wipe the database table:
```bash
docker exec epicbook-db mysql -u root -pyourpassword -e "DROP TABLE bookstore.Book;"
```
*(Verify the website now shows 0 books or an error).*

#### **Step D: Perform the Restore**
Inject the backup file back into the container:
```bash
docker exec -i epicbook-db mysql -u root -pyourpassword bookstore < ~/backups/epicbook_manual_balup.sql
```

#### **Step E: The "After" Screenshot**
Run the count command again to verify the 54 books returned:
```bash
docker exec epicbook-db mysql -u root -pyourpassword -e "SELECT COUNT(*) FROM bookstore.Book;"
```
> **📸 Capture Screenshot 2:** Terminal showing the count of 54 restored.

---

### 3. Operational Runbook Snippet
Add these commands to your **09-runbook.md** so you can find them later:

* **Emergency Restore:** `docker exec -i epicbook-db mysql -u root -p[pass] [db] < backup.sql`
* **Verify Integrity:** `docker exec epicbook-db mysqlcheck -u root -p[pass] --all-databases`

**Do you want me to help you write the Cron job script to automate the "Daily" part of this plan?**

📸 What to put in your Doc
For your 05-persistence-and-backup.md file, your "Manual Test Proof" should now look like this:

Before: Screenshot of the COUNT(*) showing 54.

During: The command you used: SET FOREIGN_KEY_CHECKS = 0; DROP TABLE bookstore.Book;.

After: Screenshot of the COUNT(*) showing 54 again after the restore.
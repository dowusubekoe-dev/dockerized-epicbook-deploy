# Objective: Prove data survives container destruction.

- **Persistence:** Verified using a named volume db_data mapped to /var/lib/mysql.

- **Manual Test:** * Before: Ran docker-compose down -v to reset.

    - **After:** Ran docker-compose up -d. Verified 54 books exist in the Book table using SELECT COUNT(*).

- **Backup Strategy:** Logical backups are performed via mysqldump to the ~/backups/ directory on the host.
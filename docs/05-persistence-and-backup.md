# Objective: Prove data survives container destruction.

✅ Phase 5 — Persistence & Backups
DONE

db_data named volume persists MySQL data
Tested: docker compose down && docker compose up -d — data survived

```sql

docker compose exec db mysqldump -u root -pRootPass123 bookstore > backup_$(date +%Y%m%d).sql

```

- **Persistence:** Verified using a named volume db_data mapped to /var/lib/mysql.

- **Manual Test:** * Before: Ran docker-compose down -v to reset.

    - **After:** Ran docker-compose up -d. Verified 54 books exist in the Book table using SELECT COUNT(*).

- **Backup Strategy:** Logical backups are performed via mysqldump to the ~/backups/ directory on the host.
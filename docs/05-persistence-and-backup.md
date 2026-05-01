cat > docs/05-persistence-and-backup.md << 'EOF'
# Persistence & Backup Plan

## What Persists
| Data | Storage | Volume/Mount |
|------|---------|-------------|
| MySQL database | Named volume | db_data |
| Nginx logs | Bind mount | ./logs/nginx |
| App logs | stdout | docker compose logs |

## Persistence Test
1. Start stack: `docker compose up -d`
2. Add books to cart via browser
3. Stop stack: `docker compose down` (NO -v flag)
4. Restart stack: `docker compose up -d`
5. Verify cart data still present in browser

Result: Data survived restart because db_data volume persists
independently of container lifecycle.

## Backup Routine

### Manual Backup
```bash
docker compose exec db mysqldump \
  -u root -pRootPass123 bookstore \
  > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore
```bash
cat backup_20260501_120000.sql | \
  docker compose exec -T db \
  mysql -u root -pRootPass123 bookstore
```

### Automated Daily Backup (Cron)
```bash
crontab -e
# Add:
0 2 * * * cd /home/ubuntu/epicbook && \
  docker compose exec -T db mysqldump \
  -u root -pRootPass123 bookstore \
  > /home/ubuntu/backups/backup_$(date +\%Y\%m\%d).sql
```

### Backup Strategy
| What | When | Where |
|------|------|-------|
| SQL dump | Daily 2am | /home/ubuntu/backups/ |
| Volume snapshot | Weekly | AWS EBS snapshot |
| Nginx logs | Retained 30 days | ./logs/nginx/ on host |
EOF
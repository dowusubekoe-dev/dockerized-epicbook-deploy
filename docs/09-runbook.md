cat > docs/09-runbook.md << 'EOF'
# Operations Runbook — TheEpicBook

## Stack Management

### Start the Stack
```bash
cd /home/ubuntu/dockerized-epicbook-deploy
docker compose up -d
```

### Stop the Stack (preserve data)
```bash
docker compose down
```

### Stop and Wipe All Data
```bash
docker compose down -v   # WARNING: deletes database
```

### Rebuild After Code Change
```bash
docker compose up -d --build
```

### Check Status
```bash
docker compose ps
```

## Log Locations
| Log | Location |
|-----|----------|
| Nginx access | ./logs/nginx/access.log |
| Nginx error | ./logs/nginx/error.log |
| App logs | docker compose logs app |
| DB logs | docker compose logs db |

## Rotating Secrets
1. Update .env with new passwords
2. Run: docker compose down -v
3. Run: docker compose up -d --build
Note: -v wipes the DB volume so MySQL recreates with new password

## Backup & Restore
```bash
# Backup
docker compose exec db mysqldump -u root -pRootPass123 bookstore \
  > backup_$(date +%Y%m%d).sql

# Restore
cat backup_20260501.sql | docker compose exec -T db \
  mysql -u root -pRootPass123 bookstore
```

## Rollback Procedure
```bash
# Roll back to previous Git commit
git log --oneline          # find previous commit hash
git checkout <commit-hash>
docker compose up -d --build
```

## Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| ECONNREFUSED on port 3306 | App started before DB ready | Wait — app retries automatically |
| Access denied for user | Password mismatch | docker compose down -v, fix .env, restart |
| Proxy shows Created not Up | Port 80 conflict | sudo ss -tlnp grep 80, kill conflict |
| Cannot find module 'x' | Package not in package.json | npm install x --save, rebuild |
| Dialect needs to be supplied | JAWSDB_URL missing | Check .env has JAWSDB_URL, check env_file in compose |
EOF
# Ops Runbook: The EpicBook Production Stack

## 1\. Stack Administration

Commands must be executed from the project root directory on the Cloud VM.

  * **Start the Stack:** `docker compose up -d`
  * **Stop the Stack:** `docker compose down` (Warning: This stops all services)
  * **View Real-time Logs:** `docker compose logs -f`
  * **Check Service Health:** `docker ps --format "table {{.Names}}\t{{.Status}}"`

-----

## 2\. Backup & Restore Procedures

Refer to the [Persistence & Backup Plan](https://www.google.com/search?q=docs/05-persistence-and-backup.md) for full details.

### Manual Database Dump

```bash
docker exec dmi-ch2-mysql /usr/bin/mysqldump -u root -p$MYSQL_ROOT_PASSWORD epicbook > backup_$(date +%F).sql
```

### Restore from SQL File

```bash
cat backup_file.sql | docker exec -i dmi-ch2-mysql /usr/bin/mysql -u root -p$MYSQL_ROOT_PASSWORD epicbook
```

-----

## 3\. Secret Rotation & Management

If a password is compromised, follow these steps to rotate secrets:

1.  Update the values in the `.env` file on the VM.
2.  Restart the stack to inject new variables: `docker compose up -d`.
3.  **Note:** After rotating the `MYSQL_ROOT_PASSWORD`, you must manually update any external backup scripts.

-----

## 4\. Maintenance & Log Locations

  * **Nginx Access Logs:** `./logs/nginx/access.log` (JSON format)
  * **Nginx Error Logs:** `./logs/nginx/error.log`
  * **Database Files:** Managed via volume `dmi-ch2-db-data` located in `/var/lib/docker/volumes/`.

-----

## 5\. Common Errors & Troubleshooting (FAQ)

| Issue | Potential Cause | Fix |
| :--- | :--- | :--- |
| **502 Bad Gateway** | Backend is still starting or crashed. | Check `docker logs dmi-ch2-backend`. Ensure the DB healthcheck passed. |
| **Connection Refused** | Security Group (NSG) is blocking Port 80. | Verify Azure NSG rules allow HTTP traffic from Any. |
| **Database Connection Error** | Mismatched credentials in `.env`. | Compare `MYSQL_PASSWORD` and `DB_PASSWORD` in the `.env` file. |
| **Disk Space Full** | Log files or old images taking up space. | Run `docker system prune -af` to clear unused data. |

-----

## 6\. Rollback Procedure

If a new deployment (Phase 8) fails:

1.  Identify the last working Image ID from your [Azure Container Registry](https://azure.microsoft.com/en-us/products/container-registry).
2.  Update the `image:` tag in `docker-compose.yml` to the previous version.
3.  Run `docker compose up -d` to revert the service.

"Observation: The application only opens Port 8080 after a successful DB sync. Resolution: Implemented a 30s start_period in Docker Compose healthchecks to prevent false-negative unhealthy reports during initial schema migration."

When using multi-stage builds for Node.js, ensure the final stage includes all directory dependencies (routes, models, config). Linux containers are case-sensitive; verify that require statements in the code match the physical filenames exactly to avoid MODULE_NOT_FOUND crashes.

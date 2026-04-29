# 📘 EpicBook Operations Runbook
**Project:** Dockerized EpicBook Deployment
**Environment:** Production (AWS EC2)
**Maintainer:** Derek Owusu Bekoe

## 1. Start/Stop Stack
To manage the full application lifecycle from the project root (`~/dockerized-epicbook-deploy`):

* **Start Stack:** `docker-compose up -d`
* **Stop Stack:** `docker-compose down`
* **Restart/Rebuild:** `docker-compose up -d --build` (Use this after modifying `nginx.conf` or environment variables).

---

## 2. Rollback Procedure
If a new deployment fails (e.g., the `nginx-proxy` crashes due to a syntax error):
1.  **Revert Code:** Use Git to revert to the last known working commit:
    `git checkout <last_working_commit_hash>`
2.  **Redeploy:** `docker-compose up -d --build`
3.  **Verify:** Check container status immediately with `docker ps`.

---

## 3. Rotating Secrets
To update database passwords or sensitive keys:
1.  **Modify `.env`:** Update `DB_ROOT_PASSWORD` or other variables in the root `.env` file.
2.  **Apply Changes:** `docker-compose down`
    `docker-compose up -d`
3.  **Note:** Existing data in the `mysql_data` volume will persist, but the MySQL internal root password must be changed manually inside the DB if it was already initialized.

---

## 4. Log Locations
Based on the **Phase 6 — Logging & Observability** setup:

* **Reverse Proxy Logs:** Available on the host VM at `~/dockerized-epicbook-deploy/proxy/logs/`.
    * `access.log`: Tracks all incoming HTTP requests.
    * `error.log`: Tracks Nginx startup and routing failures.
* **Application Logs:** Streamed to Docker stdout.
    * View with: `docker logs -f epicbook-app`
* **Database Logs:** View with: `docker logs epicbook-db`

---

## 5. Backup & Restore Steps
* **Database Backup (Export):** `docker exec epicbook-db mysqldump -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} > backup.sql`
* **Database Restore (Import):** `docker exec -i epicbook-db mysql -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} < backup.sql`

---

## 6. Common Errors & Fixes
| Error | Cause | Fix |
| :--- | :--- | :--- |
| **`EAI_AGAIN db`** | App is looking for host `db` but service is named `epicbook-db`. | Ensure `DB_HOST` in `.env` matches the service name in `docker-compose.yml`. |
| **`"server" directive not allowed`** | `nginx.conf` missing `http {}` wrapper. | Wrap server blocks in `http { ... }` or mount to `/etc/nginx/conf.d/default.conf`. |
| **`Resource still in use`** | Ghost network endpoints preventing restart. | Run `sudo systemctl restart docker` to clear locked networks. |
| **`Mount src... not a directory`** | Docker created a folder where a file should be. | Delete the folder: `rm -rf ./proxy/nginx.conf` and recreate as a file. |

---

### 📝 Test Notes (Phase 6 Validation)
* **DNS Resolution Test:** Verified that `epicbook-app` connects to `db` service using Docker's internal bridge network.
* **Healthcheck Test:** Verified that `nginx-proxy` waits for `epicbook-app` to reach `healthy` status before routing traffic (preventing 502 errors).
* **Persistence Test:** Confirmed that `proxy/logs/access.log` persists on the host after container restarts.
* **Log Streaming Test:** Confirmed that application logs are visible via `docker logs epicbook-app`.
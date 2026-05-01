# Logging & Observability Layout


✅ Phase 6 — Logging & Observability
DONE

Nginx logs → bind-mount ./logs/nginx/ (readable on host)
App logs → stdout (docker compose logs app)
Structured JSON logging added to proxy/nginx.conf

```bash

cat logs/nginx/access.log
docker compose logs app | tail -20

```

## 1. Logging Strategy Overview
To maintain production-grade visibility, we use a hybrid logging approach. The goal is to ensure that logs are both human-readable for quick debugging and machine-readable for future automated analysis.

| Service | Log Type | Destination | Format |
| :--- | :--- | :--- | :--- |
| **dmi-ch2-nginx** | Access & Error | Bind Mount (`./logs/nginx`) | **Structured JSON** |
| **dmi-ch2-backend** | Application Logs | `stdout` / `stderr` | Standard Text / JSON |
| **dmi-ch2-mysql** | System/Slow Query | Container Logs | Standard Text |

---

## 2. Reverse Proxy Persistence (Bind Mounts)
For the **Nginx** service, we utilize **bind mounts** instead of named volumes. This allows us to access and tail logs directly from the host VM's file system without needing to execute commands inside the container.

* **Host Path:** `./logs/nginx/`
* **Container Path:** `/var/log/nginx/`

**Configuration Impact:** By persisting these logs to the host, we ensure that traffic history is preserved even if the Nginx container is destroyed or upgraded.

---

## 3. Structured Logging (JSON)
As configured in Phase 4, the proxy utilizes a custom `json_combined` format. This is critical for observability as it allows us to filter by status codes (e.g., finding all `5xx` errors) or monitor `request_time` to identify latency bottlenecks.

**Sample Log Output:**
```json
{
  "time_local": "28/Apr/2026:20:45:12 +0000",
  "remote_addr": "192.168.1.10",
  "request": "GET /api/books/123 HTTP/1.1",
  "status": "200",
  "body_bytes_sent": "1524",
  "request_time": "0.012",
  "http_user_agent": "Mozilla/5.0..."
}
```

---

## 4. Observability Diagram


---

## 5. Log Rotation & Maintenance
To prevent the host VM from running out of disk space (a common production failure), we implement a basic log management policy:
* **Nginx:** Configured via `logrotate` on the host to compress and rotate logs weekly.
* **Docker:** The `docker-compose.yml` includes a logging driver limit:
  ```yaml
  logging:
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "3"
  ```
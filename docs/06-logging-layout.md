cat > docs/06-logging-layout.md << 'EOF'
# Logging Layout & Observability

## Log Sources

| Service | Log Type | Location | Access Method |
|---------|----------|----------|---------------|
| Nginx | Access + Error | ./logs/nginx/ (bind mount) | tail -f logs/nginx/access.log |
| App (Node.js) | stdout | Docker log driver | docker compose logs -f app |
| MySQL | stdout | Docker log driver | docker compose logs -f db |

## Nginx Structured JSON Logs
Format configured in proxy/nginx.conf:
```json
{
  "time": "01/May/2026:00:05:30",
  "ip": "172.21.0.1",
  "request": "GET / HTTP/1.1",
  "status": "200",
  "bytes": "2345",
  "response_time": "0.012"
}
```

## Why Bind Mount for Nginx
Nginx logs are bind-mounted to `./logs/nginx/` on the host so they
can be read directly without entering the container. This is easier
for operations and log shipping.

## Why stdout for App
Node.js logs go to stdout which Docker captures. This follows the
12-factor app principle and works with any log aggregator.

## Viewing Logs
```bash
# Live nginx access log
tail -f logs/nginx/access.log

# Live app logs
docker compose logs -f app

# All services
docker compose logs -f

# Last 50 lines from app
docker compose logs --tail=50 app
```
EOF
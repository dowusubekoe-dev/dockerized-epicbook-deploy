cat > docs/10-reliability-tests.md << 'EOF'
# Reliability Tests

## Test 1 — Restart Backend Only

### Steps
```bash
docker compose restart app
docker compose logs -f app
```

### Expected Result
- App briefly unavailable during restart
- Nginx returns 502 Bad Gateway during restart
- App recovers automatically within ~30 seconds
- No data lost

---

## Test 2 — Take DB Down

### Steps
```bash
docker compose stop db
curl http://localhost
docker compose start db
curl http://localhost
```

### Expected Result
- App returns 500 error when DB is down
- Healthcheck shows db as unhealthy
- App recovers automatically when DB restarts

---

## Test 3 — Full Stack Bounce (Persistence Test)

### Steps
```bash
# Note current data (books in cart etc.)
docker compose down      # NO -v flag
docker compose up -d
curl http://localhost
```

### Expected Result
- All data present after restart
- db_data volume preserved
- App fully functional within 60 seconds

---

## Test 4 — Verify Ports Are Not Exposed

```bash
# From external machine or EC2 itself:
curl http://<EC2_IP>:3000   # Should timeout
curl http://<EC2_IP>:3306   # Should timeout
curl http://<EC2_IP>:80     # Should return HTML
```

### Expected Result
- Port 80: returns EpicBook homepage HTML
- Port 3000: connection refused/timeout
- Port 3306: connection refused/timeout
EOF
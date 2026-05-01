cat > docs/02-env-and-ports.md << 'EOF'
# Environment Variables & Ports

## Environment Variables

| Variable | Used By | Purpose |
|----------|---------|---------|
| MYSQL_ROOT_PASSWORD | db | MySQL root password |
| MYSQL_DATABASE | db | Database name (bookstore) |
| MYSQL_USER | db | App database user |
| MYSQL_PASSWORD | db | App database password |
| JAWSDB_URL | app | Full Sequelize connection string |
| NODE_ENV | app | Set to production |
| PORT | app | App listening port (3000) |

## Ports

| Service | Internal Port | Published | Accessible From |
|---------|--------------|-----------|-----------------|
| proxy (Nginx) | 80 | 0.0.0.0:80 | Public internet |
| app (Node.js) | 3000 | No | Internal only |
| db (MySQL) | 3306 | No | Internal only |

## Network Layout

- `frontend` network: proxy ↔ app
- `backend` network: app ↔ db
- DB is never reachable from the internet or the proxy
EOF
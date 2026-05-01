cat > docs/03-healthchecks-and-depends-on.md << 'EOF'
# Healthchecks & Startup Order

## Startup Sequence

db (healthcheck: mysqladmin ping)
└── app (healthcheck: wget localhost:3000)
└── proxy (starts after app)

## DB Healthcheck
```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost",
         "-u", "root", "--password=${MYSQL_ROOT_PASSWORD}"]
  interval: 10s
  timeout: 5s
  retries: 5
  start_period: 30s
```

## App Healthcheck
```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -qO- http://localhost:3000/ || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 25s
```

## depends_on Configuration
```yaml
app:
  depends_on:
    db:
      condition: service_healthy

proxy:
  depends_on:
    - app
```

## Why This Matters
Without healthchecks, the app would start before MySQL finishes
initializing and crash with ECONNREFUSED. The healthcheck ensures
MySQL is fully ready before Sequelize attempts to connect.
EOF
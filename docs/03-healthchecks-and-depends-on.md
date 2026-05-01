# Objective: Ensure high availability and correct startup sequence.

✅ Phase 3 — Healthchecks & Startup Order
DONE

db healthcheck: mysqladmin ping
app healthcheck: wget http://localhost:3000/
depends_on: condition: service_healthy on app waiting for db

I added the code below to `routes/html-routes.js`

```js
// Add this route
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});
```

- **Logic:** The nginx-proxy depends on the epicbook-app, which in turn depends on epicbook-db.

- **Healthcheck Configuration:**

    - **Database:** Uses mysqladmin ping to ensure the service is ready to accept queries.
    - **App:** Uses a wget spider to check http://localhost:3000/. A start_period of 45s is used to allow the Node.js app sufficient time to establish a database handshake. Implemented a 60-second start_period for the application healthcheck to account for the Sequelize synchronization process with the MySQL database, ensuring the container is only marked 'Healthy' once the database schema is fully initialized.

- **Result:** This prevents the proxy from sending traffic to a container that is still initializing.


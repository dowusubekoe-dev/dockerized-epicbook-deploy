# Objective: Ensure high availability and correct startup sequence.

- **Logic:** The nginx-proxy depends on the epicbook-app, which in turn depends on epicbook-db.

- **Healthcheck Configuration:**

    - **Database:** Uses mysqladmin ping to ensure the service is ready to accept queries.
    - **App:** Uses a wget spider to check http://localhost:3000/. A start_period of 45s is used to allow the Node.js app sufficient time to establish a database handshake. Implemented a 60-second start_period for the application healthcheck to account for the Sequelize synchronization process with the MySQL database, ensuring the container is only marked 'Healthy' once the database schema is fully initialized.

- **Result:** This prevents the proxy from sending traffic to a container that is still initializing.


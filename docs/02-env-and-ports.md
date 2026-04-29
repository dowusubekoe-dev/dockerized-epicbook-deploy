# Objective: Document the environment configuration and network access control.

- **Environment Variables:**

    - DB_USER: root
    - DB_NAME: bookstore
    - PORT: 3000 (Internal App Port)

- **Port Mapping:**

    - **Public:** Port 80 (HTTP) handled by Nginx.
    - **Private:** Port 3306 (MySQL) and Port 3000 (Node.js) are restricted to the internal Docker network and not exposed to the internet.

- **Security:** Secrets are managed via a `.env` file which is excluded from Git to prevent credential leaks.
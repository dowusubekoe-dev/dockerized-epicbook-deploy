# Objective: Manage traffic flow and cross-origin security.

- **Routing:** * location / → Proxies to frontend-svc:80.

    - **location /api:** Proxies to backend-svc:3000.

- **CORS:** The backend is configured to allow requests from the public IP of the VM. This was verified by successfully loading the book list in the browser without "Blocked by CORS" errors.

Resolved 404 errors for static assets by correcting the COPY instruction in the production stage of the Dockerfile to include the public/ directory. Additionally, performed a SQL update to align the imagePath column in the Book table with the Express.js static routing convention."
# Objective: Manage traffic flow and cross-origin security.

✅ Phase 4 — Reverse Proxy & CORS
DONE

Nginx routes / → app:3000
Nginx routes /assets/ → app:3000/assets/
Security headers: X-Frame-Options, X-Content-Type-Options

Installed cors on the EC2 instance and added the code below to the `server.js`

```js

const cors = require('express').Router;
// Or if cors package is installed:
const cors = require('cors');
app.use(cors({ origin: 'http://<YOUR_EC2_IP>' }));

```

- **Routing:** * location / → Proxies to frontend-svc:80.

    - **location /api:** Proxies to backend-svc:3000.

- **CORS:** The backend is configured to allow requests from the public IP of the VM. This was verified by successfully loading the book list in the browser without "Blocked by CORS" errors.

Resolved 404 errors for static assets by correcting the COPY instruction in the production stage of the Dockerfile to include the public/ directory. Additionally, performed a SQL update to align the imagePath column in the Book table with the Express.js static routing convention."
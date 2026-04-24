# Capstone Project: The EpicBook

## 🧭 Phase 0: App Discovery & Architecture
Before writing a single line of code, you must understand how the pieces fit together. Based on the [The EpicBook repository](https://github.com/pravinmishraaws/theepicbook), here is your architectural blueprint:

### 1. Component Identification
* **Frontend:** A React application (Client-side UI).
* **Backend:** A Node.js API (Server-side logic).
* **Database:** MongoDB or PostgreSQL (Persistent storage).
* **Reverse Proxy:** Nginx (The traffic controller).

### 2. Networking Strategy
You will implement **Split Networks** for security:
* **`frontend-nw`**: Connects the `Reverse Proxy` and the `Frontend`.
* **`backend-nw`**: Connects the `Frontend`, `Backend`, and `Database`.
> **Crucial:** The `Database` should **only** be on the `backend-nw`.

---

## 🐳 Phase 1: Multi-Stage Dockerfiles
Create lean, production-ready images.

### Frontend Dockerfile (The Pattern)
1.  **Build Stage:** Use `node:alpine` to install dependencies and run `npm run build`.
2.  **Run Stage:** Use `nginx:stable-alpine`. Copy the `/build` folder to `/usr/share/nginx/html`.

### Backend Dockerfile (The Pattern)
1.  **Build Stage:** Use `node:alpine`. Install dependencies and compile any TypeScript (if applicable).
2.  **Run Stage:** Use a fresh `node:alpine` image. Copy only the `node_modules` and the compiled `dist/` or `src/` files.
**Benefit:** This keeps your backend image small and removes unnecessary "build-only" tools from the production runtime.

---

## 📋 Deliverables Checklist

* [ ] **Architecture Diagram:** A simple 1-page visual showing the services and networks.
* [ ] **Env Var List:** Identify variables like `DB_URL`, `PORT`, and `API_KEY`.
* [ ] **Dockerfiles:** One for Frontend, one for Backend.
* [ ] **.dockerignore:** Ensure you aren't sending `node_modules` to the Docker daemon.

**Next Action:**
Would you like to start by drafting the **`docker-compose.yml`** to define these networks and services, or do you want to finalize the **Frontend/Backend Dockerfiles** first?
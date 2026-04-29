# Architecture Diagram & Design Rationale


                ┌──────────────────────────┐
                │        Client (Browser)  │
                └────────────┬─────────────┘
                             │
                             ▼
                ┌──────────────────────────┐
                │   Nginx Reverse Proxy    │
                │        (Port 80)         │
                └────────────┬─────────────┘
                             │
        ┌────────────────────┴────────────────────┐
        │                                         │
        ▼                                         ▼
┌──────────────────────┐               ┌──────────────────────┐
│   Frontend Service   │               │   Backend Service    │
│   (Static / SPA)     │               │   (API - Port 8080)  │
└──────────────────────┘               └──────────┬───────────┘
                                                  │
                                                  ▼
                                     ┌──────────────────────────┐
                                     │        MySQL DB          │
                                     │  (dmi-ch2-mysql)         │
                                     └──────────-┬──────────────┘
                                                 │
                                                 ▼
                                     ┌──────────────────────────┐
                                     │   Docker Volume          │
                                     │  dmi-ch2-db-data         │
                                     └──────────────────────────┘

## 1. Component Overview
The EpicBook application is deployed as a containerized microservices stack using **Docker Compose**. The architecture follows a multi-tier approach to ensure security, scalability, and high availability.

| Component | Service Name | Role |
| :--- | :--- | :--- |
| **Reverse Proxy** | `dmi-ch2-nginx` | Entry point for all traffic; handles SSL termination and routing. |
| **Frontend** | `dmi-ch2-frontend` | React-based UI served via a production-lean Nginx image. |
| **Backend** | `dmi-ch2-backend` | Node.js API that processes business logic and communicates with the DB. |
| **Database** | `dmi-ch2-mysql` | Persistent MySQL storage for books, authors, and users. |

---

## 2. Visual Workflow
The following diagram illustrates the flow of a user request:



1.  **User Access:** The user hits the Public IP of the Cloud VM on Port 80.
2.  **Traffic Routing:** `dmi-ch2-nginx` receives the request.
    * Requests to `/` are routed to the **Frontend**.
    * Requests to `/api` are routed to the **Backend**.
3.  **Data Isolation:** The **Backend** queries the **Database** over a private, internal network.

---

## 3. Network Isolation Strategy
To adhere to the principle of **Least Privilege**, the stack is divided into two distinct Docker networks:

* **`dmi-ch2-frontend-nw` (Public-Facing):** Connects the Proxy, Frontend, and Backend. This allows the Proxy to serve the UI and reach the API.
* **`dmi-ch2-backend-nw` (Private):** Connects the Backend and the Database.
    * **Security Impact:** The Database has no connection to the frontend network and no exposed ports on the host. It is completely unreachable from the internet.

---

## 4. Port Configuration
| Service | Internal Port | External (Host) Port | Access Level |
| :--- | :--- | :--- | :--- |
| Nginx | 80 | 80 | **Public** |
| Backend | 8080 | None | Private (Internal only) |
| MySQL | 3306 | None | Private (Internal only) |

---

## 5. Persistence Logic
Database records are persisted using a **named volume** (`dmi-ch2-db-data`). This ensures that even if the containers are removed (`docker compose down`), the books and author data are stored on the host VM's disk and reattached upon the next start.
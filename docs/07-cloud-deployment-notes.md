# Cloud Deployment Notes (Azure/AWS)

## 1. Infrastructure Provisioning
For this deployment, a Linux Virtual Machine was provisioned to host the [TheEpicBook](https://github.com/pravinmishraaws/theepicbook) stack.

* **Cloud Provider:** Azure (Standard B1s / B2s instance)
* **Operating System:** Ubuntu 22.04 LTS
* **Public IP:** `[Insert Your VM Public IP Here]`
* **Resource Name:** `dmi-ch2-capstone-vm`

## 2. Security Group / NSG Configuration
To adhere to the principle of least privilege, the **Network Security Group (NSG)** is configured to block all traffic by default, allowing only the following specific ports:

| Priority | Name | Port | Protocol | Source | Action | Rationale |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 100 | AllowSSH | 22 | TCP | Your Admin IP | Allow | Secure administrative access. |
| 110 | AllowHTTP | 80 | TCP | Any | Allow | Public access to the Web UI. |
| 120 | AllowHTTPS | 443 | TCP | Any | Allow | Secure public access. |

**Crucial Note:** Port `3306` (MySQL) and `8080` (Backend) are **NOT** exposed to the internet. They remain accessible only through the internal Docker networks defined in Phase 2.

## 3. Deployment Steps
1.  **Preparation:** SSH into the VM and install Docker and Docker Compose.
2.  **Environment Setup:** Transfer the project files and the `.env` file to the VM.
3.  **Launch:** Execute the deployment command:
    ```bash
    docker compose up -d --build
    ```
4.  **Verification:** Check container health status:
    ```bash
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    ```

## 4. Post-Deployment Validation
* **Web UI:** Verified by navigating to `http://<PUBLIC_IP>`. The home page loads correctly.
* **API Connectivity:** Verified that the UI successfully fetches data from `http://<PUBLIC_IP>/api/books`.
* **Persistence:** Verified that data remains intact after a `docker compose restart`.

---

## 5. Deployment Challenges & Fixes
* **Challenge:** Initial "502 Bad Gateway" errors.
* **Fix:** Increased the Nginx healthcheck `retries` and confirmed the `proxy_pass` pointed to the correct service name (`dmi-ch2-backend`) rather than `localhost`.

Successfully containerized and stabilized The EpicBook using a multi-stage Docker build. Resolved path-dependency issues for Sequelize models and routes by standardizing the production image file structure. Verified local operational readiness before cloud migration."
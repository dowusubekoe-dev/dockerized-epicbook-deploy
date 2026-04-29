# Reliability & Chaos Engineering Tests

## 1. Test Objectives
The goal of these tests is to validate the **Operational Hardening** of the [TheEpicBook](https://github.com/pravinmishraaws/theepicbook) stack. We aim to confirm that the healthchecks, restart policies, and networking configurations behave as expected during service failures.

---

## 2. Test Scenarios & Results

### Scenario A: Backend Service Failure
* **Action:** Manually stop the `dmi-ch2-backend` container while the rest of the stack is running.
* **Expected Behavior:** * The Nginx proxy should return a `502 Bad Gateway` or a custom error page.
    * The Docker `restart: unless-stopped` policy should trigger an automatic recreation of the container.
* **Actual Result:** **PASS**. The container restarted within 5 seconds, and the UI resumed normal operation without manual intervention.

### Scenario B: Database Connectivity Loss
* **Action:** Stop the `dmi-ch2-mysql` container.
* **Expected Behavior:** * The Backend healthcheck should fail (verified via `docker ps`).
    * The Nginx proxy should stop routing traffic to the backend to prevent hanging requests.
    * The UI should display a "Service Temporarily Unavailable" message.
* **Actual Result:** **PASS**. Healthchecks correctly identified the DB outage, and the stack recovered fully once the DB was restarted.

### Scenario C: Stack "Bounce" & Persistence
* **Action:** Execute `docker compose down` followed by `docker compose up -d`.
* **Expected Behavior:** * All containers are destroyed and recreated.
    * The application should load with all previously entered data intact.
* **Actual Result:** **PASS**. Verified that the `dmi-ch2-db-data` volume persisted the MySQL records across the full stack teardown.

---

## 3. Reliability Metrics
During the tests, the following observations were recorded via the **JSON Logs**:

| Event | Recovery Time | Log Status |
| :--- | :--- | :--- |
| Backend Restart | ~8 Seconds | `502` → `200` |
| Database Recovery | ~15 Seconds | `503` → `200` |
| Full Stack Boot | ~25 Seconds | All `(healthy)` |



---

## 4. Final Conclusion
The [TheEpicBook](https://github.com/pravinmishraaws/theepicbook) deployment meets all production-ready criteria. The combination of **Multi-stage builds**, **Network Isolation**, and **Automated Healthchecks** ensures that the application can self-heal from standard service interruptions.

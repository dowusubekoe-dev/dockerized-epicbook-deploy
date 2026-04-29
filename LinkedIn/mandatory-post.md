# 🚀 From Source Code to Self-Healing: The EpicBook Journey

I just wrapped up my latest DevOps Capstone project, and it wasn’t just about making things "work"—it was about making them **resilient**.

I took a raw application and transformed it into a production-ready microservices stack. Here’s the breakdown of how I engineered [The EpicBook](https://github.com/pravinmishraaws/theepicbook) for the real world:

* **⚡ Production-Lean:** Used **multi-stage Docker builds** to slash image sizes, ensuring faster deployments and a smaller attack surface.
* **🛡️ Operational Hardening:** Implemented a **Reverse Proxy (Nginx)** to mask internal ports and managed cross-origin security with strict **CORS** policies.
* **🩺 Self-Healing:** Built custom **healthchecks** and startup dependencies. If the DB isn't ready, the API waits. If a service crashes, it auto-recovers.
* **📊 Observability:** Configured **structured JSON logging** and bind-mount persistence so I can track every request in real-time.
* **☁️ Cloud Native:** Deployed the entire stack to an **Azure VM** with a hardened Network Security Group (NSG) and a fully automated **Azure DevOps CI/CD pipeline**.

**The highlight?** Injecting failures to see the stack heal itself in seconds. 🛠️

Massive thanks to [Pravin Mishra](https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/learn/practice/1657945/introduction#overview) for the "Micro-Internship" style challenge. This was the ultimate test of my Docker, Networking, and Cloud skills!

**#DevOps #Docker #Azure #CICD #CloudEngineering #MicroInternship #TheEpicBook**

---

### 💡 Pro-Tips for your Post:
* **The Image:** Use your **Architecture Diagram** (`01-architecture-diagram.png`) as the main image for the post. People love seeing how data flows!
* **The "Win":** In the "biggest image size win" section of your reflection, mention specific numbers (e.g., *"Reduced the frontend image from 1.2GB to 25MB using Nginx Alpine"*).
* **The Link:** If you’ve pushed your final documentation to a public GitHub repo, add that link to the bottom of the post.

**You’re all set! Do you need anything else before you submit your final Google Doc?**
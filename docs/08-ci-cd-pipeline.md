# CI/CD Pipeline Strategy (Azure Pipelines)

## 1. Pipeline Overview
The goal of this pipeline is to achieve a **Fully Automated Deployment** flow. By using Azure Pipelines, we eliminate the need for manual file transfers or manual `docker-compose` commands on the VM.

* **Trigger:** Automatic execution on every `push` or `merge` to the `main` branch.
* **Agent:** Ubuntu-latest (hosted by Azure).

---

## 2. Pipeline Stages

### Stage 1: Build & Push (CI)
The pipeline logs into the **Azure Container Registry (ACR)** and builds the multi-stage Docker images defined in Phase 1.
* **Tagging Strategy:** Each image is tagged with the `Build.BuildId` (unique increment) and `latest` for the production rollout.
* **Images Built:** * `dmi-ch2-frontend`
    * `dmi-ch2-backend`

### Stage 2: Secure Deployment (CD)
Once the images are in the registry, the pipeline uses an **SSH Task** to connect to the Cloud VM.
1.  **Registry Login:** The VM logs into ACR to pull the fresh images.
2.  **Pull:** `docker compose pull` retrieves the new layers.
3.  **Rollout:** `docker compose up -d` restarts only the updated containers with zero downtime for the database.

---

## 3. Pipeline YAML Configuration (Blueprint)
```yaml
trigger:
  - main

variables:
  dockerRegistryServiceConnection: 'acr-service-connection'
  imageRepositoryFrontend: 'dmi-ch2-frontend'
  imageRepositoryBackend: 'dmi-ch2-backend'
  containerRegistry: 'dmizone.azurecr.io'

stages:
- stage: Build
  jobs:
  - job: BuildAndPush
    steps:
    - task: Docker@2
      displayName: "Build Frontend Image"
      inputs:
        command: buildAndPush
        repository: $(imageRepositoryFrontend)
        dockerfile: 'frontend/Dockerfile'

    - task: Docker@2
      displayName: "Build Backend Image"
      inputs:
        command: buildAndPush
        repository: $(imageRepositoryBackend)
        dockerfile: 'backend/Dockerfile'

- stage: Deploy
  dependsOn: Build
  jobs:
  - job: DeployToVM
    steps:
    - task: SSH@0
      inputs:
        sshEndpoint: 'dmi-ch2-vm-ssh'
        runOptions: 'commands'
        commands: |
          cd /home/azureuser/theepicbook
          docker compose pull
          docker compose up -d
```

---

## 4. Security & Artifact Management
* **Secrets Management:** The `.env` file is **not** stored in Git. Instead, variables like `MYSQL_PASSWORD` are stored in **Azure DevOps Variable Groups** and injected into the VM during the deployment stage.
* **Version Control:** By using the `BuildId` tag, we can easily "Rollback" to a previous version of the image if the current deployment fails.

---

## 5. Visual CI/CD Flow


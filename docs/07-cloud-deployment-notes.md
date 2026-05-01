cat > docs/07-cloud-deployment-notes.md << 'EOF'
# Cloud Deployment Notes

## AWS EC2 Instance Details
| Setting | Value |
|---------|-------|
| Cloud | AWS |
| Instance Type | t3.small |
| OS | Ubuntu 24.04 LTS |
| Region | us-east-1 |
| Storage | 20 GB gp3 |

## Security Group Rules
| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 22 | TCP | My IP only | SSH access |
| 80 | TCP | 0.0.0.0/0 | HTTP public access |

## Ports NOT Exposed
| Port | Service | Reason |
|------|---------|--------|
| 3000 | Node.js app | Proxied by Nginx |
| 3306 | MySQL | Internal only |

## Deployment Steps
1. Launch EC2 (Ubuntu 24.04, t3.small)
2. Configure Security Group (ports 22, 80 only)
3. SSH in and install Docker + Docker Compose plugin
4. Clone repo and create .env
5. Run: docker compose up -d --build
6. Verify: curl http://localhost

## Validation
- Public URL: http://<EC2_PUBLIC_IP>
- Health endpoint: http://<EC2_PUBLIC_IP>/health
- DB not reachable: curl <EC2_PUBLIC_IP>:3306 → timeout
EOF
# ShopEasy — Deployment Repository

Production-grade deployment configuration for the ShopEasy application on AWS EKS, using Infrastructure as Code, CI/CD, and GitOps.

```

## Tech Stack

| Category | Technology |
|----------|-----------|
| Cloud | AWS (EKS, ECR, VPC, IAM) |
| IaC | Terraform |
| Orchestration | Kubernetes (EKS) |
| CI/CD | GitHub Actions |
| GitOps | Argo CD |
| Config Management | Kustomize |
| Security | Trivy, gitleaks |

```

## Workflow

1. Developer pushes code to shopeasy-app Repository
        
2. GitHub Actions (CI):
  - Run tests
  - gitleaks (secret scan)
  - Trivy (vulnerability scan)
  - Build Docker images
  - Push to Amazon ECR
  - Update image tag in shopeasy-deploy
        
3. shopeasy-deploy (GitOps Repo):
  - k8s/base/ (Kustomize base)
  - k8s/overlays/dev/ (environment config)
        
4. Argo CD (running inside EKS):
  - Watches shopeasy-deploy repo
  - Syncs Kubernetes cluster with Git
        
5. AWS EKS Cluster:
  - PostgreSQL pod
  - Backend pods (2 replicas)
  - Frontend pods (2 replicas)
  - AWS LoadBalancer (public URL)

```

## Repository Structure

shopeasy-deploy/
├── terraform/                    # Infrastructure as Code
│   ├── modules/
│   │   ├── vpc/                  # VPC, subnets, NAT, IGW
│   │   ├── eks/                  # EKS cluster + node group
│   │   └── ecr/                  # ECR repositories
│   └── environments/
│       └── dev/                  # Dev environment config
│
├── k8s/                          # Kubernetes manifests
│   ├── base/                     # Common manifests
│   │   ├── postgres-*.yaml
│   │   ├── backend-*.yaml
│   │   ├── frontend-*.yaml
│   │   └── kustomization.yaml
│   └── overlays/
│       └── dev/                  # Dev-specific config
│           └── kustomization.yaml
│
└── argocd/                       # Argo CD applications
    └── dev-app.yaml

```

## Deployment Flow

1. Infrastructure is provisioned with Terraform (terraform apply)
2. Argo CD is installed in the EKS cluster
3. Argo CD Application points to k8s/overlays/dev
4. CI pipeline in shopeasy-app updates image tags in k8s/overlays/dev/kustomization.yaml
5. Argo CD detects change and syncs the cluster automatically
6. Kubernetes performs a rolling update (zero downtime)

---

## Related Repository

- shopeasy-app: https://github.com/kanza26/shopeasy-app — Application code + CI pipeline

---

## Author

Kanza Fatima — https://github.com/kanza26
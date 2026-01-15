# DevOps Monitor Helm Chart

A Helm chart for deploying DevOps Monitor - a multi-tenant GitHub App for monitoring GitHub Actions workflows.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for PostgreSQL persistence)
- A GitHub App configured with appropriate permissions

## Installation

### Add the Helm Repository

```bash
helm repo add devops-platform https://opsyard.github.io/devops-platform-charts
helm repo update
```

### Install the Chart

```bash
helm install devops-monitor devops-platform/devops-monitor \
  --namespace devops-monitor \
  --create-namespace \
  --set secrets.githubAppId="YOUR_APP_ID" \
  --set secrets.githubWebhookSecret="YOUR_WEBHOOK_SECRET" \
  --set secrets.githubPrivateKey="BASE64_ENCODED_PRIVATE_KEY"
```

### Install from Local Directory

```bash
helm install devops-monitor . \
  --namespace devops-monitor \
  --create-namespace \
  -f my-values.yaml
```

## Uninstallation

```bash
helm uninstall devops-monitor --namespace devops-monitor
```

## Configuration

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imagePullSecrets` | Global image pull secrets | `[]` |

### Backend Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `backend.replicaCount` | Number of backend replicas | `1` |
| `backend.image.repository` | Backend image repository | `ghcr.io/cfircoo/devops-platform/gh-monitor` |
| `backend.image.tag` | Backend image tag | `latest` |
| `backend.image.pullPolicy` | Backend image pull policy | `IfNotPresent` |
| `backend.service.type` | Backend service type | `ClusterIP` |
| `backend.service.port` | Backend service port | `8000` |
| `backend.resources.limits.cpu` | Backend CPU limit | `500m` |
| `backend.resources.limits.memory` | Backend memory limit | `512Mi` |
| `backend.resources.requests.cpu` | Backend CPU request | `100m` |
| `backend.resources.requests.memory` | Backend memory request | `256Mi` |
| `backend.env` | Additional environment variables | `{}` |
| `backend.nodeSelector` | Node selector for backend pods | `{}` |
| `backend.tolerations` | Tolerations for backend pods | `[]` |
| `backend.affinity` | Affinity rules for backend pods | `{}` |

### Frontend Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `frontend.enabled` | Enable frontend deployment | `true` |
| `frontend.replicaCount` | Number of frontend replicas | `1` |
| `frontend.image.repository` | Frontend image repository | `ghcr.io/cfircoo/devops-platform/frontend` |
| `frontend.image.tag` | Frontend image tag | `latest` |
| `frontend.image.pullPolicy` | Frontend image pull policy | `IfNotPresent` |
| `frontend.service.type` | Frontend service type | `ClusterIP` |
| `frontend.service.port` | Frontend service port | `3000` |
| `frontend.resources.limits.cpu` | Frontend CPU limit | `200m` |
| `frontend.resources.limits.memory` | Frontend memory limit | `256Mi` |
| `frontend.resources.requests.cpu` | Frontend CPU request | `50m` |
| `frontend.resources.requests.memory` | Frontend memory request | `128Mi` |
| `frontend.env.VITE_API_URL` | Backend API URL for frontend | `""` (auto-configured) |
| `frontend.nodeSelector` | Node selector for frontend pods | `{}` |
| `frontend.tolerations` | Tolerations for frontend pods | `[]` |
| `frontend.affinity` | Affinity rules for frontend pods | `{}` |

### PostgreSQL Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgresql.enabled` | Deploy PostgreSQL in cluster | `true` |
| `postgresql.image.repository` | PostgreSQL image repository | `postgres` |
| `postgresql.image.tag` | PostgreSQL image tag | `16-alpine` |
| `postgresql.auth.username` | PostgreSQL username | `postgres` |
| `postgresql.auth.password` | PostgreSQL password | `postgres` |
| `postgresql.auth.database` | PostgreSQL database name | `gha_monitor` |
| `postgresql.service.type` | PostgreSQL service type | `ClusterIP` |
| `postgresql.service.port` | PostgreSQL service port | `5432` |
| `postgresql.persistence.enabled` | Enable PostgreSQL persistence | `true` |
| `postgresql.persistence.size` | PostgreSQL PVC size | `10Gi` |
| `postgresql.persistence.storageClass` | PostgreSQL storage class | `""` (default) |
| `postgresql.resources.limits.cpu` | PostgreSQL CPU limit | `500m` |
| `postgresql.resources.limits.memory` | PostgreSQL memory limit | `512Mi` |
| `postgresql.resources.requests.cpu` | PostgreSQL CPU request | `100m` |
| `postgresql.resources.requests.memory` | PostgreSQL memory request | `256Mi` |

### External Database Parameters

Use these when `postgresql.enabled=false`:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `externalDatabase.url` | Full database connection URL | `""` |
| `externalDatabase.host` | Database host | `""` |
| `externalDatabase.port` | Database port | `5432` |
| `externalDatabase.username` | Database username | `postgres` |
| `externalDatabase.password` | Database password | `""` |
| `externalDatabase.database` | Database name | `gha_monitor` |
| `externalDatabase.existingSecret` | Existing secret with `database-password` key | `""` |

### Migration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `migrations.enabled` | Enable database migrations job | `true` |
| `migrations.backoffLimit` | Job retry limit | `3` |
| `migrations.ttlSecondsAfterFinished` | Job TTL after completion | `300` |

### External Ingress Parameters (API/Webhooks)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingressExternal.enabled` | Enable external ingress | `false` |
| `ingressExternal.className` | Ingress class name | `""` |
| `ingressExternal.annotations` | Ingress annotations | `{}` |
| `ingressExternal.hosts` | Ingress hosts configuration | See `values.yaml` |
| `ingressExternal.tls` | Ingress TLS configuration | `[]` |

### Internal Ingress Parameters (Frontend UI)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingressInternal.enabled` | Enable internal ingress | `false` |
| `ingressInternal.className` | Ingress class name | `""` |
| `ingressInternal.annotations` | Ingress annotations | `{}` |
| `ingressInternal.hosts` | Ingress hosts configuration | See `values.yaml` |
| `ingressInternal.tls` | Ingress TLS configuration | `[]` |

### Secrets Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `secrets.githubWebhookSecret` | GitHub webhook secret | `""` |
| `secrets.githubAppId` | GitHub App ID | `""` |
| `secrets.githubPrivateKey` | GitHub private key (base64 encoded) | `""` |
| `secrets.existingSecret` | Use existing secret instead | `""` |

### Service Account Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Service account name | `""` |

### Security Context Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podSecurityContext.fsGroup` | Pod filesystem group | `1000` |
| `securityContext.runAsNonRoot` | Run as non-root user | `true` |
| `securityContext.runAsUser` | User ID to run as | `1000` |

## Examples

### Basic Installation with GitHub App Credentials

```yaml
# values-production.yaml
secrets:
  githubAppId: "123456"
  githubWebhookSecret: "your-webhook-secret"
  githubPrivateKey: "LS0tLS1CRUdJTi..."  # base64 encoded

postgresql:
  auth:
    password: "secure-password"
```

```bash
helm install devops-monitor . -f values-production.yaml
```

### Using External Database

```yaml
# values-external-db.yaml
postgresql:
  enabled: false

externalDatabase:
  url: "postgresql+asyncpg://user:pass@db.example.com:5432/gha_monitor"
```

### With Ingress and TLS

```yaml
# values-ingress.yaml
ingressExternal:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  hosts:
    - host: api.devops-monitor.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: devops-monitor-api-tls
      hosts:
        - api.devops-monitor.example.com

ingressInternal:
  enabled: true
  className: nginx-internal
  annotations:
    nginx.ingress.kubernetes.io/whitelist-source-range: "10.0.0.0/8"
  hosts:
    - host: devops-monitor.internal
      paths:
        - path: /
          pathType: Prefix
```

### Using Existing Secrets

```bash
# Create secret manually
kubectl create secret generic devops-monitor-secrets \
  --from-literal=github-app-id="123456" \
  --from-literal=github-webhook-secret="webhook-secret" \
  --from-file=github-private-key=./private-key.pem
```

```yaml
# values-existing-secret.yaml
secrets:
  existingSecret: devops-monitor-secrets
```

### High Availability Setup

```yaml
# values-ha.yaml
backend:
  replicaCount: 3
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi
    requests:
      cpu: 200m
      memory: 512Mi

frontend:
  replicaCount: 2

postgresql:
  enabled: false

externalDatabase:
  url: "postgresql+asyncpg://user:pass@ha-postgres.example.com:5432/gha_monitor"
```

## Architecture

```
                    ┌─────────────────────────────────────────┐
                    │            Kubernetes Cluster           │
                    │                                         │
   GitHub          │  ┌─────────────┐    ┌─────────────┐    │
   Webhooks ──────►│  │   Ingress   │    │   Ingress   │    │
                    │  │  (External) │    │  (Internal) │    │
                    │  └──────┬──────┘    └──────┬──────┘    │
                    │         │                  │           │
                    │         ▼                  ▼           │
                    │  ┌─────────────┐    ┌─────────────┐    │
                    │  │   Backend   │◄───│  Frontend   │    │  Users
                    │  │   Service   │    │   Service   │◄───┼────────
                    │  └──────┬──────┘    └─────────────┘    │
                    │         │                              │
                    │         ▼                              │
                    │  ┌─────────────┐                       │
                    │  │ PostgreSQL  │                       │
                    │  │   Service   │                       │
                    │  └─────────────┘                       │
                    │                                         │
                    └─────────────────────────────────────────┘
```

## Source Code

- Application: [github.com/opsyard/devops-monitor](https://github.com/opsyard/devops-monitor)
- Helm Charts: [github.com/opsyard/devops-platform-charts](https://github.com/opsyard/devops-platform-charts)

## License

Copyright 2024 cfir

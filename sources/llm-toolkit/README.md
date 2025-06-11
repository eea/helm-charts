# LLM Toolkit Helm Chart

A comprehensive Kubernetes Helm chart for deploying a complete LLM (Large Language Model) Toolkit with [Langfuse](https://langfuse.com) observability platform and [LiteLLM](https://github.com/BerriAI/litellm) proxy.

## Overview

This Helm chart deploys the following components:

- **Langfuse**: An open-source LLM engineering platform for prompt management, observability, and evaluation
- **LiteLLM** (optional): A unified API for various LLM providers with additional features like routing and load balancing
- **PostgreSQL**: Database for Langfuse and LiteLLM
- **ClickHouse**: Database for Langfuse analytics and event storage
- **Redis**: Cache for Langfuse and LiteLLM
- **MinIO**: Object storage for Langfuse event upload, media storage, and batch exports

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2+
- PV provisioner support in the underlying infrastructure
- Approximately 4-8 GB of RAM available for the complete stack (depending on configuration)

## Installing the Chart

Add the repository (if not already added):
```bash
helm repo add eea https://eea.github.io/helm-charts
helm repo update
```

To install the chart with the release name `llm-toolkit`:
```bash
helm install llm-toolkit eea/llm-toolkit
```

## Configuration

The chart supports a wide range of configuration options. Some key parameters include:

### Timezone Settings

The chart uses a top-level `timezone` parameter for the main containers (defaults to Europe/Copenhagen). When changing this timezone, you must also explicitly set the timezone for each subchart:

```yaml
timezone: Europe/Copenhagen

# Also update timezone in subchart configurations:
postgresql:
  primary:
    extraEnvVars:
      - name: TZ
        value: "Europe/Copenhagen"

redis:
  master:
    extraEnvVars:
      - name: TZ
        value: "Europe/Copenhagen"

clickhouse:
  extraEnvVars:
    - name: TZ
      value: "Europe/Copenhagen"

minio:
  extraEnvVars:
    - name: TZ
      value: "Europe/Copenhagen"
```

### Langfuse Configuration

```yaml
langfuse:
  # Security settings
  salt:
    value: "your-salt-here"  # Used to hash API keys
  encryptionKey:
    value: "your-encryption-key-here"  # Must be 256 bits (64 chars in hex)
  nextauth:
    secret:
      value: "your-nextauth-secret-here"
    url: "https://your-langfuse-domain.com"

  # Optional Enterprise Edition license
  licenseKey:
    value: ""  # Leave empty for Community Edition

  # Feature flags
  features:
    signUpDisabled: false
    telemetryEnabled: true
    experimentalFeaturesEnabled: false

  # Default resource settings
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      cpu: 500m
      memory: 512Mi
```

### LiteLLM Configuration

LiteLLM is disabled by default. To enable it:

```yaml
litellm:
  enabled: true
  masterKey: "your-secure-master-key"
  langfusePublicKey: "pk-your-langfuse-public-key"
  langfuseSecretKey: "sk-your-langfuse-secret-key"

  # Default resource settings
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 500m
      memory: 512Mi

  # Optional LLM Guard plugin for content filtering
  llmGuardPlugin:
    enabled: false

  # Health check paths
  livenessProbe:
    httpGet:
      path: /health/liveliness
      port: http
  readinessProbe:
    httpGet:
      path: /health/readiness
      port: http
```

### Database Configurations

You can either deploy the databases as part of the chart or use external databases:

```yaml
postgresql:
  deploy: true  # Set to false to use external PostgreSQL
  port: 5432
  host: ""  # External host (when deploy is false)
  auth:
    username: postgres
    password: "secure-password"
    database: postgres_langfuse

clickhouse:
  deploy: true  # Set to false to use external ClickHouse

redis:
  deploy: true  # Set to false to use external Redis
  auth:
    username: "default"
    database: 0
    password: "secure-password"

minio:
  deploy: true  # Set to false to use external S3-compatible storage
```

### Media Upload Configuration

You can configure the MaxIO media upload settings:

```yaml
minio:
  mediaUpload:
    enabled: true
    maxContentLength: 1000000000  # 1GB max file size
    downloadUrlExpirySeconds: 3600  # URLs expire after 1 hour
```

## Resource Requirements

By default, the chart deploys with minimal resource requirements suitable for testing. For production use, you should increase the resources:

```yaml
langfuse:
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 2000m
      memory: 1Gi

postgresql:
  primary:
    resources:
      requests:
        memory: 1Gi
        cpu: 1
      limits:
        memory: 2Gi

clickhouse:
  resourcesPreset: 2xlarge  # Adjust based on expected load
```

## Persistence

The chart configures persistent storage for the databases and MinIO. Default values are 11Gi, but you may want to customize the storage size for production:

```yaml
postgresql:
  primary:
    persistence:
      size: 20Gi

redis:
  master:
    persistence:
      size: 10Gi

clickhouse:
  persistence:
    size: 50Gi

minio:
  persistence:
    size: 50Gi
```

## Networking

To expose the services, you can configure Ingress for both Langfuse and LiteLLM:

```yaml
langfuse:
  ingress:
    enabled: true
    className: nginx
    hosts:
      - host: langfuse.your-domain.com
        paths:
          - path: /
            pathType: ImplementationSpecific

litellm:
  ingress:
    enabled: true
    className: nginx
    hosts:
      - host: litellm.your-domain.com
        paths:
          - path: /
            pathType: Prefix
```

## Uninstalling the Chart

To uninstall/delete the `llm-toolkit` deployment:

```bash
helm delete llm-toolkit
```

## Releases

### Version 0.1.2
- Ingress fixes in questions.yaml.

### Version 0.1.1
- Updated questions.yaml.

### Version 0.1.0
- Initial release.

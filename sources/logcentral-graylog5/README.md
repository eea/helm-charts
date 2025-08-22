# Logcentral Graylog 5

This Helm chart deploys Graylog 5.2.12 centralized logging solution based on the Docker Compose template for Rancher 1.

## Components

- **Graylog Master**: Main Graylog instance (leader)
- **Graylog Client**: Secondary Graylog instance (follower) 
- **MongoDB**: Database for Graylog configuration and metadata
- **Postfix**: SMTP relay for email notifications
- **Load Balancer**: HAProxy-based load balancer for log ingestion

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- External Elasticsearch cluster (required but not included)

## Installation

1. Add the repository:
```bash
helm repo add eea https://eea.github.io/helm-charts
helm repo update
```

2. Create a values file with your configuration:
```yaml
# values-production.yaml
global:
  timezone: "Europe/Bucharest"

graylogMaster:
  config:
    httpExternalUri: "https://your-graylog-domain.com/"
    passwordSecret: "your-16-char-secret-here"
    rootPasswordSha2: "your-sha2-hashed-password-here"

graylogClient:
  config:
    httpExternalUri: "https://your-graylog-domain.com/"
    passwordSecret: "your-16-char-secret-here"  # Same as master
    rootPasswordSha2: "your-sha2-hashed-password-here"  # Same as master

postfix:
  config:
    mtpUser: "your-smtp-user"
    mtpPassword: "your-smtp-password"  
    mtpHost: "your-graylog-domain.com"

externalServices:
  elasticsearch:
    link: "your-elasticsearch-service:9200"

ingress:
  enabled: true
  hosts:
    - host: your-graylog-domain.com
      paths:
        - path: /
          pathType: Prefix
```

3. Install the chart:
```bash
helm install my-graylog eea/logcentral-graylog5 -f values-production.yaml
```

## Configuration

### Required Configuration

The following values MUST be configured before installation:

- `graylogMaster.config.passwordSecret`: Random string of at least 16 characters
- `graylogMaster.config.rootPasswordSha2`: SHA2 hash of the admin password
- `graylogMaster.config.httpExternalUri`: Public URL of your Graylog instance
- `externalServices.elasticsearch.link`: External Elasticsearch connection

### Password Hash Generation

To generate the required SHA2 password hash:
```bash
echo -n "your-admin-password" | sha256sum
```

### External Elasticsearch

This chart requires an external Elasticsearch cluster. Configure the connection via:
```yaml
externalServices:
  elasticsearch:
    link: "elasticsearch-service:9200"
```

### Storage Configuration

Configure persistent storage for each component:
```yaml
mongodb:
  persistence:
    enabled: true
    storageClass: "your-storage-class"
    size: 20Gi

graylogMaster:
  persistence:
    data:
      enabled: true
      storageClass: "your-storage-class"  
      size: 10Gi
    journal:
      enabled: true
      storageClass: "your-fast-storage-class"
      size: 50Gi
```

### Resource Limits

Configure resource limits for production:
```yaml
graylogMaster:
  resources:
    limits:
      memory: "4Gi"
    requests:
      memory: "2Gi"

mongodb:
  resources:
    limits:
      memory: "2Gi"
    requests:
      memory: "1Gi"
```

## Migration from Rancher 1

This chart is designed to replace Rancher 1 Docker Compose deployments. Key migration considerations:

1. **Volumes**: Migrate existing volume data to Kubernetes PVCs
2. **Configuration**: Convert environment variables to Helm values
3. **External Links**: Replace with Kubernetes services or external services
4. **Host Labels**: Replace with node selectors and affinity rules

## Log Ingestion

The load balancer exposes these ports for log ingestion:
- **1514/tcp & 1514/udp**: Syslog
- **12201/tcp & 12201/udp**: GELF

## Access

- **Web Interface**: Access via ingress or port-forward to graylog-master:9000
- **Default Credentials**: admin / (password you set in rootPasswordSha2)

## Troubleshooting

1. **Check pod status**:
```bash
kubectl get pods -l app.kubernetes.io/name=logcentral-graylog5
```

2. **Check logs**:
```bash
kubectl logs -l app.kubernetes.io/component=graylog-master
```

3. **Common issues**:
   - Ensure passwordSecret is at least 16 characters
   - Verify Elasticsearch connectivity
   - Check persistent volume provisioning

## Values Reference

See `values.yaml` for complete configuration options.

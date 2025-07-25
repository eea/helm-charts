# Elastic Engine

This chart is configured for production.

## Known Issues & Solutions

### Missing jvm.options Error

If you encounter the error:
```
Exception in thread "main" java.ni<dl>

  <dt>Version 0.1.11</dt>
  <dd>Fixed duplicate node.roles environment variable in master StatefulSet - simplified template logic to avoid configuration conflicts.</dd>

  <dt>Version 0.1.10</dt>
  <dd>Added configurable data role for master nodes - allows proper dedicated master/data node separation or combined roles based on cluster size.</dd>le.NoSuchFileException: /usr/share/elasticsearch/config/jvm.options
```

This happens when security is enabled (by setting `esmaster.password`) but the configuration volume is not properly initialized. The chart now includes automatic configuration initialization through init containers that:

1. Creates the required `jvm.options` and `elasticsearch.yml` files
2. Generates SSL certificates automatically
3. Sets proper file permissions

**Solution**: Upgrade to the latest version of this chart which includes the fix, or ensure your `esmaster.password` is properly set and the PVC has sufficient permissions.

### JVM Options Error

If you encounter errors like:
```
Error: VM option 'G1MixedGCLiveThresholdPercent' is experimental and must be enabled via -XX:+UnlockExperimentalVMOptions.
```

This indicates JVM configuration compatibility issues. The chart now uses a conservative JVM configuration that works across different Java versions without experimental options.

**Solution**: Upgrade to chart version 0.1.3 or later which includes compatible JVM options.

### Missing log4j2.properties Error

If you encounter errors like:
```
ERROR: no log4j2.properties found; tried [/usr/share/elasticsearch/config] and its subdirectories
ERROR: Elasticsearch did not exit normally - check the logs at /usr/share/elasticsearch/logs/es-cluster.log
```

This happens when the logging configuration is missing. The chart now includes a complete log4j2.properties configuration.

**Solution**: Upgrade to chart version 0.1.4 or later which includes the logging configuration.

### Kibana URL Configuration

The chart automatically generates the correct Kibana URL from ingress configuration. You have two options:

1. **Automatic URL (Recommended)**: Leave `kibana.url` empty and configure ingress settings. The chart will automatically generate the URL using:
   - `https://` if TLS is configured, otherwise `http://`
   - Host from `kibana.ingress.hosts[0].host`
   - Path from `kibana.ingress.hosts[0].paths[0].path`

2. **Manual URL**: Set `kibana.url` explicitly to override automatic generation.

**Note**: If you're seeing `http://kibana.example.com/` despite setting different ingress hosts, upgrade to version 0.1.13 or later. In version 0.1.12, the default hostname values were removed, and in version 0.1.13, the ingress validation was improved to handle Rancher UI configurations properly.

### SSL Certificate Format Error

If you encounter errors like:
```
failed to load SSL configuration [xpack.security.transport.ssl]; nested: ElasticsearchException[failed to initialize SSL TrustManager]; nested: IOException[toDerInputStream rejects tag type 80];
```

This indicates SSL certificate format issues. The chart now generates proper PKCS12 certificates instead of PEM format.

**Solution**: Upgrade to chart version 0.1.6 or later which includes correct certificate generation.

### Cluster Formation Issues

If you see data nodes connecting and disconnecting rapidly, or cluster health showing `"number_of_data_nodes": 0`, this indicates discovery or SSL certificate sharing problems.

**Common symptoms**:
- Nodes join and leave cluster repeatedly
- "transport connection closed by remote" messages
- Cluster health shows 0 data nodes despite pods running

**Solution**: Upgrade to chart version 0.1.7 or later which includes:
- Fixed discovery configuration with proper DNS names
- Shared SSL certificates across all nodes
- Master nodes configured with data role for initial cluster bootstrap

### Rancher UI Ingress Issues

If you're using Rancher UI to configure the chart and the Kibana ingress is not being created despite setting the hostname correctly, this may be due to configuration format conflicts.

**Common symptoms**:
- Ingress not created after setting hostname in Rancher UI
- Chart deployment succeeds but no ingress resource appears
- Hostname appears to be set correctly in Rancher but ingress template doesn't pick it up

**Solution**: 
- Upgrade to chart version 0.1.13 or later which includes improved ingress validation
- Ensure you're setting the hostname in the "Kibana Ingress Hostname" field under "Kibana Configuration"
- If upgrading from version 0.1.12, the ingress validation has been simplified for better Rancher compatibility

### Troubleshooting

1. **Check pod status**:
   ```bash
   kubectl get pods -l component=master
   kubectl logs <pod-name> -c config-init  # Check init container logs
   ```

2. **Check PVC**:
   ```bash
   kubectl get pvc elasticconfig
   kubectl describe pvc elasticconfig
   ```

3. **Manual config reset** (if needed):
   ```bash
   kubectl delete pvc elasticconfig
   helm upgrade <release-name> ./elastic7
   ```

## Configuration

### Kibana Ingress Configuration

The chart supports configuring Kubernetes Ingress for Kibana access through the following parameters:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kibana.url` | Manual Kibana URL override (optional) | `""` (auto-generated) |
| `kibana.ingress.enabled` | Enable ingress for Kibana | `true` |
| `kibana.ingress.hosts[0].host` | Hostname for Kibana ingress | `""` (must be set) |
| `kibana.ingress.hosts[0].paths[0].path` | Path for Kibana ingress | `/` |
| `kibana.ingress.hosts[0].paths[0].pathType` | Path type for ingress | `Prefix` |
| `kibana.ingress.className` | Ingress class name | `""` |
| `kibana.ingress.annotations` | Ingress annotations | `{}` |
| `kibana.ingress.tls[0].secretName` | TLS secret name | `""` |
| `kibana.ingress.tls[0].hosts[0]` | TLS hostname | `""` |

### Security Configuration

When enabling security features by setting `esmaster.password`, the chart automatically:
- Enables X-Pack security
- Generates SSL certificates for transport encryption
- Creates proper configuration files
- Sets up authentication

### Example Configurations

#### Basic Ingress
```yaml
kibana:
  ingress:
    enabled: true
    hosts:
      - host: kibana.company.com
        paths:
          - path: /
            pathType: Prefix
```

#### Ingress with TLS
```yaml
kibana:
  ingress:
    enabled: true
    className: nginx
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
      - host: kibana.company.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: kibana-tls
        hosts:
          - kibana.company.com
```

#### Secure Elasticsearch with Authentication
```yaml
esmaster:
  password: "your-strong-password"  # Enables security automatically
kibana:
  password: "kibana-user-password"  # For kibana_system user
```

#### Command Line Installation
```bash
# Basic installation with custom hostname
helm install elastic7 ./elastic7 \
  --set kibana.ingress.hosts[0].host=kibana.mycompany.com

# Installation with TLS and authentication
helm install elastic7 ./elastic7 \
  --set esmaster.password=mySecurePassword123 \
  --set kibana.password=kibanaPassword123 \
  --set kibana.ingress.hosts[0].host=kibana.mycompany.com \
  --set kibana.ingress.tls[0].secretName=kibana-tls \
  --set kibana.ingress.tls[0].hosts[0]=kibana.mycompany.com
```

#### Rancher UI Configuration

When deploying through Rancher UI, follow these steps for proper Kibana ingress configuration:

1. **Enable Kibana**: Set `Add kibana container` to `true` (under Kibana Configuration)
2. **Enable Ingress**: Set `Enable Kibana Ingress` to `true` (under Kibana Configuration)
3. **Set Hostname**: Enter your desired hostname in `Kibana Ingress Hostname` field (e.g., `kibana.mycompany.com`)
4. **Configure TLS** (optional): If using TLS, set `TLS Certificate Hostname` to match your ingress hostname

**Important**: Ensure you're using chart version 0.1.13 or later for optimal Rancher UI compatibility.

## Releases

<dl>

  <dt>Version 0.1.14</dt>
  <dd>Fixed Kubernetes ingress validation error - prevented creation of ingress with empty rules when hostname is not properly set. Added proper hostname validation to ensure ingress is only created when valid hostnames are configured.</dd>

  <dt>Version 0.1.13</dt>
  <dd>Improved Kibana ingress validation - fixed issue where ingress was not generated when using Rancher UI due to overly strict hostname validation. Simplified template logic for better compatibility with different deployment methods.</dd>

  <dt>Version 0.1.12</dt>
  <dd>Fixed Kibana ingress hostname hardcoded issue - removed default 'kibana.example.com' values from values.yaml and questions.yaml to prevent overriding user-configured hostnames. Enhanced ingress template with hostname validation.</dd>

  <dt>Version 0.1.11</dt>
  <dd>Fixed duplicate node.roles environment variable in master StatefulSet - simplified template logic to avoid configuration conflicts.</dd>

  <dt>Version 0.1.10</dt>
  <dd>Added configurable data role for master nodes - allows proper dedicated master/data node separation or combined roles based on cluster size.</dd>

  <dt>Version 0.1.9</dt>
  <dd>Simplified configuration - removed redundant initialDataNodes variable, now using esworker.replicaCount consistently throughout the chart.</dd>

  <dt>Version 0.1.8</dt>
  <dd>Implemented dynamic node discovery - automatically generates seed hosts and initial master nodes based on replica counts for flexible cluster configurations.</dd>

  <dt>Version 0.1.7</dt>
  <dd>Fixed cluster formation issues - improved discovery configuration, shared SSL certificates, and added data role to master nodes for proper bootstrap.</dd>

  <dt>Version 0.1.6</dt>
  <dd>Fixed SSL certificate format issue - now generates proper PKCS12 certificates instead of PEM format to prevent TrustManager errors.</dd>

  <dt>Version 0.1.5</dt>
  <dd>Fixed Kibana URL auto-generation from ingress configuration. The chart now automatically builds the correct URL from ingress settings.</dd>

  <dt>Version 0.1.4</dt>
  <dd>Added missing log4j2.properties configuration file to fix logging initialization errors.</dd>

  <dt>Version 0.1.3</dt>
  <dd>Fixed JVM options compatibility issue - removed experimental G1MixedGCLiveThresholdPercent option that caused startup failures.</dd>

  <dt>Version 0.1.2</dt>
  <dd>Fixed missing jvm.options error when security is enabled. Added automatic configuration initialization.</dd>

  <dt>Version 0.1.1</dt>
  <dd>Fix env variables.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


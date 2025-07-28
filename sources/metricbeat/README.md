# Metricbeat Helm Chart

This Helm chart deploys Metricbeat as a DaemonSet to collect Kubernetes metrics and system metrics from all nodes in the cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Elasticsearch cluster (for metrics storage)

## Installing the Chart

To install the chart with the release name `metricbeat`:

```bash
helm install metricbeat ./metricbeat
```

The command deploys Metricbeat on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `metricbeat` deployment:

```bash
helm delete metricbeat
```

## Configuration

The following table lists the configurable parameters of the Metricbeat chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Metricbeat image repository | `docker.elastic.co/beats/metricbeat` |
| `image.tag` | Metricbeat image tag | `8.12.2` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `namespace` | Namespace to deploy Metricbeat | `kube-system` |
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.name` | Service account name | `metricbeat` |
| `rbac.create` | Create RBAC resources | `true` |
| `elasticsearch.host` | Elasticsearch hostname | `elastic7-data.elastic.svc.cluster.local` |
| `elasticsearch.port` | Elasticsearch port | `9200` |
| `elasticsearch.protocol` | Elasticsearch protocol | `http` |
| `elasticsearch.username` | Elasticsearch username | `"${ELASTICSEARCH_USERNAME}"` |
| `elasticsearch.password` | Elasticsearch password | `"${ELASTICSEARCH_PASSWORD}"` |
| `container.resources.limits.memory` | Memory limit | `200Mi` |
| `container.resources.requests.cpu` | CPU request | `100m` |
| `container.resources.requests.memory` | Memory request | `100Mi` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install metricbeat ./metricbeat \
  --set elasticsearch.host=my-elasticsearch.example.com \
  --set elasticsearch.port=9200 \
  --set elasticsearch.protocol=https \
  --set elasticsearch.username=elastic \
  --set elasticsearch.password=mypassword
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example:

```bash
helm install metricbeat ./metricbeat -f values.yaml
```

## Common Configuration Examples

### External Elasticsearch with HTTPS
```bash
helm install metricbeat ./metricbeat \
  --set elasticsearch.host=elasticsearch.company.com \
  --set elasticsearch.port=9200 \
  --set elasticsearch.protocol=https \
  --set elasticsearch.username=metricbeat \
  --set elasticsearch.password=mypassword
```

### Local Elasticsearch service
```bash
helm install metricbeat ./metricbeat \
  --set elasticsearch.host=elasticsearch.default.svc.cluster.local \
  --set elasticsearch.port=9200 \
  --set elasticsearch.protocol=http
```

### Metricbeat only (without metrics-server)
```bash
helm install metricbeat ./metricbeat \
  --set metricsServer.enabled=false \
  --set elasticsearch.host=my-elasticsearch.com
```

## Features

This Metricbeat chart includes:

- **DaemonSet deployment** - Runs on every node to collect node-level metrics
- **RBAC configuration** - Proper permissions to access Kubernetes APIs
- **Flexible Elasticsearch configuration** - Separate host, port, and protocol settings for easy customization
- **Optional Metrics Server** - Includes metrics-server deployment (can be disabled)
- **Multiple metric collection**:
  - Kubernetes cluster state metrics (via kube-state-metrics)
  - Node system metrics (CPU, memory, filesystem, network)
  - Kubernetes API server metrics
  - Pod and container metrics
- **Autodiscovery** - Automatically discovers and monitors Kubernetes resources
- **Configurable output** - Sends metrics to Elasticsearch

## Metrics Collected

- **System metrics**: CPU, memory, network, filesystem, processes
- **Kubernetes metrics**: 
  - Node, pod, container, and volume metrics
  - Deployment, DaemonSet, StatefulSet status
  - Service and persistent volume information
  - Job and CronJob status
  - Namespace and resource quota information

## Troubleshooting

1. **Check DaemonSet status**:
   ```bash
   kubectl get daemonset metricbeat -n kube-system
   ```

2. **View pod logs**:
   ```bash
   kubectl logs -l k8s-app=metricbeat -n kube-system
   ```

3. **Verify RBAC permissions**:
   ```bash
   kubectl auth can-i get nodes --as=system:serviceaccount:kube-system:metricbeat
   ```

4. **Check Elasticsearch connectivity**:
   ```bash
   kubectl exec -it ds/metricbeat -n kube-system -- metricbeat test output
   ```

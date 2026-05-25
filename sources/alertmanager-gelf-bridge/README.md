# alertmanager-gelf-bridge

Small Helm chart that deploys an Alertmanager webhook receiver and forwards each alert as a structured GELF HTTP message to Graylog.

## Required values

```yaml
clusterName: "01test"
graylogUrl: "http://graylog.example:12202/gelf"
```

## Recommended AlertmanagerConfig

Create this separately in Rancher UI after the bridge is running:

```yaml
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: graylog-gelf-http
  namespace: cattle-monitoring-system
spec:
  route:
    receiver: graylog-gelf-http
  receivers:
    - name: graylog-gelf-http
      webhookConfigs:
        - url: http://alertmanager-gelf-bridge.cattle-monitoring-system.svc:8080/
          sendResolved: true
```

If the Helm release name is not `alertmanager-gelf-bridge`, adjust the service name accordingly.

## Graylog fields

Use `source_type:alertmanager` to filter these messages.

Use `alert_status` for individual alert state:

- `alert_status:firing`
- `alert_status:resolved`

`notification_status` is the top-level Alertmanager webhook status and may differ from `alert_status` for grouped notifications.

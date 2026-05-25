# alertmanager-gelf-bridge

Small Helm chart that deploys an Alertmanager webhook receiver and forwards each alert as a structured GELF HTTP message to Graylog.

## Required values

```yaml
clusterName: "01test"
graylogUrl: "http://graylog.example:12202/gelf"
```

## Optional AlertmanagerConfig

The chart can optionally create the `AlertmanagerConfig` too:

```yaml
alertmanagerConfig:
  enabled: true
  name: graylog-gelf-http
  receiverName: graylog-gelf-http
  sendResolved: true
```

If disabled, create the AlertmanagerConfig separately in Rancher UI after the bridge is running.

## Graylog fields

Use `source_type:alertmanager` to filter these messages.

Use `alert_status` for individual alert state:

- `alert_status:firing`
- `alert_status:resolved`

`notification_status` is the top-level Alertmanager webhook status and may differ from `alert_status` for grouped notifications.

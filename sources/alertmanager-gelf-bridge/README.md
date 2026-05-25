# alertmanager-gelf-bridge

Small Helm chart that deploys an Alertmanager webhook receiver and forwards each alert as a structured GELF HTTP message to Graylog.

## Required values

```yaml
clusterName: "01test"
graylogUrl: "http://graylog.example:12202/gelf"
```

## Recommended routing pattern

By default, this chart deploys only the bridge:

```yaml
alertmanagerConfig:
  enabled: false
```

This is recommended when the cluster already has AlertmanagerConfig resources. Create or manage Alertmanager routing separately to avoid overlapping top-level routes.

## Optional AlertmanagerConfig

The chart can optionally create an AlertmanagerConfig:

```yaml
alertmanagerConfig:
  enabled: true
  name: graylog-gelf-http-config
  receiverName: graylog-gelf-http-receiver
  sendResolved: true
  matchers: []
  continue: null
```

Important: prometheus-operator can inject namespace matchers and route continuation when merging multiple AlertmanagerConfig resources. If several top-level routes match the same alert, duplicate notifications can occur.

## Graylog fields

Use `source_type:alertmanager` to filter these messages.

Use `alert_status` for individual alert state:

- `alert_status:firing`
- `alert_status:resolved`

`notification_status` is the top-level Alertmanager webhook status and may differ from `alert_status` for grouped notifications.

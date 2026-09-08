# Reportnet BDR Registry Notifications

BDR Registry Notifications Service Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

External configuration:
- `envFrom` - Extra `envFrom` sources (ConfigMap/Secret references) added to the container. Kubernetes applies them in order, so later entries override earlier ones. Defaults to [].
- `inlineEnv` - Render the per-key application settings from this chart's values as inline `env` entries. Defaults to true, which preserves the previous behaviour.

Set `inlineEnv: false` when the application settings are supplied entirely
through `envFrom`. Kubernetes gives inline `env` precedence over `envFrom`,
and this chart ships non-empty defaults of its own:

```yaml
emailHost: postfix
mailHost: postfix:25
redisHost: redis
```

Leaving `inlineEnv` enabled would let those silently mask the values coming
from your ConfigMap/Secret.

`UWSGI_PORT` is derived from `service.port` and is always rendered inline,
regardless of `inlineEnv`.

Example - all settings from an external ConfigMap and Secret:

```yaml
inlineEnv: false
envFrom:
  - configMapRef:
      name: my-notifications-env
  - secretRef:
      name: my-notifications-secrets
```

Because a parent chart cannot template a sub-chart's values, the referenced
names have to be written out in full here. Keeping the names fixed also means
the wiring does not change when the Secret is later supplied by an external
controller such as External Secrets or SealedSecrets.

## Releases

### Version 0.2.1 - 15 April 2025
- Updated appVersion to 1.4.5 [Diana Boiangiu - [`68a4c5f`](https://github.com/eea/helm-charts/commit/68a4c5f96e785a8ed6188bc3f5892fcf6de37939)]

### Version 0.2.0 - 11 April 2025
- Updated appVersion to 1.4.3. [Diana Boiangiu - [`13dc5ed`](https://github.com/eea/helm-charts/commit/13dc5ed21698977a1af4ce367033b541f44f7944)]

### Version 0.1.10
- Fixed port for redis service egress.

### Version 0.1.9
- Allow egress to redis.

### Version 0.1.8
- Fixed component label in networkpolicy.

### Version 0.1.7
- Added networkpolicy template.

### Version 0.1.6
- Disabled probes when debugTail is enabled.

### Version 0.1.5
- Added debugTail to values.yaml.

### Version 0.1.4
- Added basic livenessprobe for qcluster operation.

### Version 0.1.3
- Added redisHost and redisPort env variables in deployment

### Version 0.1.2
- Added deploymentArgs to values.yaml

### Version 0.1.1
- Added Notifications Token env variable

### Version 0.1.0
- Initial release.

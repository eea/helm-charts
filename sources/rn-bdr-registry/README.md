# Reportnet BDR Registry

BDR Registry Service Chart for BDR

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
bdrServerUrl: https://replace.me/
emailHost: postfix
emailPort: "25"
```

Leaving `inlineEnv` enabled would let those silently mask the values coming
from your ConfigMap/Secret.

`BDR_REG_PORT` is derived from `service.port` and is always rendered inline,
regardless of `inlineEnv`.

Example - all settings from an external ConfigMap and Secret:

```yaml
inlineEnv: false
envFrom:
  - configMapRef:
      name: my-bdr-registry-env
  - secretRef:
      name: my-bdr-registry-secrets
```

Because a parent chart cannot template a sub-chart's values, the referenced
names have to be written out in full here. Keeping the names fixed also means
the wiring does not change when the Secret is later supplied by an external
controller such as External Secrets or SealedSecrets.

## Releases

### Version 0.2.1 - 08 September 2026
- Added support for envFrom to be used in parent charts [Olimpiu Rob - [`bc68dcfb`](https://github.com/eea/helm-charts/commit/bc68dcfb52d2099e165ebf7bbee8654f6201145e)]

### Version 0.2.0 - 11 April 2025
- Updated appVersion to 1.9.3. [Diana Boiangiu - [`9a351d5`](https://github.com/eea/helm-charts/commit/9a351d5d9434d147d3e4605f0f6fee01e8aa5757)]

### Version 0.1.7
- Updated appVersion to 1.8.11.

### Version 0.1.6
- Added support for custom network policies.

### Version 0.1.5
- Updated appVersion to 1.8.10

### Version 0.1.4
- Added missing authLdapServerUri to deployment template.

### Version 0.1.3
- Disabled probes when debugTail is enabled.

### Version 0.1.2
- Added debugTail flag.

### Version 0.1.1
- Updated appVersion to 1.8.9

### Version 0.1.0
- Initial release.

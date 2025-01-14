# Reportnet Varnish

Varnish for Reportek.

[See more](https://github.com/eea/eea.docker.varnish-reportek)

## Configuration

- `timezone` - Time zone.
- `varnishHTTPPort` - Port for HTTP traffic.
- `varnishHTTPSPort` - Port for HTTPS traffic.
- `varnishSize` - Size of the varnish cache.
- `autoKillCron` - Auto kill cron.
- `varnishCFGContent` - Content of the configuration file.
- `varnishBackend` - Backend to use.
- `varnishBackendPort` - Port of the backend.
- `varnishDNSTTL` - TTL for DNS.
- `varnishBERESPTTL` - TTL for BERESP.
- `varnishBERESPGrace` - Grace period for BERESP.
- `varnishBERESPKeep` - Keep period for BERESP.
- `networkPolicy.enabled` - Enable network policy. Defaults to true.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

Default network policy includes:
- Ingress:
  - Allow access from ingress-nginx in kube-system namespace
  - Allow access from same namespace
- Egress:
  - Allow DNS resolution (kube-dns/coredns in kube-system namespace)

Example using additionalIngress/Egress (adds to defaults):
```yaml
networkPolicy:
  additionalIngress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
  additionalEgress:
    - to:
        - podSelector:
            matchLabels:
              app: backend
```

Example using spec (overrides defaults):
```yaml
networkPolicy:
  spec:
    ingress:
      - from:
          - podSelector:
              matchLabels:
                app: custom-frontend
    egress:
      - to:
          - podSelector:
              matchLabels:
                app: custom-backend
```

## Releases

### Version 0.1.7
- Added additional ingress/egress rules support

### Version 0.1.6
- Added NetworkPolicy support

### Version 0.1.5
- Updated appVersion to 7.5-1.0

### Version 0.1.4
- Some refactoring and added component labels

### Version 0.1.3
- Removed autoKillCron variable since, using it, causes varnish to no longer respond

### Version 0.1.2
- Changed default port to 8080

### Version 0.1.1
- Added enabled flag

### Version 0.1.0
- Initial release

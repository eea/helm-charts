# Reportnet BDR Apache

BDR Apache Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

## Releases

### Version 0.2.0 - 13 March 2025
- Automated release of [eeacms/apache:2.4-3.4](https://github.com/eea/eea.docker.apache/releases) [EEA Jenkins - [`418c9ac`](https://github.com/eea/helm-charts/commit/418c9ac646b7ba0462fe828081653286d7b1dfce)]

### Version 0.1.8
- Added default timezone configuration.

### Version 0.1.7
- Updated to Apache 2.4-3.4-alpine.
- Added network policy configuration.

### Version 0.1.6
  - Added registries health checks

### Version 0.1.5
  - Added matomo in script-src CSP

### Version 0.1.4
  - Further tweaks to the mailtrap rewrite rule

### Version 0.1.3
  - Tweaked the mailtrap rewrite rule

### Version 0.1.2
  - Renamed mailtrap host to service so that it's clearer that it requires the service name

### Version 0.1.1
  - Added mailtrap configuration

### Version 0.1.0
  - Initial release.

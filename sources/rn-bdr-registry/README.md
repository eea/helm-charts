# Reportnet BDR Registry

BDR Registry Service Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

## Releases

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

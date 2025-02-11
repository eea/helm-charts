# Reportnet BDR Registry Notifications

BDR Registry Notifications Service Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

## Releases

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

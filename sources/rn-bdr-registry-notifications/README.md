# Reportnet BDR Registry Notifications

BDR Registry Notifications Service Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

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

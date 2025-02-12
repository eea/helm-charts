# Reportnet BDR European Registry

BDR European Registry Service Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

## Releases

### Version 0.1.5
- Added network policy support.

### Version 0.1.4
- Updated appVersion to 2.4.0.

### Version 0.1.3
- Disabled liveness and readiness probes when debugTail is enabled.

### Version 0.1.2
- Fixed debugTail default flag.

### Version 0.1.1
- Added debugTail flag.

### Version 0.1.0
- Initial release.

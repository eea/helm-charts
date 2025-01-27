# Reportnet Local Converters

The Reportek local converters is an addon Product for local conversions scripts.

[See more](https://github.com/eea/eea.docker.reportek.local-converters)

## Configuration

- `timezone` - Time zone.
- `networkPolicy.enabled` - Enable network policy. Defaults to true.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

Default network policy includes:
- Ingress:
  - Allow access from the same namespace.
- Egress:
  - Default deny.

## Releases

### Version 0.1.6
- Increase granularity of the network policy.

### Version 0.1.5
- Renamed network policy metadata component label to network-policy.

### Version 0.1.4
- Added NetworkPolicy support.

### Version 0.1.3
- Tweaked hpa name.
- Fixed README.

### Version 0.1.2
- Some refactoring and added component label.

### Version 0.1.1
- Added enabled flag.

### Version 0.1.0
- Initial release.

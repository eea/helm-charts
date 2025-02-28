# Reportnet BDR LDAP Helm Chart

LDAP Service Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

## Releases

- ### Version 0.1.2
  - Added network policy support.

- ### Version 0.1.1
  - Expose the pvc storage size in the values.yaml(default *storage: 1Gi*)

- ### Version 0.1.0
  - Initial release.

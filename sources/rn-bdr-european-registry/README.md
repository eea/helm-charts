# Reportnet BDR European Registry

BDR European Registry Service Chart for BDR

Network Policy:
- `networkPolicy.enabled` - Enable network policy. Defaults to false.
- `networkPolicy.additionalIngress` - Additional ingress rules to be added to the default ones. Defaults to [].
- `networkPolicy.additionalEgress` - Additional egress rules to be added to the default ones. Defaults to [].
- `networkPolicy.spec` - Additional network policy specifications to be merged with the policy. **Note**: Defining `ingress` or `egress` in spec will completely override the default rules and `additional*` rules. Defaults to {}.

## Releases

### Version 1.0.0 - 10 February 2026
- Updated appVersion to 3.0.0 [Diana Boiangiu - [`db7685da`](https://github.com/eea/helm-charts/commit/db7685da41b47d8440f5d603007a7cba0366bb47)]

### Version 0.1.17 - 02 February 2026
- Updated appVersion to 2.5.5 [Diana Boiangiu - [`010bb02b`](https://github.com/eea/helm-charts/commit/010bb02bd9cb45b99a6daa6cc31395cbc8639cd8)]

### Version 0.1.16 - 15 October 2025
- Updated appVersion to 2.5.4 [Diana Boiangiu - [`261dc5e2`](https://github.com/eea/helm-charts/commit/261dc5e24a14c6ec78ec440e3a034e742046d695)]

### Version 0.1.15 - 15 October 2025
- Updated appVersion to 2.5.3 [Diana Boiangiu - [`77513423`](https://github.com/eea/helm-charts/commit/77513423d0b3c60d1d6a8bdce593602550c784c5)]

### Version 0.1.14 - 28 April 2025
- Updated appVersion to 2.5.2 [Diana Boiangiu - [`df49391`](https://github.com/eea/helm-charts/commit/df493911e97c378e0683e57f9cedc28a78300c94)]

### Version 0.1.13 - 15 April 2025
- Updated appVersion to 2.5.1 [Diana Boiangiu - [`22b5ac8`](https://github.com/eea/helm-charts/commit/22b5ac89ca2180722ab177ebd60093ee74133aa9)]

### Version 0.1.12
- Updated appVersion to 2.5.0.

### Version 0.1.11
- Updated appVersion to 2.4.6.

### Version 0.1.10
- Updated appVersion to 2.4.5.

### Version 0.1.9
- Updated appVersion to 2.4.4.

### Version 0.1.8
- Updated appVersion to 2.4.3.

### Version 0.1.7
- Updated appVersion to 2.4.2.

### Version 0.1.6
- Updated appVersion to 2.4.1.

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

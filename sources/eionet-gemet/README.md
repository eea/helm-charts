# Eionet GEMET

This chart is (almost) configured for production.

## Releases

### Version 0.6.0 - 30 June 2026
- Upgrade eeacms/gemet:2.2.3, use bitnamilegacy as a source [valentinab25 - [`30c05cd3`](https://github.com/eea/helm-charts/commit/30c05cd3bef7fb52f0c7b7f1dc9b098ee963f9ce)]

### Version 0.5.4 - 03 June 2026
- Use nginx:1.31.1-alpine with configmap [valentinab25 - [`be56fcc1`](https://github.com/eea/helm-charts/commit/be56fcc18358c74e0d55b803f4104e77e78617c3)]

### Version 0.5.3 - 13 March 2025
- Automated release of [eeacms/apache:2.4-3.4](https://github.com/eea/eea.docker.apache/releases) [EEA Jenkins - [`36a7b01`](https://github.com/eea/helm-charts/commit/36a7b016db51559df4a1bd443d71133d82e1a12d)]


### Version 0.5.2 - 13 August 2024
- Made it the address of the backend configurable.

### Version 0.5.1 - 13 August 2024
- Made replica count for webserver configurable.

### Version 0.5.0 - 7 August 2024
- Moved the security headers to standard Ingress annotations.

### Version 0.4.0 - 14 June 2024
- Implemented autoscaling for the gemet pod.

### Version 0.3.0
- Replaced the home-made postgres deployment with bitnami dependency.

### Version 0.2.0
- Removed mysql database, postfix, zope and zeo.

### Version 0.1.1
- Set UTF-8 and LANG environment variable on database pods.

### Version 0.1.0
- Initial version.



## Deployment

The chart is not prepared for testing, and won't come up correctly with default values. However, the
only value to set is the `secretKey`, and can be set to a random string. For deployment in production,
set better values where you see 'REPLACEME'. You will still have an empty database though.

| Key | Description | Default |
| --- | ----------- | ------- |
| autoscaling.enabled | Turn on horisontal scaling for the gemet pod | false |
| secretKey | Used for gemet to async communication | "" |


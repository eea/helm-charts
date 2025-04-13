# Climate Advisory Board backend - Plone 6

This chart deployes the Climate Advisory Board backend app 


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| debug.enabled | bool | false | Activate the Plone debug instance |

## Releases

### Version 1.7.0 - 13 April 2025
- Automated release of [eeacms/advisory-board-backend:6.0.15-3](https://github.com/eea/advisory-board-backend/releases) [EEA Jenkins - [`afad03c`](https://github.com/eea/helm-charts/commit/afad03c088b6eb266def3beee31aba28906441e2)]

### Version 1.6.0 - 11 April 2025
- Automated release of [eeacms/advisory-board-backend:6.0.15-2](https://github.com/eea/advisory-board-backend/releases) [EEA Jenkins - [`6474bd9`](https://github.com/eea/helm-charts/commit/6474bd97699a064d3bf3492151e4400f638ed8e4)]

### Version 1.5.0 - 09 April 2025
- Automated release of [eeacms/advisory-board-backend:6.0.14-1](https://github.com/eea/advisory-board-backend/releases) [EEA Jenkins - [`354b4df`](https://github.com/eea/helm-charts/commit/354b4dfaaf743ec4349c2907a2f461a4eac13639)]

### Version 1.4.2 - 09 April 2025
- Added plone.googleUrl variable, separated google ingress [valentinab25 - [`77ad0aa`](https://github.com/eea/helm-charts/commit/77ad0aaa595cbfc4fdd538954992b7897af5a3dd)]

### Version 1.4.1 - 08 April 2025
- Add ingress.tls, plone.site variables, rewrite api-ingress [valentinab25 - [`af3acea`](https://github.com/eea/helm-charts/commit/af3acea1f7d28816aa66ed3cf2813bc5962c7597)]

### Version 1.4.0 - 01 April 2025
- Automated release of [eeacms/advisory-board-backend:6.0.13-17](https://github.com/eea/advisory-board-backend/releases) [EEA Jenkins - [`dc92069`](https://github.com/eea/helm-charts/commit/dc920696e09d97e7dd6ba56c1753c6748dbced4f)]

### Version 1.3.0 - 13 March 2025
- Automated release of [eeacms/advisory-board-backend:6.0.13-16](https://github.com/eea/advisory-board-backend/releases)

### Version 1.2.1 - 12 March 2025
- Automated release of [eeacms/plone-varnish:7.6-1.0](https://github.com/eea/plone-varnish/releases)

### Version 1.2.0 - 25 February 2025
- Automated release of [eeacms/advisory-board-backend:6.0.13-14](https://github.com/eea/advisory-board-backend/releases)


### Version 1.1.1
- Release of dependent chart postfix:3.0.6
- :warning: Breaking changes - manually remove the postix deployment before upgrade

### Version 1.0.3
- Added `SENTRY_ENVIRONMENT` variable

### Version 1.0.2
- Rename components to backend- 

### Version 1.0.1
- Questions update

### Version 1.0.0
- Initial release. Version matching Rancher 1 catalog version.


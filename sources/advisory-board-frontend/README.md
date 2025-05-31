# Climate Advisory Board frontend - Plone 6

This chart deployes the Climate Advisory Board frontend app 


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| links.backend | string | NAME.NAMESPACE | Service name for varnish for backend instance, followed by the namespace. |

## Releases

### Version 1.4.1 - 21 May 2025
- Automated release of [eeacms/plone-varnish:7.7-1.0](https://github.com/eea/plone-varnish/releases) [EEA Jenkins - [`6dfa0a9`](https://github.com/eea/helm-charts/commit/6dfa0a9ee178c65428561851b78113c762859c2a)]

### Version 1.4.0 - 16 May 2025
- Automated release of [eeacms/advisory-board-frontend:1.15.0](https://github.com/eea/advisory-board-frontend/releases) [EEA Jenkins - [`3e3e4b3`](https://github.com/eea/helm-charts/commit/3e3e4b32fb9fa187a8e342b40a13d096f5ef20ca)]

### Version 1.3.1 - 16 April 2025
- Added debug deployment with volume for dev adddons [valentinab25 - [`ad6c433`](https://github.com/eea/helm-charts/commit/ad6c433e289e5ec796b6aed8a46ab16f366ba51b)]

### Version 1.3.0 - 02 April 2025
- Automated release of [eeacms/advisory-board-frontend:1.14.0](https://github.com/eea/advisory-board-frontend/releases) [EEA Jenkins - [`8c38ff0`](https://github.com/eea/helm-charts/commit/8c38ff0bb87494e5e85b0f4614a245d46830e88c)]

### Version 1.2.2 - 31 March 2025
- Added variable to allow empty certificate name for default certificate [valentinab25 - [`f8e7b62`](https://github.com/eea/helm-charts/commit/f8e7b627bd0e1ede8fa7e16a5b39a7665cbf89bb)]

### Version 1.2.1 - 12 March 2025
- Automated release of [eeacms/plone-varnish:7.6-1.0](https://github.com/eea/plone-varnish/releases)

### Version 1.2.0 - 24 February 2025
- Automated release of eeacms/advisory-board-frontend:1.12.0

### Version 1.0.2 
- Rename services to be frontend

### Version 1.0.1
- Add http probes to volto

### Version 1.0.0
- Initial release. Version matching Rancher 1 catalog version.

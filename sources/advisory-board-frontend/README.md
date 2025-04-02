# Climate Advisory Board frontend - Plone 6

This chart deployes the Climate Advisory Board frontend app 


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| links.backend | string | NAME.NAMESPACE | Service name for varnish for backend instance, followed by the namespace. |

## Releases

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

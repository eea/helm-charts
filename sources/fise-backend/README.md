# Forest Information System of Europe website backend - Plone 6

This chart deployes the Forest Information System of Europe website backend app

## Values

| Key           | Type | Default | Description                       |
| ------------- | ---- | ------- | --------------------------------- |
| debug.enabled | bool | false   | Activate the Plone debug instance |

## Releases

### Version 1.0.4 - 31 March 2025
- keep only one configuration for ++api++ [valentinab25 - [`caf67b9`](https://github.com/eea/helm-charts/commit/caf67b9051d52256a637d7e33f4df3c1bdcaf175)]

### Version 1.0.3 - 31 March 2025
- Breaking change on ingress, add both configurations for ++api++ ingress [valentinab25 - [`bc1b176`](https://github.com/eea/helm-charts/commit/bc1b1760a0c505c76d74cd1de79737a12f65837c)]

### Version 1.0.2 - 20 March 2025
- Add ingress.tls variable, empty certificate name for default [valentinab25 - [`5cceb9b`](https://github.com/eea/helm-charts/commit/5cceb9b60d74a9d703476694a250d0cd2a38c252)]

### Version 1.0.0

- Initial release.

### Version 1.0.1

- Update values.

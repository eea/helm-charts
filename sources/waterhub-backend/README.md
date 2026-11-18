# WaterHub backend - Plone 6

This chart deploys the Copernicus Thematic Water Hub backend (eeacms/waterhub-backend).

Deploy in the same namespace as `plone-postgres`, `waterhub-backend` and `waterhub-frontend`.

## Releases

### Version 0.1.3 - 18 November 2026
- Release eeacms/waterhub-backend:6.1.4-3; use waterhub as Plone site id, restore STATIC_BANNER_ENABLED_waterhub [Mihai Dobrescu - [`e3f1ba8e9`](https://github.com/eea/helm-charts/commit/e3f1ba8e986c81a9c854d74530c47cb84427eb18)]

### Version 0.1.2 - 16 November 2026
- Security hardening: ClusterIP-only services, /admin exposed only behind Basic Auth, remove advisory-board Google verification and Sentry Expect-CT defaults [Mihai Dobrescu - [`10daa5e4b`](https://github.com/eea/helm-charts/commit/10daa5e4be52446f9ce9fbac88ace0dedd98ea21)]

### Version 0.1.1 - 16 November 2026
- Load credentials from an existing Secret [Mihai Dobrescu - [`26d3133b4`](https://github.com/eea/helm-charts/commit/26d3133b47d5304bb58d5dae00e769e93eb7fbff)]

### Version 0.1.0 - 16 November 2026
- initial helm chart configuration [Mihai Dobrescu - [`e11a9ea39`](https://github.com/eea/helm-charts/commit/e11a9ea39b039f7c94569c27e270861dbcbcdc5f)]


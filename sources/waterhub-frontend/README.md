# WaterHub frontend - Plone 6

This chart deploys the Copernicus Thematic Water Hub frontend (eeacms/waterhub-frontend).

Deploy in the same namespace as `plone-postgres`, `waterhub-backend` and `waterhub-frontend`.

## Releases

### Version 0.2.1 - 18 November 2026
- Point RAZZLE_INTERNAL_API_PATH to the waterhub Plone site [Mihai Dobrescu - [`74eba248b`](https://github.com/eea/helm-charts/commit/74eba248ba7276e47956b4fb3f4b60e7e66163c6)]

### Version 0.2.0 - 18 November 2026
- Automated release of [eeacms/waterhub-frontend:1.0.0](https://github.com/eea/waterhub-frontend/releases) [EEA Jenkins - [`65d011676`](https://github.com/eea/helm-charts/commit/65d0116768fa43eb18618e9bae5face481fb4a68)]

### Version 0.1.2 - 16 November 2026
- Security hardening: ClusterIP-only services, /admin exposed only behind Basic Auth, remove advisory-board Google verification and Sentry Expect-CT defaults [Mihai Dobrescu - [`9201b1d01`](https://github.com/eea/helm-charts/commit/9201b1d01bf26b2b615affec6f7c5e82f91bd9c3)]

### Version 0.1.1 - 16 November 2026
- Load credentials from an existing Secret [Mihai Dobrescu - [`9494437e6`](https://github.com/eea/helm-charts/commit/9494437e6182638de51de62d1ebe00bbbba23432)]

### Version 0.1.0 - 16 November 2026
- initial helm chart configuration [Mihai Dobrescu - [`df9da9871`](https://github.com/eea/helm-charts/commit/df9da987130c25f005b2b36bdff3601408d0f644)]


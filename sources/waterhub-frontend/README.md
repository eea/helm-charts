# WaterHub frontend - Plone 6

This chart deploys the Copernicus Thematic Water Hub frontend (eeacms/waterhub-frontend).

Deploy in the same namespace as `plone-postgres`, `waterhub-backend` and `waterhub-frontend`.

## Releases

### Version 0.3.0 - 20 November 2026
- Automated release of [eeacms/waterhub-frontend:1.1.0](https://github.com/eea/waterhub-frontend/releases) [EEA Jenkins - [`c861f8204`](https://github.com/eea/helm-charts/commit/c861f8204c159d6ebb9e22b77293829a82b709fd)]

### Version 0.2.8 - 20 November 2026
- update variable description [Mihai Dobrescu - [`f865f5dad`](https://github.com/eea/helm-charts/commit/f865f5dadf52d41fce027708dae934a39c68dc21)]

### Version 0.2.7 - 20 November 2026
- Fix Matomo second site id question to set volto.environment.RAZZLE_MATOMO_SECOND_SITE_ID [Mihai Dobrescu - [`1720ff6ca`](https://github.com/eea/helm-charts/commit/1720ff6cac4ff52b2c473e5adc7c2e15587d21b7)]

### Version 0.2.6 - 19 November 2026
- Keep credentials out of the pod spec: chart-managed Secret from values, existingSecret overrides it [Mihai Dobrescu - [`36b922c86`](https://github.com/eea/helm-charts/commit/36b922c8660dc2b1665f01dbb5f4904ab9fe327b)]

### Version 0.2.5 - 19 November 2026
- Fix CORS proxy question to set RAZZLE_ALLOWED_CORS_DESTINATIONS; clarify Sentry DSN description [Mihai Dobrescu - [`65c34906f`](https://github.com/eea/helm-charts/commit/65c34906f8d1229c9d882aa267b2acc24a2293e3)]

### Version 0.2.4 - 18 November 2026
- Ingress hardening: security headers on backend ingresses, fix frontend header quoting, CSP report-only, rate limiting [Mihai Dobrescu - [`d378cacf4`](https://github.com/eea/helm-charts/commit/d378cacf4552e954884f95f2272b3c63f4dc7ae1)]

### Version 0.2.3 - 18 November 2026
- Add NetworkPolicies restricting traffic between ingress, varnish, plone and volto [Mihai Dobrescu - [`074bc1bea`](https://github.com/eea/helm-charts/commit/074bc1bea856021b76a85facaea9c16ea2d1c34e)]

### Version 0.2.2 - 18 November 2026
- Pod hardening: disable service account token automount, add non-root securityContext [Mihai Dobrescu - [`d03e96ec1`](https://github.com/eea/helm-charts/commit/d03e96ec18577d22d11ea449d1ca7b9b45942ba3)]

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


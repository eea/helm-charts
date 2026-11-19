# WaterHub backend - Plone 6

This chart deploys the Copernicus Thematic Water Hub backend (eeacms/waterhub-backend).

Deploy in the same namespace as `plone-postgres`, `waterhub-backend` and `waterhub-frontend`.

## Releases

### Version 0.2.1 - 19 November 2026
- Keep credentials out of the pod spec: chart-managed Secret from values, existingSecret overrides it [Mihai Dobrescu - [`7f59df36f`](https://github.com/eea/helm-charts/commit/7f59df36f9be50f77a29ebd00efca7683cc34e0c)]

### Version 0.2.0 - 19 November 2026
- Automated release of [eeacms/waterhub-backend:6.1.4-4](https://github.com/eea/waterhub-backend/releases) [EEA Jenkins - [`a931c5561`](https://github.com/eea/helm-charts/commit/a931c556108dc60c1360b0f1a6562d8f3ca6a70c)]

### Version 0.1.7 - 18 November 2026
- Ingress hardening: security headers on backend ingresses, fix frontend header quoting, CSP report-only, rate limiting [Mihai Dobrescu - [`fc4ea4787`](https://github.com/eea/helm-charts/commit/fc4ea478768e94fc0d6d522c5dd15ba0f0c5e75c)]

### Version 0.1.6 - 18 November 2026
- Add NetworkPolicies restricting traffic between ingress, varnish, plone and volto [Mihai Dobrescu - [`4128d2591`](https://github.com/eea/helm-charts/commit/4128d25910d33151bd959627f803759e6bd347ad)]

### Version 0.1.5 - 18 November 2026
- Pod hardening: disable service account token automount, add non-root securityContext [Mihai Dobrescu - [`542300d76`](https://github.com/eea/helm-charts/commit/542300d760aa48e69bf1a2d39827c170c003d100)]

### Version 0.1.4 - 18 November 2026
- Make links.database and links.memcached optional for same-namespace plone-postgres [Mihai Dobrescu - [`ca7ecd6b5`](https://github.com/eea/helm-charts/commit/ca7ecd6b58fe6fd0e533312fc8d0054f873191ce)]

### Version 0.1.3 - 18 November 2026
- Release eeacms/waterhub-backend:6.1.4-3; use waterhub as Plone site id, restore STATIC_BANNER_ENABLED_waterhub [Mihai Dobrescu - [`e3f1ba8e9`](https://github.com/eea/helm-charts/commit/e3f1ba8e986c81a9c854d74530c47cb84427eb18)]

### Version 0.1.2 - 16 November 2026
- Security hardening: ClusterIP-only services, /admin exposed only behind Basic Auth, remove advisory-board Google verification and Sentry Expect-CT defaults [Mihai Dobrescu - [`10daa5e4b`](https://github.com/eea/helm-charts/commit/10daa5e4be52446f9ce9fbac88ace0dedd98ea21)]

### Version 0.1.1 - 16 November 2026
- Load credentials from an existing Secret [Mihai Dobrescu - [`26d3133b4`](https://github.com/eea/helm-charts/commit/26d3133b47d5304bb58d5dae00e769e93eb7fbff)]

### Version 0.1.0 - 16 November 2026
- initial helm chart configuration [Mihai Dobrescu - [`e11a9ea39`](https://github.com/eea/helm-charts/commit/e11a9ea39b039f7c94569c27e270861dbcbcdc5f)]


# Copernicus Land Monitoring Service (CLMS) frontend - Plone 6

This chart deploys the Copernicus Land Monitoring Service (CLMS) frontend application using Volto.

## Architecture

The chart deploys a three-tier architecture:
- **Volto Frontend**: React-based frontend application
- **Varnish**: HTTP cache layer
- **Backend**: External Plone backend service

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | eeacms/clms-frontend | Container image repository |
| image.tag | string | "" | Image tag (uses Chart.appVersion if empty) |
| links.backend | string | backend-varnish.clms | Service name for backend varnish instance |
| volto.hostname | string | dev-clms.copernicus.01dev.eea.europa.eu | Hostname for the application |
| volto.replicaCount | int | 1 | Number of frontend replicas |
| volto.environment.RAZZLE_BACKEND_NAME | string | eea.docker.plone.clms | Backend identifier |
| volto.environment.DANSWER_URL | string | "" | Danswer service URL |
| volto.environment.LLMGW_URL | string | "" | LLM Gateway URL |

## Releases

### Version 3.515.0 - 29 January 2026
- Automated release of [eeacms/clms-frontend:3.515.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`35c6ecc2`](https://github.com/eea/helm-charts/commit/35c6ecc28d8e4520bc0c906d8984867a6b96d0d0)]

### Version 3.514.0 - 29 January 2026
- Automated release of [eeacms/clms-frontend:3.514.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`976b4428`](https://github.com/eea/helm-charts/commit/976b4428330fc87b6ee0244f11e94c647e5d8cbf)]

### Version 3.513.0 - 28 January 2026
- Automated release of [eeacms/clms-frontend:3.513.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`789c6b9e`](https://github.com/eea/helm-charts/commit/789c6b9e43e345dc01480919abf70de7aec22bc6)]

### Version 3.512.0 - 27 January 2026
- Automated release of [eeacms/clms-frontend:3.512.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`d20c9293`](https://github.com/eea/helm-charts/commit/d20c9293ba6d2106523d42fd825a3d7d491c8fd8)]

### Version 3.511.0 - 27 January 2026
- Automated release of [eeacms/clms-frontend:3.511.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`1d66622d`](https://github.com/eea/helm-charts/commit/1d66622dae4ddabbfcf885594d78be812b4d173c)]

### Version 3.510.0 - 22 January 2026
- Automated release of [eeacms/clms-frontend:3.510.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`e28cb4a1`](https://github.com/eea/helm-charts/commit/e28cb4a1b3036994dd2e858aace76eba5ce26fc7)]

### Version 3.509.0 - 20 January 2026
- Automated release of [eeacms/clms-frontend:3.509.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`66726238`](https://github.com/eea/helm-charts/commit/66726238a696748961a65f8f82d856535c49fe05)]

### Version 3.508.1 - 19 January 2026
- Automated release of [eeacms/plone-varnish:7.7-1.2](https://github.com/eea/plone-varnish/releases) [EEA Jenkins - [`48a3d11e`](https://github.com/eea/helm-charts/commit/48a3d11e418c65c9742887c6d61af97186cfb917)]

### Version 3.508.0 - 19 January 2026
- Automated release of [eeacms/clms-frontend:3.508.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`f41b6805`](https://github.com/eea/helm-charts/commit/f41b6805826f3b8473fb6e0d96220a8a04239eae)]

### Version 3.507.0 - 16 January 2026
- Automated release of [eeacms/clms-frontend:3.507.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`a74a00da`](https://github.com/eea/helm-charts/commit/a74a00da1426227189affa06c75e3379a7b9a99b)]

### Version 3.506.0 - 14 January 2026
- Automated release of [eeacms/clms-frontend:3.506.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`f3aea727`](https://github.com/eea/helm-charts/commit/f3aea727bd646f70a43cdce8866c9ebb35cd6af9)]

### Version 3.505.1 - 16 December 2025
- Add missing variables [Dobricean Ioan Dorian - [`40b235c7`](https://github.com/eea/helm-charts/commit/40b235c7fb4f8e191c82f3140adc60c5c05d9da9)]

### Version 3.505.0 - 16 December 2025
- Automated release of [eeacms/clms-frontend:3.505.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`c578bbc5`](https://github.com/eea/helm-charts/commit/c578bbc5716ce58c6a4116217ebedefad96981c3)]

### Version 3.504.0 - 11 December 2025
- Automated release of [eeacms/clms-frontend:3.504.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`8b4322e1`](https://github.com/eea/helm-charts/commit/8b4322e1dccc980a0b262f12ecac98f876a6e634)]

### Version 3.503.0 - 11 December 2025
- Automated release of [eeacms/clms-frontend:3.503.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`94ce75d8`](https://github.com/eea/helm-charts/commit/94ce75d8e01d11668c478f61b1228064ce6bfcd4)]

### Version 3.502.0 - 11 December 2025
- Automated release of [eeacms/clms-frontend:3.502.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`b53cdcef`](https://github.com/eea/helm-charts/commit/b53cdcef2d0fb06c111ecb8370444f331d68d4d8)]

### Version 3.501.1 - 10 December 2025
- Add nginx proxys [Dobricean Ioan Dorian - [`89341f82`](https://github.com/eea/helm-charts/commit/89341f8292cf3124d11a206e2f96c3d45411840d)]

### Version 3.501.0 - 09 December 2025
- Automated release of [eeacms/clms-frontend:3.501.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`62553b46`](https://github.com/eea/helm-charts/commit/62553b46b7f3411fceebfd15a5f96ecaf682d35f)]

### Version 3.500.3 - 08 December 2025
- remove cdse ingress [Dobricean Ioan Dorian - [`04dceae8`](https://github.com/eea/helm-charts/commit/04dceae837ed7e3b9d40651d21b4845926e99aa0)]

### Version 3.500.2 - 08 December 2025
- Move appache to ingress [Dobricean Ioan Dorian - [`578e1570`](https://github.com/eea/helm-charts/commit/578e15704b4ab5364f80a3605400b95f5e34151e)]

### Version 3.500.1 - 08 December 2025
- Add razzle public url [Dobricean Ioan Dorian - [`6ad17978`](https://github.com/eea/helm-charts/commit/6ad1797897158e5143cd05dd4a5edd78b5c8769d)]

### Version 3.500.0 - 08 December 2025
- Automated release of [eeacms/clms-frontend:3.500.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`f0bec373`](https://github.com/eea/helm-charts/commit/f0bec373f8e2f116b0d6d948cf59005fe0382bb1)]

### Version 3.499.0 - 04 December 2025
- Automated release of [eeacms/clms-frontend:3.499.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`09642962`](https://github.com/eea/helm-charts/commit/09642962f459f28039542e82206acd894db55401)]

### Version 3.498.0 - 03 December 2025
- Automated release of [eeacms/clms-frontend:3.498.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`35e932b6`](https://github.com/eea/helm-charts/commit/35e932b62440cb592df6e4ff7991e8238735a2d6)]

### Version 3.497.0 - 02 December 2025
- Automated release of [eeacms/clms-frontend:3.497.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`cfc646ee`](https://github.com/eea/helm-charts/commit/cfc646ee031e5e32de982d91a883920ed12c59fa)]

### Version 3.496.0 - 27 November 2025
- Automated release of [eeacms/clms-frontend:3.496.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`fe93eefe`](https://github.com/eea/helm-charts/commit/fe93eefe953cccd8f123416f7f9f83538937a3b7)]

### Version 3.495.1 - 26 November 2025
- FIX redirect [Dobricean Ioan Dorian - [`b2242144`](https://github.com/eea/helm-charts/commit/b2242144d7ef866704305c834d5cfc9a5e8685a4)]

### Version 3.495.0 - 26 November 2025
- Automated release of [eeacms/clms-frontend:3.495.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`cce0bf42`](https://github.com/eea/helm-charts/commit/cce0bf4271a9438214277639c4b66e3c7dd0b270)]

### Version 3.494.1 - 26 November 2025
- Remove nginx [Dobricean Ioan Dorian - [`6c53dcc6`](https://github.com/eea/helm-charts/commit/6c53dcc6e944a1aa3fa465aaf7a8e3a727d73c1b)]

### Version 3.494.0 - 25 November 2025
- Automated release of [eeacms/clms-frontend:3.494.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`61f0f799`](https://github.com/eea/helm-charts/commit/61f0f7999851dfd886e99c3f8cb05b409adcf8f2)]

### Version 3.493.1 - 24 November 2025
- Adding nginx configuration [Dobricean Ioan Dorian - [`dc8e63c1`](https://github.com/eea/helm-charts/commit/dc8e63c15d323b60c8bce1423f576348ce24b9cc)]

### Version 3.493.0
- Initial CLMS frontend Helm chart release based on insitu-frontend structure 

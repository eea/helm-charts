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

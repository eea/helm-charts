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

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

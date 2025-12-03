# Ask Copernicus - Volto frontend with chatbot

This chart deploys the Ask Copernicus application - a Volto-based frontend with integrated chatbot functionality powered by Danswer.

## Architecture

The chart deploys a three-tier architecture:
- **Volto Frontend**: React-based frontend application with chatbot integration
- **Varnish**: HTTP cache layer
- **Backend**: External Plone backend service

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | eeacms/clms-frontend | Container image repository |
| image.tag | string | 3.398.0-chatbot-0.12 | Fixed image tag for chatbot version |
| links.backend | string | backend.ask-copernicus | Service name for backend instance |
| volto.hostname | string | ask.copernicus.01dev.eea.europa.eu | Hostname for the application |
| volto.replicaCount | int | 1 | Number of frontend replicas |
| volto.environment.RAZZLE_IS_ASK_COPERNICUS | string | "1" | Flag to enable Ask Copernicus mode |
| volto.environment.DEBUG | string | superagent | Debug mode setting |
| volto.environment.DANSWER_URL | string | "" | Danswer service URL for chatbot |
| volto.environment.DANSWER_API_KEY | string | "" | Danswer API key |

## Releases

### Version 1.5.0 - 03 December 2025
- Automated release of [eeacms/clms-frontend:3.498.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`55ed4eda`](https://github.com/eea/helm-charts/commit/55ed4eda9d611711677bb6b5f0ad0a1a7371b776)]

### Version 1.4.0 - 02 December 2025
- Automated release of [eeacms/clms-frontend:3.497.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`339226f6`](https://github.com/eea/helm-charts/commit/339226f69cccde20f6254bca601a389e7e9b83a8)]

### Version 1.3.0 - 27 November 2025
- Automated release of [eeacms/clms-frontend:3.496.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`a7740654`](https://github.com/eea/helm-charts/commit/a7740654fefd5875950ab87121753cad264d3618)]

### Version 1.2.0 - 26 November 2025
- Automated release of [eeacms/clms-frontend:3.495.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`d9b53429`](https://github.com/eea/helm-charts/commit/d9b53429d06c0a9f4e78cfa040ebdb204312db24)]

### Version 1.1.0 - 25 November 2025
- Automated release of [eeacms/clms-frontend:3.494.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`374c5830`](https://github.com/eea/helm-charts/commit/374c5830a26d01e27e97f63418c97b7c13d3e65c)]

### Version 1.0.0
- Initial Ask Copernicus Helm chart release based on clms-frontend structure
- Fixed image tag: 3.398.0-chatbot-0.12
- Integrated Danswer chatbot configuration

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

### Version 1.41.0 - 25 February 2026
- Automated release of [eeacms/ask-copernicus-frontend:3.405.0](https://github.com/eea/ask-copernicus-frontend/releases) [EEA Jenkins - [`48d53ae7`](https://github.com/eea/helm-charts/commit/48d53ae7f652371459cb1aaadc851fe153390cc7)]

### Version 1.40.3 - 24 February 2026
- add variables [Dobricean Ioan Dorian - [`a208d1a4`](https://github.com/eea/helm-charts/commit/a208d1a4dc7620aab26e5a28be7987b79bd732db)]

### Version 1.40.2 - 19 January 2026
- Automated release of [eeacms/plone-varnish:7.7-1.2](https://github.com/eea/plone-varnish/releases) [EEA Jenkins - [`ef5d72a2`](https://github.com/eea/helm-charts/commit/ef5d72a2ce1071920ca66bc48ac190c9402706aa)]

### Version 1.40.1 - 09 January 2026
- fix ingress [Dobricean Ioan Dorian - [`99305bb7`](https://github.com/eea/helm-charts/commit/99305bb7e1a14ae7f64ee87af6503d45e9addce7)]

### Version 1.12.0 - 16 December 2025
- Automated release of [eeacms/clms-frontend:3.505.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`ab44ceae`](https://github.com/eea/helm-charts/commit/ab44ceae37bec7435430342b0a7399b4824285a5)]

### Version 1.11.0 - 11 December 2025
- Automated release of [eeacms/clms-frontend:3.504.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`569ee9a7`](https://github.com/eea/helm-charts/commit/569ee9a742849e581d183ec325d9f34791fcd152)]

### Version 1.10.0 - 11 December 2025
- Automated release of [eeacms/clms-frontend:3.503.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`87aa0205`](https://github.com/eea/helm-charts/commit/87aa0205a0c8bcb63abb734203a2ab096e73c2b3)]

### Version 1.9.0 - 11 December 2025
- Automated release of [eeacms/clms-frontend:3.502.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`714ea249`](https://github.com/eea/helm-charts/commit/714ea249b3b8f881ff8c3b567b28b96d7dc64e6e)]

### Version 1.8.0 - 09 December 2025
- Automated release of [eeacms/clms-frontend:3.501.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`bdd44474`](https://github.com/eea/helm-charts/commit/bdd444746c75c5970b0dc2e68b6268fbe60f927b)]

### Version 1.7.0 - 08 December 2025
- Automated release of [eeacms/clms-frontend:3.500.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`7d3786fe`](https://github.com/eea/helm-charts/commit/7d3786fedf3fa0271650e28cdd2be377636db96c)]

### Version 1.6.0 - 04 December 2025
- Automated release of [eeacms/clms-frontend:3.499.0](https://github.com/eea/clms-frontend/releases) [EEA Jenkins - [`2d0fe53b`](https://github.com/eea/helm-charts/commit/2d0fe53bf190235ad7650c2d11e12a39605324a3)]

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

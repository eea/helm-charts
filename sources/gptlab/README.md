# GPTLab Helm Chart

This Helm chart deploys GPTLab, an AI-powered question-answering system based on the Danswer platform with EEA customizations.

## Overview

GPTLab provides an intuitive interface for users to ask questions and receive AI-generated answers backed by verified sources. The system combines semantic search with generative AI to create a powerful knowledge retrieval system.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- Ingress controller (such as NGINX)

## Installation

### Add the Helm Repository

```bash
helm repo add eea https://eea.github.io/helm-charts
helm repo update
```

### Install the Chart

```bash
# Install with default values
helm install gptlab eea/gptlab

# Install with custom values file
helm install gptlab eea/gptlab -f values.yaml
```

## Architecture

This chart deploys a complete GPTLab stack with the following components:

- API Server - Core backend API service
- Web Server - User interface frontend
- Background Worker - Handles asynchronous tasks
- Index Server (Vespa) - Search engine and vector database
- Model Server - Inference services for embedding and reranking
- PostgreSQL Database - Stores application data
- Redis - Caching and message queue
- Postfix - Email service for notifications

## Configuration


### Authentication

The chart supports various authentication methods:

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `auth.authType` | Authentication type (disabled, basic, google-oauth) | `disabled` |
| `auth.requireEmailVerification` | Whether to require email verification | `""` |
| `auth.validEmailDomains` | Allowed email domains for registration | `""` |
| `auth.emailFrom` | Email sender address | `""` |

### AI Model Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `genAI.modelProvider` | AI service provider | `openai` |
| `genAI.modelVersion` | Main AI model | `togethercomputer/llama-2-70b-chat` |
| `genAI.apiKey` | API key for the model provider | `""` |
| `genAI.apiEndpoint` | Custom API endpoint URL | `https://api.together.xyz/v1` |

### Storage

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `storage.localDynamicStorage.size` | Size for local dynamic storage | `5Gi` |
| `storage.vespaVolume.size` | Size for Vespa search engine data | `5Gi` |
| `storage.modelCacheHuggingface.size` | Size for model cache storage | `5Gi` |

### Database Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `postgresql.deploy` | Whether to deploy PostgreSQL | `true` |
| `postgresql.auth.username` | PostgreSQL username | `postgres` |
| `postgresql.auth.password` | PostgreSQL password | `password` |
| `postgresql.auth.database` | PostgreSQL database name | `postgres` |

### Service Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `services.apiServer.replicas` | Number of API server replicas | `1` |
| `services.background.replicas` | Number of background worker replicas | `1` |
| `services.webServer.replicas` | Number of web server replicas | `1` |

### Ingress Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ingress.enabled` | Enable ingress resource | `true` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.hosts[0].host` | Hostname for the application | `""` |

## Accessing the Application

After installation, you can access the application at the configured hostname. If no hostname is provided, you can port-forward the web server service:

```bash
kubectl port-forward svc/gptlab-web-server 3000:3000
```

Then access the application at: http://localhost:3000

## Email Configuration

GPTLab uses Postfix for email delivery. For development environments, you can enable the mail viewer interface:

```yaml
postfix:
  dryrun: true
  mailtrap:
    httpenabled: true
```

## Monitoring and Observability

The chart supports integration with Langfuse for observability:

```yaml
langfuse:
  host: "https://langfuse.yourdomain.com"
  publicKey: "your-public-key"
  secretKey: "your-secret-key"
```

## Uninstallation

To uninstall the chart:

```bash
helm uninstall gptlab
```

## Upgrading

To upgrade to the latest version:

```bash
helm repo update
helm upgrade gptlab eea/gptlab
```

## Releases

### Version 0.1.10
- Updated appVersion to v0.29.1-eea.0.0.57

### Version 0.1.9
- Updated appVersion to v0.29.1-eea.0.0.54

### Version 0.1.8
- Removed development services.

### Version 0.1.7
- Allow finer grain control for API service

### Version 0.1.6
- Allow finer grain control for web service

### Version 0.1.5
- Added missing description in `questions.yaml`.

### Version 0.1.4
- Fixed ingress enabled type in `questions.yaml`.

### Version 0.1.3
- Removed snippet from questions as it was causing issues with Ingress.

### Version 0.1.2
- questions.yaml tweaks.

### Version 0.1.1
- Updated `questions.yaml` to fix Ingress issues.

### Version 0.1.0
- Initial release.

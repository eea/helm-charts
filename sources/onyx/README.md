# Onyx Helm Chart for GPTLab

This Helm chart deploys onyx, an AI-powered question-answering system based on the Danswer platform with EEA customizations.
This chart is derived from the official onyx helm chart(`https://github.com/onyx-dot-app/onyx`) customized for EEA.

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
helm install onyx eea/onyx

# Install with custom values file
helm install onyx eea/onyx -f values.yaml
```

### Customizations in This Chart

1. **Unified Ingress Template**
   - EEA's onyx chart uses a single `ingress.yaml` template that supports multiple hosts and paths, allowing flexible routing for API, webserver, and other services.

2. **Nginx and Let’s Encrypt Removed**
   - The official onyx chart includes Nginx as a dependency and provides templates for Nginx configuration (`nginx-conf.yaml`) and Let’s Encrypt (`lets-encrypt.yaml`).
   - EEA's onyx chart, Nginx and Let’s Encrypt are not included as dependencies and are not used by default.

3. **Dependency Changes**
   - EEA's onyx chart removes Nginx from the dependencies and adds Postfix as a dependency.

4. **Default Values Adjusted**
   - EEA's onyx chart’s `values.yaml` is tailored for EEA environment, with different defaults for images, resources, and service settings.
   - EEA's onyx chart uses `eeacms/danswer` images or other custom images.

5. **Postfix Integration**
   - The derived chart adds Postfix as a dependency and includes configuration for mail relay and mailtrap, which is not present in the upstream chart.

6. **Chart Metadata**
   - The derived chart may have different `description`, `keywords`, and other metadata in `Chart.yaml` to reflect its forked/derived status.

## Dynamic Image Mapping and Tag Replacement Logic

This chart supports dynamic mapping of image repositories and tag construction, allowing you to seamlessly switch between upstream (`onyxdotapp/onyx-*`) and EEA (`eeacms/danswer`) images with minimal configuration and no template changes.

### How It Works

- The chart uses a helper function to map image repositories and construct tags for container images.
- **Mapping is only triggered if the image repository in your values matches the mapping key exactly** (e.g., `onyxdotapp/onyx-web-server`).
  If you set the repository directly to `eeacms/danswer`, mapping will NOT be triggered and the tagSuffix will NOT be included.
- If `.Values.imageMapping.enabled` is `true` and a mapping is defined for a given image repository, the chart will use the mapped repository and construct the tag as follows:
  - If a tag is provided in values (e.g., `.Values.webserver.image.tag`), it will be used as the version part of the tag:
    `<repo>:<tagSuffix>-<tag>`
  - If no tag is provided, the chart's `appVersion` will be used as the version part of the tag:
    `<repo>:<tagSuffix>-v<appVersion>`
  - If neither is set (very rare), the fallback will be:
    `<repo>:<tagSuffix>-latest`
- If the image repository does not match a mapping key, the helper falls back to the standard Helm logic and uses the repository and tag as provided (no tagSuffix).

#### Example

Suppose your `values.yaml` includes:

```yaml
imageMapping:
  enabled: true
  replacements:
    onyxdotapp/onyx-web-server:
      repo: eeacms/danswer
      tagSuffix: web
    onyxdotapp/onyx-backend:
      repo: eeacms/danswer
      tagSuffix: backend
```

- If you set:
  ```yaml
  webserver:
    image:
      repository: onyxdotapp/onyx-web-server
      tag: customtag
  ```
  the resulting image will be:
  `eeacms/danswer:web-customtag`

- If you do not set `webserver.image.tag`, and your `Chart.yaml` has `appVersion: v1.3.1-eea.0.0.70`, the resulting image will be:
  `eeacms/danswer:web-v1.3.1-eea.0.0.70`

- If you set:
  ```yaml
  webserver:
    image:
      repository: eeacms/danswer
      tag: ""
  ```
  the mapping will NOT be triggered and the resulting image will be:
  `eeacms/danswer:v1.3.1-eea.0.0.70` (no tagSuffix)

**To ensure mapping and tagSuffix work as intended, always use the upstream image repository names in your values files.**

---

## Releases

### Version 0.1.3
- Added ENABLED_EMAIL_INVITES env variable and missing TZ.

### Version 0.1.2
- Added APP_VERSION and TZ env variables in configmap.

### Version 0.1.1
- Image helper fixes.

### Version 0.1.0
- Initial release. Upstream chart version 0.2.3

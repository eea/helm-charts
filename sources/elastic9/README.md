# Elastic 9

Helm chart for running an Elasticsearch 9 cluster with:
- Elasticsearch master and data nodes
- Kibana (optional)
- Cerebro (optional)
- Optional ingress for Kibana and Elasticsearch data service

## Install

```bash
helm install elastic9 ./elastic9
```

## Upgrade

```bash
helm upgrade elastic9 ./elastic9
```

## Main configuration

- `image.repository` and `image.tag` for Elasticsearch image (`eeacms/elastic:9` by default)
- `esmaster.replicaCount` for master nodes
- `esworker.replicaCount` for data nodes
- `esmaster.password` to enable Elasticsearch security
- `kibana.enabled` and `kibana.image` for Kibana (`eeacms/elk-kibana:9` by default)
- `kibana.ingress.*` for Kibana ingress
- `esworker.ingress.*` for Elasticsearch ingress

## Example

```bash
helm install elastic9 ./elastic9 \
  --set esmaster.replicaCount=3 \
  --set esworker.replicaCount=3 \
  --set kibana.ingress.enabled=true \
  --set kibana.ingress.hostname=kibana.example.com
```

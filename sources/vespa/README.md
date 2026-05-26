# vespa-helm-charts
Forked from https://github.com/unoplat/vespa-helm-charts.

This will house vespa helm charts.

# Current Progress

## Single Node charts

### Installation 
```
helm repo add vespa https://onyx-dot-app.github.io/vespa-helm-charts
helm repo update
helm install onyx-vespa vespa/vespa
```

# Changelog

https://github.com/onyx-dot-app/vespa-helm-charts/blob/main/charts/vespa/CHANGELOG.md 

## Releases

### Version 0.2.27 - 26 May 2026
- fix: vespa security context, tmpfs volume, and pod labels for NFS compatibility [Silviu - [`e30ec6cd`](https://github.com/eea/helm-charts/commit/e30ec6cd)]

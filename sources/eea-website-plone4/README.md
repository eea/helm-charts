# EEA Website Plone 4

A Helm chart for deploying EEA Main Website Plone 4 Backend on Kubernetes.

## Description

This chart deploys a simplified Plone 4 installation for internal use, migrated from Rancher 1 (eea.rancher.catalog) to Rancher 2/Kubernetes.

## Components

- **Plone** - Single Zope/Plone instance (eeacms/www:23.9.14)
- **PostgreSQL** - Database backend (eeacms/postgres:10.23-4.2 via plone-postgres subchart)
- **Memcached** - Caching layer (included in plone-postgres subchart)
- **Postfix** - Mail relay (optional)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for persistent volumes)

## Installation

```bash
# Add EEA repo for dependencies
helm repo add eea https://eea.github.io/helm-charts

# Update dependencies
helm dependency update sources/eea-website-plone4

# Install the chart
helm install my-plone4 sources/eea-website-plone4 \
  --set plone.hostname=plone4.example.com \
  --set postgres.postgres.env.Database.Password=secretpassword
```

## Configuration

### Key Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `plone.hostname` | Server hostname | `plone4-internal.eea.europa.eu` |
| `plone.replicaCount` | Number of Plone replicas | `1` |
| `plone.resources.limits.memory` | Memory limit | `10Gi` |
| `postgres.postgres.env.Database.UserName` | Database user | `zope` |
| `postgres.postgres.env.Database.Password` | Database password | `zope` |
| `postgres.postgres.env.Database.Name` | Database names (space-separated) | `datafs zasync` |
| `postgres.memcached.enabled` | Enable memcached | `true` |
| `postgres.memcached.cache_size_m` | Cache size in MB | `1024` |
| `postgres.datastorage.size` | PostgreSQL storage size | `150Gi` |
| `ingress.enabled` | Enable ingress | `true` |
| `debug.enabled` | Enable debug instance | `false` |

### Persistent Volumes

The chart creates 4 PVCs:
- `blobstorage` - 100Gi (Plone blob storage)
- `downloads` - 50Gi (Generated downloads)
- `suggestions` - 10Gi (Search suggestions)
- `staticResources` - 10Gi (Static resources)

All volumes use `ReadWriteMany` access mode by default.

## Upgrading

```bash
helm upgrade my-plone4 sources/eea-website-plone4
```

## Uninstallation

```bash
helm uninstall my-plone4
```

Note: PVCs are not deleted automatically. Remove them manually if needed:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=my-plone4
```

## Source

Migrated from:
- `eea.rancher.catalog/templates/www-plone`
- `eea.rancher.catalog/templates/www-postgres`
- `eea.rancher.catalog/templates/www-frontend`

## License

GPLv3

## Releases

- 1.0.0 - Initial release (migrated from Rancher 1)

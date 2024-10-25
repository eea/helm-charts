# Reportnet Zeoserver

Zeoserver is the Zope server for Reportek

[See more](https://github.com/eea/eea.docker.reportek.zeoserver)

## Configuration

- `timezone` - Time zone.
- `storage` - Size of the persistent volume claim.
- `storageName` - Name of the persistent volume claim.

## Releases

### Version 0.1.5
- Added initContainer to create storage directories.

### Version 0.1.4
- fsGroup is a pod level security context. Moved it to podSecurityContext.

### Version 0.1.3
- Added default fsgroup to security context.

### Version 0.1.2
- Moved startup, liveness, readiness probes into values

### Version 0.1.1
- Some refactoring done and added component labels.

### Version 0.1.0
- Initial release.

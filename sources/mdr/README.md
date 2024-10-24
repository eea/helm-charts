# Reportnet MDR

The Mediterranean Data Repository is part of the Reportnet architecture. The Mediterranean Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Values

<dl>

  <dt>rabbitmq</dt>
  <dd>This can be used to set the rabbitmq host to be used.</dd>.</dd>

</dl>

## Releases

### Version 0.2.3
- Added additional ingress configuration options in questions.yaml.

### Version 0.2.2
- Added zeoserver storageName to questions.yaml.

### Version 0.2.1
- Added questions.yaml.

### Version 0.2.0
- Updated rn-zeoserver chart to 0.1.2.

### Version 0.1.5
- Fixed instance deployment name.

### Version 0.1.4
- Fixed liveness and readiness probes in deployment.

### Version 0.1.3
- Updated readme.
- Moved liveness probes out of the deployment.

### Version 0.1.2
- Refactoring and cleanup.
- Updated rn-varnish chart to 0.1.4.
- Updated rn-local-converters chart to 0.1.2.
- Updated rn-clamav chart to 0.1.2.
- Updated ingress

### Version 0.1.1
- Removed deployment referrence from README.

### Version 0.1.0
- Initial release.

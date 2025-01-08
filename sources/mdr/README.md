# Reportnet MDR

The Mediterranean Data Repository is part of the Reportnet architecture. The Mediterranean Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Values

<dl>

  <dt>rabbitmq</dt>
  <dd>This can be used to set the rabbitmq host to be used.</dd>.</dd>

</dl>

## Releases

### Version 0.3.10
- Updated appVersion to 3.9.1-215.

### Version 0.3.9
- Updated appVersion to 3.9.1-214.

### Version 0.3.8
- Updated appVersion to 3.9.1-213.

### Version 0.3.7
- Updated rn-zeoserver chart to 0.1.6.

### Version 0.3.6
- Updated appVersion to 3.9.1-212.

### Version 0.3.5
- Updated appVersion to 3.9.1-211.

### Version 0.3.4
- Updated appVersion to 3.9.1-210.

### Version 0.3.3
- Updated appVersion to 3.9.1-209.

### Version 0.3.2
- Added additional sentry related env variables
- Single quoted env variables in instance deployment

### Version 0.3.1
- Updated rn-local-converters

### Version 0.3.0
- Added webforms support.
- Fixed zeopack values.

### Version 0.2.12
- Updated rn-varnish chart to 0.1.5.

### Version 0.2.11
- Updated appVersion to 3.9.1-207.

### Version 0.2.10
- Added sentryDSN variable in questions.yaml.

### Version 0.2.9
- Added zeoAddress variable in questionstions.yaml and relabeled ingress backend service name.

### Version 0.2.8
- Added varnish backend and port in questions.yaml.

### Version 0.2.7
- Updated rn-zeoserver chart to 0.1.5.

### Version 0.2.6
- Updated rn-zeoserver chart to 0.1.4.

### Version 0.2.5
- Updated rn-zeoserver chart to 0.1.3.

### Version 0.2.4
- Fixed default serviceName in ingress configuration in questions.yaml.

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

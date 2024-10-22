# Reportnet CDR

The Central Data Repository is part of the Reportnet architecture. The Central Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Values

- **rabbitmq**: This can be used to set the rabbitmq host to be used.

## Releases

### Version 0.1.9
- Fixed liveness probe and readiness probe in deployment.

### Version 0.1.8
- Updated readme.
- Moved liveness probes out of the deployment.

### Version 0.1.7
- Refactoring and cleanup.
- Updated rn-varnish chart to 0.1.4.
- Updated rn-local-converters chart to 0.1.2.
- Updated rn-clamav chart to 0.1.2.
- Updated ingress.

### Version 0.1.6
- Refactored to be able to install multiple stacks in the same namespace. Due to the chart naming, we can't solely rely on appl.fullname for service naming.
- Dropped deployment since it's not needed, we can use RELEASE instead.
- Removed storage PVC since it's not needed.

### Version 0.1.5
- Added rabbitmq.create and rabbitmq.name. When create is true, the rabbitmq service will be created.

### Version 0.1.4
- Get the image and tag from image section.

### Version 0.1.3
- Changed rabbitmq to externalName.

### Version 0.1.2
- Updated rn-varnish chart to 0.1.3 and fix ingress path.

### Version 0.1.1
- Updated rn-varnish chart to 0.1.2.

### Version 0.1.0
- Initial release.

# Reportnet CDR

The Central Data Repository is part of the Reportnet architecture. The Central Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Values

- **rabbitmq**: This can be used to set the rabbitmq host to be used.

## Releases

### Version 0.3.15
- Added cronjob for auto cleanup.

### Version 0.3.14
- Updated appVersion to 6.7.3-199.

### Version 0.3.13
- Updated appVersion to 6.7.3-198.

### Version 0.3.12
- Updated appVersion to 6.7.3-197.

### Version 0.3.11
- Updated appVersion to 6.7.3-196.

### Version 0.3.10
- Updated appVersion to 6.7.3-195.

### Version 0.3.9
- Added computed sentry release

### Version 0.3.8
- Added sentrySite and sentryEnvironment variables.

### Version 0.3.7
- Conditionally create and mount zip_cache pvc/pv if zipCacheEnabled is true.

### Version 0.3.6
- Updated rn-clamav and rn-local-converters

### Version 0.3.5
- Converted template values to use single quotes to handle special characters.

### Version 0.3.4
- Removed repository and tag from instance in values.yaml.

### Version 0.3.3
- Added missing env variables for cronautofallin.

### Version 0.3.2
- Fixed values mix-up.

### Version 0.3.1
- Fixed the webforms related questions.

### Version 0.3.0
- Added webforms to the list of services.

### Version 0.2.15
- Updated rn-clamav chart to 0.1.3.
- Updated rn-varnish chart to 0.1.5.

### Version 0.2.14
- Updated appVersion to 6.7.3-194.

### Version 0.2.13
- questions.yaml updates.

### Version 0.2.12
- More updates to the questions.yaml related to ingress.

### Version 0.2.11
- Updated questions.yaml for ingress.

### Version 0.2.10
- Fixed SSRF on Converters/run_conversion.

### Version 0.2.9
- Added nginx server snippet to ingress to prevent SSRF on Converters/run_conversion.

### Version 0.2.8
- Added sentryDSN to questions.yaml.

### Version 0.2.7
- Added zeoAddress to questions.yaml and re-labeled ingress backend service name.

### Version 0.2.6
- Added varnish backend configuration in questions.yaml.

### Version 0.2.5
- Updated rn-zeoserver chart to 0.1.5.

### Version 0.2.4
- Added additional ingress configuration options in questions.yaml.

### Version 0.2.3
- More reorganization of questions.yaml.

### Version 0.2.2
- Reorganized questions.yaml and added more questions.

### Version 0.2.1
- Added questions.yaml.

### Version 0.2.0
- Updated rn-zeoserver chart to 0.1.2.

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

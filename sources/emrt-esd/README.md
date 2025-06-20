# Emission Review Tool - Effort Sharing Decision

The EMRT(EEA Emission Review Tool) is a web-based tool hosted by the EEA to facilitate quality checks and reviews of national emission inventories reported by EU Member States.

## Releases

### Version 1.3.5
- Updated app version to 18.1.23-1-1.77.4

### Version 1.3.4
- Add extra timeouts to varnish config.

### Version 1.3.3
- Fix varnish config.

### Version 1.3.2
- Fix yaml indent.

### Version 1.3.1
- Fix yaml errors.

### Version 1.3.0
- Use the official varnish docker image. Add ConfigMap for varnish.vcl. Increase backend timeout.

### Version 1.2.10
- Configurable health check for plone.

### Version 1.2.9
- Updated app version to 18.1.23-1-1.77.3

### Version 1.2.8
- Updated app version to 18.1.23-1-1.77.2

### Version 1.2.7
- Updated app version to 18.1.23-1-1.77.1

### Version 1.2.6
- Updated app version to 18.1.23-1-1.77.0

### Version 1.2.5
- Ingress: rewrite-target -> configuration-snippet.

### Version 1.2.4
- Updated app version to 18.1.23-1-1.76.3.

### Version 1.2.3
- Updated app version to 18.1.23-1-1.76.2.

### Version 1.2.2
- Updated app version to 18.1.23-1-1.76.1.

### Version 1.2.1
- Implementing increase of nginx.ingress.kubernetes.io/proxy-body-size [andreicenja]

### Version 1.2.0
- Updated app version to 18.1.23-1-1.76.0.

### Version 1.1.1
- Updated app version to 18.1.23-1-1.75.2.

### Version 1.1.0
- Updated app version to 18.1.23-1-1.75.1.

### Version 1.0.0 - 27/11-2024
- Upgraded postfix to 3.0.3

### Version 0.2.7 - 05/9-2024
- Upgraded memcached to 7.4.13, upgraded postfix to 2.0.1.

### Version 0.2.6
- Updated app version to 18.1.23-1-1.74.6.

### Version 0.2.5 - 20/6-2024
- Upgraded memcached chart to 7.4.7, upgraded postfix chart to 1.1.0.

### Version 0.2.4
- Change Plone to rolling update.

### Version 0.2.3
- Updated app version to 18.1.23-1-1.74.5.

### Version 0.2.2
- Added health checks to plone.

### Version 0.2.1
- Updated app version to 18.1.23-1-1.74.4.

### Version 0.2.0
- Removed the haproxy, as Kubernetes does loadbalancing via a ClusterIP.  Added autoscaling option.

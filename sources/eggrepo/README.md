EEA Eggrepo
===========

For deployment into production set:

    ingress:
      enabled: true

## Chart releases

- 0.1.0 Direct migration from docker-compose.yml
- 0.2.0 Use ProxyPreserveHost instead of ProxyPassReverse
- 0.2.1 Fix problem where X-Forwarded-Host has two values because there are two reverse proxies in front of it.

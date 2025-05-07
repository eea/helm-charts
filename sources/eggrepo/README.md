EEA Eggrepo
===========

For deployment into production set:

    ingress:
      enabled: true

## Releases

### Version 0.4.1 - 07 May 2025
- Rename services, refactor headers [valentinab25 - [`dda5609`](https://github.com/eea/helm-charts/commit/dda56092bd07419835391f4246c0db3215e8008c)]

### Version 0.4.0 - 26 March 2025
- fix apache configuration, refactor [valentinab25 - [`188ca9f`](https://github.com/eea/helm-charts/commit/188ca9f51e8cf402d6b68f1c450bc4b164185fd6)]

### Version 0.2.1
- 0.2.1 Fix problem where X-Forwarded-Host has two values because there are two reverse proxies in front of it.


### Version 0.2.0
- Use ProxyPreserveHost instead of ProxyPassReverse

### Version 0.1.0
-  Direct migration from docker-compose.yml


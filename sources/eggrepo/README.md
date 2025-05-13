EEA Eggrepo
===========

For deployment into production set:

    ingress:
      enabled: true

## Releases

### Version 0.4.6 - 12 May 2025
- Add trailing slash to /simple [valentinab25 - [`ffaacf3`](https://github.com/eea/helm-charts/commit/ffaacf3574f23bec0c0fc3238efb4afbfffd2d09)]

### Version 0.4.5 - 12 May 2025
- Add redirect to from /d/REPO to /d/REPO/ [valentinab25 - [`aba1966`](https://github.com/eea/helm-charts/commit/aba1966178992e6d3cf4af9871f2f0faccbafa64)]

### Version 0.4.4 - 12 May 2025
- Added new ingress configuration vars [valentinab25 - [`7105349`](https://github.com/eea/helm-charts/commit/710534985707f26efb855caf5f1e1133e84ac60e)]

### Version 0.4.3 - 08 May 2025
- Fix statefulset servicename [valentinab25 - [`8a8ff1b`](https://github.com/eea/helm-charts/commit/8a8ff1b6444ea7fa7deff634b1af57de5390ae3d)]

### Version 0.4.2 - 07 May 2025
- Refactor values, names, questions [valentinab25 - [`dc81826`](https://github.com/eea/helm-charts/commit/dc81826950d54d1787932274301be18e308e691d)]

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


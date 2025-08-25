# PloneSAAS

This chart deployes the PloneSaaS app together with several frontends as Ingress objects.


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| externalBackend.enabled | bool | true | Use the external backend specified in externalBackend.name. If false then connect the clients to the ploneSaaS backend in same namespace |
| plonesaas.enabled | bool | false | Create the ploneSaaS backend |
| ldapdump.enabled | bool | false | Activate extraction of LDAP account on a periodic basis |
| circularity.enabled | bool | false | Activate the circularity Ingress |
| climateEnergy.enabled | bool | false | Activate the climateEnergy Ingress |
| debug.enabled | bool | false | Activate the Plone debug instance |
| epanet.enabled | bool | false | Activate the epanet Ingress |
| forest.enabled | bool | false | Activate the forest Ingress |
| ias.enabled | bool | false | Activate the ias Ingress |
| industry.enabled | bool | false | Activate the industry Ingress |

## Releases

### Version 2.6.1 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`aaeed463`](https://github.com/eea/helm-charts/commit/aaeed4631223442f3d8e28377cdfc3d81b639b8c)]

### Version 2.6.0 - 03 June 2025
- Automated release of [eeacms/plonesaas:5.2.13-33](https://github.com/eea/eea.docker.plonesaas/releases) [EEA Jenkins - [`18e8147`](https://github.com/eea/helm-charts/commit/18e814700272c7102507b150fdb316e7bf865857)]

### Version 2.5.0 - 28 May 2025
- Automated release of [eeacms/plonesaas:5.2.13-32](https://github.com/eea/eea.docker.plonesaas/releases) [EEA Jenkins - [`38ae67f`](https://github.com/eea/helm-charts/commit/38ae67fe5778fd91d9dea985fb666c1e7bdec542)]

### Version 2.4.7 - 14 April 2025
- Fixed redirect on circularity [valentinab25 - [`89378da`](https://github.com/eea/helm-charts/commit/89378da922adbea1e5dbaa729bb729510308274f)]

### Version 2.4.6 - 11 April 2025
- Fix industry rewrite on api ingress [valentinab25 - [`b3c2605`](https://github.com/eea/helm-charts/commit/b3c2605fb1aca5e91d8ab58ca83ac2549963830b)]


### Version 2.4.5 - 29 August 2024
- Updated industry deployment image from eeacms/industry-frontend:3.25.0 to eeacms/industry-frontend:3.29.0
- Added `nginx.ingress.kubernetes.io/proxy-body-size: 100m` to `climate-energy-api-ingress.yaml` and `industry-api.ingress.yaml`, refs #279315

### Version 2.4.4 - 29 August 2024
- Added "forests" redirection. Activated with forest.enabled.

### Version 2.4.3 - 29 August 2024
- Added the forest frontend. Made it possible to deactivate the debug instance. Both disabled by default.

### Version 2.4.2 - 16 August 2024
  <dd>Implement autoscaling for plone pods.
  Increase the timeout for plone startup to 900 seconds.
  Remove the default `nginx.ingress.kubernetes.io/proxy-body-size: 100m` from Ingress annotations.</dd>

### Version 2.4.1 - 15 August 2024
- Fix issue with /++api++/ path. The pluses were parsed with regex.

### Version 2.4.0
- Initial release. Version matching Rancher 1 catalog version.


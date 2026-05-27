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
| ias.enabled | bool | false | Activate the ias Ingress |

## Releases

### Version 2.9.0 - 27 May 2026
- Automated release of [eeacms/plonesaas:5.2.13-36](https://github.com/eea/eea.docker.plonesaas/releases) [EEA Jenkins - [`203759f8`](https://github.com/eea/helm-charts/commit/203759f84479dd8d561fe44d9bcae01c4ace8ddd)]

### Version 2.8.0 - 21 May 2026
- Automated release of [eeacms/plonesaas:5.2.13-35](https://github.com/eea/eea.docker.plonesaas/releases) [EEA Jenkins - [`2713f259`](https://github.com/eea/helm-charts/commit/2713f2593d753334565a38476048db2742107c1f)]

### Version 2.7.0 - 19 May 2026
- Automated release of [eeacms/plonesaas:5.2.13-34](https://github.com/eea/eea.docker.plonesaas/releases) [EEA Jenkins - [`bd7fe5c2`](https://github.com/eea/helm-charts/commit/bd7fe5c2d662f7834fd94556e8b77d54eb75324b)]

### Version 2.6.4 - 04 May 2026
- Use HTTP probes for Varnish and climate-energy frontend health checks.

### Version 2.6.3 - 18 December 2025
- Release of dependent chart postfix:3.2.0 [EEA Jenkins - [`7bbb52a3`](https://github.com/eea/helm-charts/commit/7bbb52a37b36858206b0e83e0be340c4efed1f40)]

### Version 2.6.2 - 12 December 2025
- Remove industry from plonesaas [Dobricean Ioan Dorian - [`939e48ef`](https://github.com/eea/helm-charts/commit/939e48efb8aebe4f1d3f7f5a97d3cc23620602b8)]

### Version 2.6.1 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`aaeed463`](https://github.com/eea/helm-charts/commit/aaeed4631223442f3d8e28377cdfc3d81b639b8c)]

### Version 2.6.0 - 03 June 2025
- Automated release of [eeacms/plonesaas:5.2.13-33](https://github.com/eea/eea.docker.plonesaas/releases) [EEA Jenkins - [`18e8147`](https://github.com/eea/helm-charts/commit/18e814700272c7102507b150fdb316e7bf865857)]

### Version 2.5.0 - 28 May 2025
- Automated release of [eeacms/plonesaas:5.2.13-32](https://github.com/eea/eea.docker.plonesaas/releases) [EEA Jenkins - [`38ae67f`](https://github.com/eea/helm-charts/commit/38ae67fe5778fd91d9dea985fb666c1e7bdec542)]

### Version 2.4.7 - 14 April 2025
- Fixed redirect on circularity [valentinab25 - [`89378da`](https://github.com/eea/helm-charts/commit/89378da922adbea1e5dbaa729bb729510308274f)]

### Version 2.4.6 - 11 April 2025


### Version 2.4.5 - 29 August 2024
- Added `nginx.ingress.kubernetes.io/proxy-body-size: 100m` to `climate-energy-api-ingress.yaml`, refs #279315

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

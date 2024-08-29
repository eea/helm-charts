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

<dl>
  <dt>Version 2.4.4 - 29 August 2024</dt>
  <dd>Added "forests" redirection. Activated with forest.enabled.</dd>

  <dt>Version 2.4.3 - 29 August 2024</dt>
  <dd>Added the forest frontend. Made it possible to deactivate the debug instance. Both disabled by default.</dd>

  <dt>Version 2.4.2 - 16 August 2024</dt>
  <dd>Implement autoscaling for plone pods.
  Increase the timeout for plone startup to 900 seconds.
  Remove the default `nginx.ingress.kubernetes.io/proxy-body-size: 100m` from Ingress annotations.</dd>

  <dt>Version 2.4.1 - 15 August 2024</dt>
  <dd>Fix issue with /++api++/ path. The pluses were parsed with regex.</dd>

  <dt>Version 2.4.0</dt>
  <dd>Initial release. Version matching Rancher 1 catalog version.</dd>
</dl> 

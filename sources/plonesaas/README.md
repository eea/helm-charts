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
| epanet.enabled | bool | false | Activate the epanet Ingress |
| ias.enabled | bool | false | Activate the ias Ingress |
| industry.enabled | bool | false | Activate the industry Ingress |

## Releases

<dl>
  <dt>Version 0.1.0</dt>
  <dd>Initial release.</dd>
</dl> 

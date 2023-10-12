# Content Registry

This chart is configured for production use.


| Property      | Description |
| ------------- |-------------|
| dbapw | The password for the Virtuoso database administrator. Used only be virtuoso. |
| virtuosoDbUsr | Account for the application to update the database |
| virtuosoDbPwd | Password for the application to update the database |
| virtuosoDbRousr | Account for the application to have readonly access to the database |
| virtuosoDbRopwd | Account for the application to have readonly access to the database |
| ldapPassword | Password for querying accounts in Eionet LDAP |


## Releases

<dl>

  <dt>Version 1.0.0 (future)</dt>
  <dd>First version to be used in production.</dd> 

  <dt>Version 0.2.5</dt>
  <dd>Envrionmental variables as strings for helm numeric values.</dd>

  <dt>Version 0.2.4</dt>
  <dd>String variable values fix.</dd>
  
  <dt>Version 0.2.3</dt>
  <dd>Placeholders and updated values for environmental variables.</dd>

  <dt>Version 0.2.2</dt>
  <dd>Make virtuoso health checks optional.</dd>

  <dt>Version 0.2.1</dt>
  <dd>Set timeout of livenessProbe to 10 seconds. Remove readinessProbe.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Add use of EEA template.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


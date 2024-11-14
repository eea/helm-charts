# Reporting Obligation Database

This chart is configured for production use.

## Values

<dl>
  <dt>deployContexts</dt>
  <dd>If set to `uat`, then the deployment will fill the database with sample data. Must be set to `prod` in production.</dd>

  <dt>initialuser</dt>
  <dd>If set, then this username is added to the permissions table as administrator.</dd>
  <dt>ldapPassword</dt>
  <dd>Contains the password needed to run queries on the ldap service for group memberships.</dd>

  <dt>ldapPrincipal</dt>
  <dd>Probably not implemented.</dd>

  <dt>ldapUrl</dt>
  <dd>Probably not implemented.</dd>

</dl>

## Releases

<dl>

  <dt>Version 0.2.2</dt>
  <dd>SQL injection fixes, libraries updates, newer tomcat image.</dd>

  <dt>Version 0.2.1</dt>
  <dd>Use names for network security policies that allow other apps to have the same.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Added network security policies</dd>

  <dt>Version 0.1.7</dt>
  <dd>Added smoke test for database.</dd>

  <dt>Version 0.1.6</dt>
  <dd>Updated documentation.</dd>

  <dt>Version 0.1.5</dt>
  <dd>Typo in deployContexts variable.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


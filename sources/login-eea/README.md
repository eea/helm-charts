# EEA Login service

Configured for EEA use only. Depends on the TLS certificate to be in the Secret star-eea-europa-eu.

## Configuration

| Key | Description | Default |
| --- | ----------- | ------- |
| `adminUser` | Keycloak administrator |"" |
| `adminPassword` | Administrator password |"" |
| `logLevel` | Sets the log level for the JBoss Logging framework |"" |
| `serviceName` | The hostname of the service | login.eea.europa.eu |
| `haproxy.enabled` | Creates a frontend that restricts the admin pages | true |
| `postgresql.auth.password` | Password for the custom user to create |"" |
| `postgresql.auth.enablePostgresUser` | Flag to create postgres admin user |true |
| `postgresql.auth.postgresPassword` | Password for the "postgres" admin user |"" |
| `postgresql.auth.database` | Name for a custom database to create |keycloak |
| `postgresql.auth.username` | Name for a custom user to create |keycloak |
| `postgresql.backup.enabled` | Enable the logical dump of the database | false |

## Releases

<dl>

  <dt>Version 0.6.2 - 2024-05-03</dt>
  <dd>Upgrade to new version of postgresql subchart. This does not change the postgreSQL version.</dd>

  <dt>Version 0.6.1</dt>
  <dd>Wrong location for containerPorts.</dd>

  <dt>Version 0.6.0</dt>
  <dd>Replaced the handmade postgresql config with the bitnami postgresql subchart.
      This also upgrades postgresql to version 16.2.0.</dd>

  <dt>Version 0.5.1</dt>
  <dd>Increase bitnami haproxy subchart from 0.12.0 to 1.0.1.</dd>

  <dt>Version 0.5.0</dt>
  <dd>Removed the Ingress configuration.</dd>

  <dt>Version 0.4.0</dt>
  <dd>Uses HAProxy to restrict access to admin pages.</dd>

  <dt>Version 0.3.0</dt>
  <dd>Standalone profile</dd>

  <dt>Version 0.2.0</dt>
  <dd>Can set log level.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


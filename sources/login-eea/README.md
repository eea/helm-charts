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

| Version | Date | Description |
| ------- | ---- | ----------- |
| Version 1.0.0 | 2025-07-18 | Upgrade HAProxy to 2.1.10. Chart is no longer in draft. |
| Version 0.6.2 | 2024-05-03 | Upgrade to new version of postgresql subchart. This does not change the postgreSQL version. |
| Version 0.6.1 | | Wrong location for containerPorts. |
| Version 0.6.0 | | Replaced the handmade postgresql config with the bitnami postgresql subchart.  This also upgrades postgresql to version 16.2.0. |
| Version 0.5.1 | | Increase bitnami haproxy subchart from 0.12.0 to 1.0.1. |
| Version 0.5.0 | | Removed the Ingress configuration. |
| Version 0.4.0 | | Uses HAProxy to restrict access to admin pages. |
| Version 0.3.0 | | Standalone profile |
| Version 0.2.0 | | Can set log level. |
| Version 0.1.0 | | Initial version. |



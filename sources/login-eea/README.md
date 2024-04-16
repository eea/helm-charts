# EEA Login service

Configured for EEA use only. Depends on the TLS certificate to be in the Secret star-eea-europa-eu.

## Configuration

| Key | Description | Default |
| --- | ----------- | ------- |
| `serviceName` | The hostname of the service | login.eea.europa.eu |
| `haproxy.enabled` | Creates a frontend that restricts the admin pages | true |

## Releases

<dl>

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


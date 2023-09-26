# iguana.eea.europa.eu

This chart is configured for production.

This is originally a service to load files into a Postgres DB, and then extract the data for consumption by SDI. 

## Dependencies

These objects must exist before deployment:

- A TLS secret called star-eea-europa-eu
- A ConfigMap called cacrts. It contains the CA certificates for trusting the server certificate
- A ConfigMap called hba-configmap. It contains the postgres `pg_hba` configuration.

## Releases

<dl>

  <dt>Version 0.1.1</dt>
  <dd>Health check every 60 seconds.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


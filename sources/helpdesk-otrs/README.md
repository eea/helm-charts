# Eionet Helpdesk

This chart is (almost) configured for production.

## Dependencies

As the package has an integrated web frontend that listens on the HTTPS port, it
expects to find a certificate secret matching the name at `haproxy.extraVolumes.secretName`.

## Releases

<dl>

  <dt>Version 0.3.1</dt>
  <dd>Typo in target ports.</dd>

  <dt>Version 0.3.0</dt>
  <dd>Integrated HAProxy as subchart.</dd>

  <dt>Version 0.2.1</dt>
  <dd>Liveness probe on frontend.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Sendmail requires a FQDN for hostname. In Kubernetes this requires a subdomain.</dd>

  <dt>Version 0.1.2</dt>
  <dd>Backend doesn't listen on port 80.</dd>

  <dt>Version 0.1.1</dt>
  <dd>Frontend is not a master</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


# Reportnet CDR

The Central Data Repository is part of the Reportnet architecture. The Central Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Values

<dl>

  <dt>rabbitmq</dt>
  <dd>This can be used to set the rabbitmq host to be used.</dd>.</dd>

</dl>

## Releases

<dl>

  <dt>Version 0.1.7</dt>
  <dd>Refactoring and cleanup.</dd>
  <dd>Updated rn-varnish chart to 0.1.4.</dd>
  <dd>Updated rn-local-converters chart to 0.1.2.</dd>
  <dd>Updated rn-clamav chart to 0.1.2.</dd>
  <dd>Updated ingress</dd>

  <dt>Version 0.1.6</dt>
  <dd>Refactored to be able to install multiple stacks in the same namespace. Due to the chart naming, we can't solely rely on appl.fullname for service naming</dd>
  <dd>Dropped deployment since it's not needed, we can use RELEASE instead</dd>
  <dd>Removed storage PVC since it's not needed</dd>

  <dt>Version 0.1.5</dt>
  <dd>Added rabbitmq.create and rabbitmq.name. When create is true, the rabbitmq service will be created.</dd>

  <dt>Version 0.1.4</dt>
  <dd>Get the image and tag from image section.</dd>

  <dt>Version 0.1.3</dt>
  <dd>Changed rabbitmq to externalName.</dd>

  <dt>Version 0.1.2</dt>
  <dd>Updated rn-varnish chart to 0.1.3 and fix ingress path</dd>

  <dt>Version 0.1.1</dt>
  <dd>Updated rn-varnish chart to 0.1.2.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial release.</dd>

</dl>

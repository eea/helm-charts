# EUNIS

This chart is configured to require little or no configuration for development and test usage.

If you need to modify, then create a new .yaml file with the modifications.

For the database password, use the default values, or if you already have an existing database,
set the values in the database section.

## Namespace-awareness

Since this app expects to find the database at the name `dbservice`, you can not
run two different EUNIS applications in the same namespace.

## Smoke test

You can run `helm test eunis` to verify the system is working correctly.

## Releases

<dl>

  <dt>Version 1.0.4 - 9 Aug. 2024</dt>
  <dd>Removed default annotations for Ingress.</dd>

  <dt>Version 1.0.3 - 9 Aug. 2024</dt>
  <dd>Added startup and readyness probes. Made them optional.</dd>

  <dt>Version 1.0.2</dt>
  <dd>Made buildsw optional, and disabled by default.</dd>

  <dt>Version 1.0.1</dt>
  <dd>Added security policy to deny outward connections from database.</dd>

  <dt>Version 1.0.0</dt>
  <dd>Removed readyness probe.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Added network security policies.</dd>

  <dt>Version 0.1.3</dt>
  <dd>First version to be used in production.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


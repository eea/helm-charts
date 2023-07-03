# Eionet LDAP

This chart can be used for standalone server or master-slave configurations.

## Prerequisites
The application expects a TLS Secret with the name star-eionet-europa-eu to be present
in the same namespace.

## Backups
There is a backup cronjob built in, which can be enabled with backup.enable=true

## Release notes

<dl>
  <dt>Version 1.0.1</dt>
  <dd>use a livenessProbe instead of a readiness probe</dd>

  <dt>Version 1.0.0</dt>
  <dd>Ready for production</dd>
</dl>


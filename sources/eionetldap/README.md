# Eionet LDAP

This chart can be used for standalone server or master-slave configurations.

## Prerequisites
The application expects a TLS Secret with the name star-eionet-europa-eu to be present
in the same namespace.

## Backups
There is a backup cronjob built in, which can be enabled with backup.enable=true

## Releases

<dl>

  <dt>Version 1.2.2 - 28 May 2024</dt>
  <dd>Make TLS enforcement optional.</dd>

  <dt>Version 1.2.1</dt>
  <dd>Prepared for MDB backend and Alma9. Increased container image version tag.</dd>

  <dt>Version 1.2.0-alpha.1</dt>
  <dd>Unsuitable for production environments.</dd>

  <dt>Version 1.1.3</dt>
  <dd>Added externalTrafficPolicy option.</dd>
  
  <dt>Version 1.1.2</dt>
  <dd>Increased container image version tag.</dd>
  
  <dt>Version 1.1.1</dt>
  <dd>Increased container default memory values. Increased image version tag.</dd>
  
  <dt>Version 1.1.0</dt>
  <dd>Sync consumers now use ephemeral storage, which means they will 
      do a complete download of the ldap database at redeploy.</dd>

  <dt>Version 1.0.1</dt>
  <dd>use a livenessProbe instead of a readiness probe.</dd>

  <dt>Version 1.0.0</dt>
  <dd>Ready for production.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Can accept annotations on the Service object.</dd>

</dl>


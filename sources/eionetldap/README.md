# Eionet LDAP

This chart can be used for standalone server or master-slave configurations.

## Prerequisites
The application expects a TLS Secret with the name star-eionet-europa-eu to be present
in the same namespace.

## Backups
There is a backup cronjob built in, which can be enabled with backup.enable=true

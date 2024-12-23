# Reportnet BDR

The Business Data Repository is part of the Reportnet architecture. The Business Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Values

### rabbitmq
This can be used to set the rabbitmq host to be used.

## Releases

### Version 0.1.30
- Updated appVersion to 5.9.4-199

### Version 0.1.29
- Updated rn-apache to 0.1.6
- Added healthchecks for apache in values.yaml

### Version 0.1.28
- Updated appVersion to 5.9.4-198

### Version 0.1.27
- Updated rn-bdr-european-registry to 0.1.4
- Added auditors fetch sync job

### Version 0.1.26
- Updated rn-apache to 0.1.5

### Version 0.1.25
- Updated postfix to 3.0.6

### Version 0.1.24
- Updated postfix to 3.0.5

### Version 0.1.23
- Updated postfix to 3.0.4

### Version 0.1.22
- Updated rn-apache to 0.1.4

### Version 0.1.21
- Updated appVersion to 5.9.4-197

### Version 0.1.20
- Updated rn-bdr-registry-notifications to 0.1.6
- Updated rn-bdr-registry to 0.1.3
- Updated rn-bdr-european-registry to 0.1.3

### Version 0.1.19
- Updated rn-bdr-registry-notifications to 0.1.5
- Updated rn-bdr-registry to 0.1.2
- Updated rn-bdr-european-registry to 0.1.2

### Version 0.1.18
- Updated appVersion to 5.9.4-196.

### Version 0.1.17
- Updated rn-bdr-registry-notifications to 0.1.4

### Version 0.1.16
- Updated rn-bdr-registry-notifications to 0.1.3

### Version 0.1.15
- Updated rn-bdr-registry-notifications to 0.1.2 to add support for deploymentArgs in registry-notifications-async

### Version 0.1.14
- Updated rn-bdr-registry-notifications to 0.1.1
- Updated postfix to 3.0.3

### Version 0.1.13
- Updated rn-apache to 0.1.3
- Updated postfix to 3.0.2
- Added mailtrap specific values and questions

### Version 0.1.12
- Updated rn-bdr-ldap to 0.1.1

### Version 0.1.11
- Added additional sentry related env variables
- Single quoted env variables in instance deployment

### Version 0.1.10
- Updated rn-local-converters, rn-clamav

### Version 0.1.9
- Converted sync jobs token question to password.

### Version 0.1.8
- Updated rn-cclamav to 0.1.3
- Updated rn-bdr-registry to 0.1.1
- Updated README

### Version 0.1.7
- Updated appVersion to 5.9.4-194

### Version 0.1.6
- Removed bdr-sync job and updated questions.yaml

### Version 0.1.5
- Fixed cron-sync-cronjob.yaml template

### Version 0.1.4
- Tweaked sync cronjobs with custom backoffLimit

### Version 0.1.3
- Questions updates for some strings

### Version 0.1.2
- Questions updates

### Version 0.1.1
- Added htpasswd question

### Version 0.1.0
- Initial release

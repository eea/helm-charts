# Reportnet BDR

The Business Data Repository is part of the Reportnet architecture. The Business Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Values

### rabbitmq
This can be used to set the rabbitmq host to be used.

## Releases

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

# Data Dictionary

This chart is configured for production use.

## Releases

### Version 1.3.9 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`19b8463c`](https://github.com/eea/helm-charts/commit/19b8463c9b0aeef751a8196da9d82a49ce647459)]


### Version 1.3.8
- Xalan serializer fix.

### Version 1.3.7
- Libraries upgrades.

### Version 1.3.6
- UI update.

### Version 1.3.5
- Tomcat upgrade to 9.0.99. Helpdesk email update. Postfix upgrade.

### Version 1.3.4
- XSS fixes.

### Version 1.3.3
- Security fixes

### Version 1.3.2 - 12 September 2024
- Updated mail forwarder subchart to 2.0.1.

### Version 1.3.1
- XSS fix, migration from archiva repositoy to maven package repository.

### Version 1.3.0
- Added mail forwarder pod. Usage to be specified in mailHost.

### Version 1.2.5
  <dd>Upload RDF API gzip compressed, base64 encoded RDF content, db column type change,
      site code allocation service notifications update, xss fix</dd>

### Version 1.2.4
- Typo in database chart.

### Version 1.2.3
- XSS fix.

### Version 1.2.2
- Additional network security policies.

### Version 1.2.1
- Buildsw now uses centos7dev image version 3.0.0.

### Version 1.2.0
- Builddict and buildsw no longer enabled by default.

### Version 1.1.1
  <dd>Set up startupProbe to allow liquibase to complete.
     Added netsecpol to block egress from database.</dd>

### Version 1.1.0
- Make it possible to connect to database over load-balancer.

### Version 1.0.2
- Bugfix in ldap system properties.

### Version 1.0.1
- Use http for env.dd.url instead of https.

### Version 1.0.0
- First version to be used in production.

### Version 0.1.1
- The service name for the database must apparently be dbservice-upd.

### Version 0.1.0
- Initial version.




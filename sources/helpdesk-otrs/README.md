# Eionet Helpdesk

This chart is (almost) configured for production.

## Dependencies

As the package has an integrated web frontend that listens on the HTTPS port, it
expects to find a certificate secret matching the name at `haproxy.extraVolumes.secretName`.

## Parameters

| Name | Description | Value |
| ---- | ----------- | ----- |
| postfix.dryrun | If set to true, the mails will not get sent, but sent to stdout | false |
| smtpService.loadbalancerName | FQDN of the Loadbalancer vIP, that the smtp service receives mail from | REPLACEME |
| database.hostname | Name of database host | mariadb |
| database.database | Name of database | otrs |
| database.username | Name of database user | otrs |
| database.password | Database password | REPLACEME |
| database.rootpw | Name of database root password | REPLACEME |
| ldapHost | Ldap service for looking up Eionet users| '' |
| ldapPassword | Password for DN with unlimited browsing | '' |
| mailHost | Name of mail service for outgoing mail | postfix |
| mysqlRootPassword | Root password of mysql | '' |
| otrsRootPassword | Root password of OTRS | '' |

## Releases

| Version | Notes |
| ------- | ----- |
| 0.6.0 - 16-APR-2025 | Make the probes configurable with sane defaults. |
| 0.5.5 - 14-APR-2025 | Increased patch version number on MariaDB. |
| 0.5.4 - 03-MAR-2025 | Increased startup probe to 600 seconds. |
| 0.5.3 - 12-DEC-2024 | Add Perl library LibXSLT to OTRS image. |
| 0.5.2 - 28-AUG-2024 | Upgrade to HAproxy 3.0.3 via subchart. | 
| 0.5.1 - 11-JUN-2024 | Delete X-Forwarded-Port as it resolves to 8443. | 
| 0.5.0 - 11-JUN-2024 | Add X-Forwarded-Proto and X-Forwarded-Port to haproxy configuration. Upgrade haproxy subchart to version 2.0.2. |
| 0.4.0 - 10-MAR-2024 | Upgrade of postfix subchart, which adds the dryrun switch. |
| 0.3.1 | Typo in target ports. | 
| 0.3.0 | Integrated HAProxy as subchart. | 
| 0.2.1 | Liveness probe on frontend. | 
| 0.2.0 | Sendmail requires a FQDN for hostname. In Kubernetes this requires a subdomain. | 
| 0.1.2 | Backend doesn't listen on port 80. | 
| 0.1.1 | Frontend is not a master | 
| 0.1.0 | Initial version. | 


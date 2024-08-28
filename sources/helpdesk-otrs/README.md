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

<dl>

  <dt>Version 0.5.2 - 28-AUG-2024</dt>
  <dd>Upgrade to HAproxy 3.0.3 via subchart.</dd>

  <dt>Version 0.5.1 - 11-JUN-2024</dt>
  <dd>Delete X-Forwarded-Port as it resolves to 8443.</dd>

  <dt>Version 0.5.0 - 11-JUN-2024</dt>
  <dd>Add X-Forwarded-Proto and X-Forwarded-Port to haproxy configuration.</dd>
  <dd>Upgrade haproxy subchart to version 2.0.2.</dd>

  <dt>Version 0.4.0 - 10-MAR-2024</dt>
  <dd>Upgrade of postfix subchart, which adds the dryrun switch.</dd>

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


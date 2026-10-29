# Eionet backend - Plone 6

This chart deploys the [Eionet LDAP account tools](https://github.com/eea/eionet-backend)
(formerly `/eionet-account-tools` on the Eionet Portal): a Plone 6 Classic
site served at the domain root. All account data lives in LDAP; the Plone
database only holds the site and the tool settings.

## Components

- Plone backend, one instance on filestorage, with two init containers that
  create the Classic site and the account tools (`create-classic`,
  `scripts/setup_tools.py`). Both skip what already exists, so they run safely
  on every start.
- `<release>-data` volume (ReadWriteMany) at `/data`: filestorage, blobs, and
  `/data/ldapdump` (`config.yaml`, SQLite cache of LDAP users,
  `countries.json`), shared with the LDAP dump job
- LDAP dump cron job, refreshing the SQLite cache
- Postfix relay ([postfix](../postfix) chart) for account emails

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| plone.hostname | string | eionet-backend.01dev.eea.europa.eu | Public domain |
| plone.site | string | Plone | Plone site id, mapped to the domain root |
| ldap.server | string | "" | LDAP `host:port`, always ldaps |
| ldap.adminDN, ldap.adminPassword | string | "" | Bind account with write access |
| ldap.secondaryDN, ldap.secondaryPassword | string | "" | Read-only bind account, also used by the LDAP dump |
| mail.from | string | "" | Sender address of account emails |
| ingress.configuration.whitelist-source-range | string | "" | Comma separated CIDRs allowed to reach the site; empty for public |
| persistence.storageClass | string | "" | Storage class supporting ReadWriteMany |
| setup.enabled | bool | true | Run the site and tools setup before Plone starts |
| cronjobs.ldapdump.schedule | string | 41 8,13,16 * * 1-5 | LDAP dump schedule |

LDAP passwords are stored in the `<release>-eionet-backend` Secret.

## Notes

- The LDAP settings are copied into each account tool when it is created.
  Later changes to `ldap.*` do not update existing tools: change them in the
  ZMI (`manage_edit` of each tool). The LDAP dump reads
  `/data/ldapdump/config.yaml`, which is written only once; edit or delete
  it, then restart the backend.
- The Zope `admin` user is created with the default password on the first
  start. Change it in the ZMI (`/acl_users`) right after the first deployment.
- The database only changes when tool settings change; pack it, if ever
  needed, from the ZMI (Control Panel, Database Management).
- Plone login with LDAP accounts (`pas.plugins.ldap`) is configured through
  the web.

## Releases

### Version 0.1.0 - 28 October 2026
- Initial release

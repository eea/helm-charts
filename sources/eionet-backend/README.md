# Eionet backend - Plone 6

This chart deploys the [Eionet LDAP account tools](https://github.com/eea/eionet-backend)
(formerly `/eionet-account-tools` on the Eionet Portal): a Plone 6 Classic
site served at the domain root. All account data lives in LDAP; the Plone
database only holds the site and the tool settings.

## Components

- Plone backend, one instance on filestorage. The Classic Plone site (id
  `plone.site`), the account tools and their settings are created through
  the web
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
| ingress.configuration.whitelist-source-range | string | "" | Comma separated CIDRs allowed to reach the site; empty for public |
| persistence.storageClass | string | "" | Storage class supporting ReadWriteMany |
| cronjobs.ldapdump.schedule | string | 41 8,13,16 * * 1-5 | LDAP dump schedule |

## Notes

- The account tools and their LDAP settings are created in the ZMI
  (Configure tab, `manage_edit`, of each tool); the mail settings in Site
  Setup (host `postfix`, port 25).
- The LDAP dump reads `/data/ldapdump/config.yaml` (LDAP host, read-only bind
  DN and password). Create it on the volume, then restart the backend.
- The Zope `admin` user is created with the default password on the first
  start. Change it in the ZMI (`/acl_users`) right after the first deployment.
- The database only changes when tool settings change; pack it, if ever
  needed, from the ZMI (Control Panel, Database Management).
- Plone login with LDAP accounts (`pas.plugins.ldap`) is configured through
  the web.

## Releases

### Version 0.8.0 - 11 November 2026
- Automated release of [eeacms/eionet-backend:6.1.6-1](https://github.com/eea/eionet-backend/releases) [EEA Jenkins - [`154e1cfc7`](https://github.com/eea/helm-charts/commit/154e1cfc7228cab80fcf56b6be941992389b534d)]

### Version 0.7.0 - 09 November 2026
- Automated release of [eeacms/eionet-backend:6.1.4-5](https://github.com/eea/eionet-backend/releases) [EEA Jenkins - [`a149bb9dd`](https://github.com/eea/helm-charts/commit/a149bb9ddfac435fa9f9c0b7592d617fcc4771b3)]

### Version 0.6.0 - 09 November 2026
- Automated release of [eeacms/eionet-backend:6.1.4-4](https://github.com/eea/eionet-backend/releases) [EEA Jenkins - [`e682d97a4`](https://github.com/eea/helm-charts/commit/e682d97a483b0f72bd83b9a1933cbe99f29894c4)]

### Version 0.5.0 - 06 November 2026
- Automated release of [eeacms/eionet-backend:6.1.4-3](https://github.com/eea/eionet-backend/releases) [EEA Jenkins - [`a9dab502b`](https://github.com/eea/helm-charts/commit/a9dab502b37679f10f74c91e30966196be501304)]

### Version 0.4.0 - 06 November 2026
- Automated release of [eeacms/eionet-backend:6.1.4-2](https://github.com/eea/eionet-backend/releases) [EEA Jenkins - [`2a874263b`](https://github.com/eea/helm-charts/commit/2a874263b32dd0d8947e4e5ebfc8df2f57a119b0)]

### Version 0.3.0 - 29 October 2026
- Remove the create-site init container: the Plone site is created through
  the web

### Version 0.2.0 - 29 October 2026
- Remove the LDAP and mail values, the Secret and the setup-tools init
  container: the account tools are configured in the ZMI

### Version 0.1.0 - 28 October 2026
- Initial release

# SDI catalogue

A csw service and front end application to search and find EEA GIS datasets.

## Cronjobs

Cronjobs have been removed since the update to GN 5/ GN 46 and the new folder structure.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serverName | string | sdi.eea.europa.eu | Name of the server |
| serverUrl | string | <https://sdi.eea.europa.eu:443> | URL of the server. The port is required. |
| gn5.oauth2.enabled | boolean | false | Enable OAuth2 authentication for GN5 |
| gn5.oauth2.clientId | string | '' | OAuth2 client ID |
| gn5.oauth2.clientSecret | string | '' | OAuth2 client secret (only for helm install via --set-string flag, NOT for values.yaml) |
| gn5.oauth2.existingSecret | string | '' | Name of existing Kubernetes secret containing the client secret |
| gn5.oauth2.existingSecretKey | string | 'client-secret' | Key in the existing secret containing the client secret |
| gn5.oauth2.issuerUri | string | '' | OAuth2 issuer URI (e.g., MS Entra ID tenant) |
| gn5.oauth2.redirectUri | string | '' | OAuth2 redirect URI (defaults to {geonetwork.url_with_context}/login/oauth2/code/eea if empty) |
| gn5.oauth2.scopes | string | 'openid,profile,email' | OAuth2 scopes |
| nextcloudRedis.enabled | boolean | true | Enable Redis for Nextcloud distributed caching and file locking |
| nextcloudRedis.image | string | 'redis:7-alpine' | Redis Docker image |
| nextcloudRedis.resources.requests.memory | string | '128Mi' | Redis memory request |
| nextcloudRedis.resources.limits.memory | string | '512Mi' | Redis memory limit |
| nextcloudRedis.storage | string | '100Mi' | Redis PVC storage size |

## OAuth2 Configuration

To enable OAuth2 authentication with MS Entra ID for GN5, you have two options for managing the client secret:

### Option 1: Use an existing Kubernetes secret (Recommended)

First, create the secret manually:
```bash
kubectl create secret generic gn5-oauth2-credentials \
  --from-literal=client-secret='your-client-secret' \
  -n your-namespace
```

Then configure the chart:
```yaml
gn5:
  oauth2:
    enabled: true
    clientId: "your-client-id"
    existingSecret: "gn5-oauth2-credentials"
    existingSecretKey: "client-secret"
    issuerUri: "https://login.microsoftonline.com/YOUR_TENANT_ID/v2.0"
    scopes: "openid,profile,email"
```

### Option 2: Provide secret via command line

```bash
helm install sdi-catalogue eea-charts/sdi-catalogue \
  --set gn5.oauth2.enabled=true \
  --set gn5.oauth2.clientId="your-client-id" \
  --set-string gn5.oauth2.clientSecret="your-client-secret" \
  --set gn5.oauth2.issuerUri="https://login.microsoftonline.com/YOUR_TENANT_ID/v2.0"
```

**Important**: Never commit the `clientSecret` value to your values.yaml file or version control.

The OAuth2 client registration is named `eea` in the Spring Security configuration.

## Releases

### Version 0.8.40 - 01 February 2026
- Add Redis integration for Nextcloud distributed caching and file locking.
- New deployment and service for Redis (`nextcloud-redis`).
- Configure Nextcloud to use Redis for `memcache.distributed` and `memcache.locking`.
- Redis can be disabled via `nextcloudRedis.enabled: false`.

### Version 0.8.39 - 27 January 2026
- Remove Github provider and fix security config [Juan Luis Rodriguez Ponce - [`022b1f75`](https://github.com/eea/helm-charts/commit/022b1f7500ffbde03c0ff522f24e41d882f7f3fa)]

### Version 0.8.38 - 27 January 2026
- Update GN46 (`eea-4.9.x-1a3bd804`) and GN5 (`e9f56fb0`).

### Version 0.8.37 - 13 January 2026
- Update GN46 (`eea-4.9.x-2d350753`).
 
### Version 0.8.36 - 13 January 2026
- Increase `geonetworkdb` memory and CPU defaults.

### Version 0.8.35 - 13 January 2026
- Update GN46 (`eea-4.9.x-62171636`).

### Version 0.8.34 - 18 December 2025
- Release of dependent chart postfix:3.2.0 [EEA Jenkins - [`3e16bd0e`](https://github.com/eea/helm-charts/commit/3e16bd0e1b7cc3010d7804e4b54516a2e9f85558)]


### Version 0.8.33 - 05 December 2025
- Update GN46 (`eea-4.9.x-9f5c9e31`).

### Version 0.8.32 - 28 November 2025
- Update GN46 (`eea-4.9.x-34b0872a`).
  
### Version 0.8.31 - 20 November 2025
- Update GN46 (`eea-4.9.x-a9ed7c4c`).
  
### Version 0.8.30 - 20 November 2025
- Update GN46 (`eea-4.9.x-f4e97fe3`).

### Version 0.8.29 - 20 November 2025
- Update GN46 (`eea-4.9.x-7a654b0a`) and GN5 (`646d48e9`).
  
### Version 0.8.28 - 20 November 2025
- Update INSPIRE validator to v2025.1.1.

### Version 0.8.27 - 12 November 2025
- Update GN46 (`eea-4.9.x-25a2ba76`).

### Version 0.8.26 - 11 November 2025
- Update GN46 (`eea-4.9.x-3accec30`).
  
### Version 0.8.25 - 06 November 2025
- Update GN5 (`96743962`) / GN46 (`eea-4.9.x-30cd7285`).

### Version 0.8.24 - 31 October 2025
- Fix /gis_sdi/ from the datastore links.

### Version 0.8.23 - 31 October 2025
- Fix /datastore/internal links.

### Version 0.8.22 - 23 October 2025
- Fix Nextcloud /datastore/public links.
- Update GN 4 to `eea-4.9.x-a028bebf`

### Version 0.8.21 - 22 October 2025
- Update GN4 to `eea-4.9.x-78c94feb` and GN5 to `8407f847`.

### Version 0.8.20 - 20 October 2025
- Update GN5 to `987ecfb1`.

### Version 0.8.19 - 14 October 2025
- Fix typo in nextcloud configmap
 
### Version 0.8.18 - 14 October 2025
- Nextcloud localstorage.allowsymlinks setting.

### Version 0.8.17 - 14 October 2025
- Don't use a skeleton directory in Nextcloud.

### Version 0.8.16 - 09 October 2025
- Unprotect Nextcloud login.
  
### Version 0.8.15 - 09 October 2025
- Add shared links to values.yaml.
 
### Version 0.8.14 - 05 October 2025
- Update GN4 to eea-4.9.x-79b20ac4.
  
### Version 0.8.13 - 05 October 2025
- Update GN4 to eea-4.9.x-e079c02b.

### Version 0.8.12 - 05 October 2025
- Update GN4 to eea-4.9.x-3886b5a9.

### Version 0.8.11 - 02 October 2025
- Use a ConfigMap for GN5.
  
### Version 0.8.10 - 01 October 2025
- Update GN5 to 78febcf2.
  
### Version 0.8.9 - 01 October 2025
- Update GN46 to eea-4.9.x-78eeeac1.
  
### Version 0.8.8 - 30 September 2025
- Update GN46 to eea-4.9.x-4d2a7043.

### Version 0.8.7 - 29 September 2025
- Update GN46 and GN5.

### Version 0.8.6 - 29 September 2025
- Disable `/webdav/datastore/public` redirection and use a `Rewrite` directive instead because `Redirect`
  takes precedence over `Rewrite`.
- Disable the direct access to WebDAV access to `/var/lib/gis_sdi/public` folder.

### Version 0.8.5 - 29 September 2025
- Fix url parameter encoding.

### Version 0.8.4 - 29 September 2025
- Redirect `/webdav/datastore/public/<rest_of_path>` to `/datastore/public?path=%2F<rest_of_path>`.

### Version 0.8.3 - 29 September 2025
- Fix `/data` proxy pass to use gn46 context path instead of hardcoded `/geonetwork`.

### Version 0.8.2 - 26 September 2025
- Fix authentication prompt in GN5 metadata editor.
- Fix liveness probe of GN5 now using the web context from `values.yaml`.
  
### Version 0.8.1 - 25 September 2025
- Fix proxypass of /catalogue -> gn5:8080/catalogue

### Version 0.8.0 - 25 September 2025
- Remove old GN 4.
- Update GN46 and GN5 to use /catalogue instead of /geonework.

### Version 0.7.27 - 23 September 2025
- Trusted proxies and x-forwarded-for headers for Nextcloud.

### Version 0.7.26 - 23 September 2025
- Update GN46 to eea-4.9.x-1698c928.
  
### Version 0.7.25 - 10 September 2025
- Use GN5 image from eeacms/eea-geonetwork5.
- Revert Nextcloud to 30.0.2 because image for 30.0.3 doesn't exist.

### Version 0.7.24 - 10 September 2025
- Update Apache to 1.0.15 (httpd 2.4.65).
- Update Nextcloud to 30.0.3
- Remove nextcloud-redis deployment and service.
- Update Elasticsearch to 8.14.3
- Update Kibana to 8.14.3
- Revome webdav-nc and sync-nc-apche cron jobs.
- Disable samba contanier.

### Version 0.7.23 - 10 September 2025
- Fix GN5 user and group to match other containers.

### Version 0.7.22 - 09 September 2025
- Update GN46 with new docker tag format.

### Version 0.7.21 - 09 Septenber 2025
- Update GN46 to [`8568fc45`](https://github.com/eea/geonetwork-eea/commit/8568fc4557fd07857b12ee95101482f8b424b396) and GN5 to [`1a561dd7fb`](https://github.com/eea/geonetwork5-eea/commit/1a561dd7fb4df04c9e33ae0b0f239be5c0554d62).
  
### Version 0.7.20 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`ecdf5d88`](https://github.com/eea/helm-charts/commit/ecdf5d884a7aca9cc563bab1477f010314d332f2)]

### Version 0.7.19- 06 Aug 2025
- Update GN5.

### Version 0.7.18 - 01 Aug 2025
- Update GN46 and GN5. Add config map for security properties.

### Version 0.7.17 - 01 Jul 2025
- Update GN46.

### Version 0.7.16 - 26 Jun 2025
- Fix probes for validator.

### Version 0.7.15 - 26 Jun 2025
- Liveness probes for Nextcloud and Validator. Update validator to 2024.3.

### Version 0.7.14 - 26 Jun 2025
- Fix typo in Liveness paths for GN and GN46

### Version 0.7.13 - 26 Jun 2025
- Liveness and Readiness probes for GN, GN46 and GN5

### Version 0.7.12 - 26 Jun 2025
- New GN46 and GN5 versions.

### Version 0.7.11 - 11 Jun 2025
- New GN46 version. Fix /data proxypass.

### Version 0.7.10 - 10 Jun 2025
- Readiness probe for GN

### Version 0.7.9 - 10 Jun 2025
- Add health checks

### Version 0.7.8 - 10 Jun 2025
- Update GN46 and GN5

### Version 0.7.7 - 20 May 2025
- Add log directory to public-catalogue deployment

### Version 0.7.6 - 20 May 2025
- Update GN46 and GN5

### Version 0.7.5 - 25 April 2025
- Add apache redirections. Add symlinks to GN datastore. Events for updating the metadata file on metadata change. All running as www-data (33:33)

### Version 0.7.4 - 24 April 2025
- Externalise GN5 configuration yml file

### Version 0.7.3 - 24 April 2025
- Fix Nextcloud configmap values

### Version 0.7.2 - 24 April 2025
- Fix config map

### Version 0.7.1 - 24 April 2025
  <dd>Make Nextcloud's config.php not read-only. Add ConfigMap with Nextcloud config to 
  /etc/nextcloud/config/config.php and a initcontainer that creates a symlink in /var/www/html/config/k8s.config.php to that file.
  This allow to have a read-only configuration file in a ConfigMap and Nextcloud doesn't complain about config.php read-only file.
  Remove nextcloud-db container as NC can use a postgres database instead.
  </dd>

### Version 0.7.0 - 22 April 2025
- Update Nextcloud to 30 and MariaDB to 10.11

### Version 0.6.38 - 22 April 2025
- GN5 updated to d287bcfc

### Version 0.6.37 - 01 April 2025
- GN5 updated to 6cbb0735

### Version 0.6.36 - 21 March 2025
- GN5 updated to a47ed08f

### Version 0.6.35 - 07 March 2025
- GN5 updated to 5eba5900

### Version 0.6.34 - 07 March 2025
- GN5 - Removed basic auth for GN5.

### Version 0.6.33 - 06 March 2025
- GN 4.6.x - Custom datastore rollback.

### Version 0.6.32 - 06 March 2025
- GN 4.6.x - Custom datastore.

### Version 0.6.31 - 04 March 2025
- Use a switch to enable/disable GN5/GN46x services.

### Version 0.6.30 - 04 March 2025
- Update GN to 5c376d1e.

### Version 0.6.29 - 03 March 2025
- Enable CORS for Nextcloud Share link download endpoint.

### Version 0.6.28 - 19 February 2025
- Troubleshooting with basic authentication.

### Version 0.6.27 - 18 February 2025
- Fixes for GN5 and GN 4.6.x

### Version 0.6.26 - 17 February 2025
- Share data directory between GN5 and GN46.

### Version 0.6.25 - 14 February 2025
- Add GN5.

### Version 0.6.24 - 13 February 2025
- Update GN to e54c9b9d.

### Version 0.6.23 - 06 February 2025
- Update GN to 28973fb1.
  
### Version 0.6.22 - 05 February 2025
- Update GN to 6c72fe0c.

### Version 0.6.21 - 27 January 2025
- Update GN to 66a77c30.
- Add the option to allow ciertain hosts to bypass the Basic Auth in Apache.


### Version 0.6.20 - 19 December 2024
- Update GN to 3b75aaea.

### Version 0.6.19 - 17 December 2024
- Update GN to fe7ee40a.

### Version 0.6.18 - 12 December 2024
- Update GN to 72fa5c64.

### Version 0.6.17 - 05 December 2024
- Update GN to 8152c023.

### Version 0.6.16 - 21 October 2024
- Update GN to 4314733c.
- Record view / More like this / Add filter option.
- EEA / Editor / Fix open source and sibling panel. https://taskman.eionet.europa.eu/issues/277292

### Version 0.6.15 - 07 October 2024
- Update GN to e1fde81a. EEA / Statistical dataset / Default to EEA list of unit of measure.
- Keyword / Not capitalize and do not display thesaurus if no keywords.
- EEA / SDMX / Fix XPath for other constraints mapping.

### Version 0.6.14 - 02 October 2024
- Update GN to 3afedac5. EEA / Editor / Statistical data / Add action when missing unit of measure or ref period.
  
### Version 0.6.13 - 01 October 2024
- Update GN to b6d6d7da

### Version 0.6.12 - 12 September 2024
- Update GN to cef73a4c

### Version 0.6.11 - 12 September 2024
- Remove shareit job

### Version 0.6.10 - 12 September 2024
- Fix validator ConfigMap mount point

### Version 0.6.9 - 12 September 2024
- Add missing /etc/network/interfaces to validator pod as ConfigMap

### Version 0.6.8 - 12 September 2024
- Update validator pod privileges

### Version 0.6.7 - 10 September 2024
- Update GN to 295bd177. EEA / Thesaurus / Update ROD https://taskman.eionet.europa.eu/issues/270841

### Version 0.6.6 - 10 September 2024
- Update inspire validator image to 2024.2

### Version 0.6.5 - 10 September 2024
- Made sysctl updates optional, as the values are the default on the nodes now.
- Upgraded the postfix container.

### Version 0.6.4 - 08 August 2024
  <dd>Upgraded GN to b1adafc2.
    <ul>
      <li>EEA / Script / Add hierarchylevelname if not present https://taskman.eionet.europa.eu/issues/273346</li>
      <li>Record view / Improve layout of table (eg. quality measures)</li>
    </ul>
  </dd>

### Version 0.6.3 - 06 August 2024
- Upgraded Apache version.

### Version 0.6.2 - 06 August 2024
- Update GN to c3949e2c. EEA / SDMX / Add maintenance info to FREQ_DISS.

### Version 0.6.1 - 29 July 2024
  <dd>
    <ul>
      <li>EEA / Statistical data / Add date of next update.</li>
      <li>EEA / Statistical data / Migrate frequency of dissemination from maintenance to specific element.</li>
      <li>EEA / SDMX / Add frequency of dissemination.</li>
      <li>Standard / ISO19139 / Fix removal of link when multiple transferoptions are used.</li>
    </ul>
  </dd>

### Version 0.6.0 - 26 June 2024
- Use CronJob for all cron jobs. Must be enabled in values.yaml.

### Version 0.5.17 - 24 June 2024
- Optional cronjob for syncronising Nextcloud files with Apache.

### Version 0.5.16 - 11 June 2024
- Deactivate TRACE in Apache.

### Version 0.5.15 - 11 June 2024
- Upgraded Apache version.

### Version 0.5.14 - 04 June 2024
- The argument to Require ldap-group must not have quotes - implement everywhere.

### Version 0.5.13 - 04 June 2024
- The argument to Require ldap-group must not have quotes.

### Version 0.5.12 - 29 May 2024
- Update GN to 8a0008a6.

### Version 0.5.11 - 23 May 2024
- Update GN to 384d7b8c.

### Version 0.5.10 - 17 May 2024
- Update GN to 57c1ae49.

### Version 0.5.9 - 17 May 2024
- Redirect HTTP to HTTPS. Update GN to c255d985.

### Version 0.5.8 - 17 May 2024
- Remove CSP form-action directive casusing problems with the login form redirection.

### Version 0.5.7 - 17 May 2024
- Updated GN to ecb45615. Added some extra CSP header entries for the validator and OGC Records API

### Version 0.5.6 - 14 May 2024
- Removed unused sdi-public-catalogue-resources-pvc volume.

### Version 0.5.5 - 13 May 2024
- Remove Authorization header for /catalogue if the site is protected with basic auth.

### Version 0.5.4 - 09 May 2024
  <dd>Use only one header in Content-Security-Policy. This allow to fix a problem with img-src ignored if
  multiple hearders are used.</dd>

### Version 0.5.3 - 09 May 2024
- Add openstreetmap.org to allowed img-src policy.

### Version 0.5.2 - 09 May 2024
- Fix typo

### Version 0.5.1 - 09 May 2024
  <dd>Tune Content-Security-Policy headers. Use Header add instead of Header set to avoid
  override previous headers already set.
  </dd>

### Version 0.5.0 - 07 May 2024
  <dd>Clean up apache config.
    Added reportUri, privilegedIPs, privilegedGroups and privilegedUsers in values.yaml.
    Add basic auth globally to the web controlled by a value.
    The ssl.conf file is now applied unconditionally.
  </dd>



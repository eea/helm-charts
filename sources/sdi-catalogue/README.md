# SDI catalogue

A csw service and front end application to search and find EEA GIS datasets.

## Cronjobs

When the application was running on Rancher 1.6, it had a container, which ran the cron utility. It then ran three jobs periodically. The old mechanism is called cron and is now disabled by default. The three jobs are created as Kubernetes CronJobs, and can be enabled on an individual basis.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cron.enabled | bool | false | Use the old crontab mechanism |
| cleanupTransfer.enabled | bool | false | Remove files in ShareIT |
| syncNcApache.enabled | bool | false | Sync NextCloud files with Apache |
| webdavMetadata.enabled | bool | false | Update webdav meta data |
| serverName | string | sdi.eea.europa.eu | Name of the server |
| serverUrl | string | https://sdi.eea.europa.eu:443 | URL of the server. The port is required. |


## Releases

<dl>
  <dt>Version 0.6.3 - 06 August 2024</dt>
  <dd>Upgraded Apache version.</dd>

  <dt>Version 0.6.2 - 06 August 2024</dt>
  <dd>Update GN to c3949e2c. EEA / SDMX / Add maintenance info to FREQ_DISS.</dd>

  <dt>Version 0.6.1 - 29 July 2024</dt>
  <dd>
    <ul>
      <li>EEA / Statistical data / Add date of next update.</li>
      <li>EEA / Statistical data / Migrate frequency of dissemination from maintenance to specific element.</li>
      <li>EEA / SDMX / Add frequency of dissemination.</li>
      <li>Standard / ISO19139 / Fix removal of link when multiple transferoptions are used.</li>
    </ul>
  </dd>

  <dt>Version 0.6.0 - 26 June 2024</dt>
  <dd>Use CronJob for all cron jobs. Must be enabled in values.yaml.</dd>

  <dt>Version 0.5.17 - 24 June 2024</dt>
  <dd>Optional cronjob for syncronising Nextcloud files with Apache.</dd>

  <dt>Version 0.5.16 - 11 June 2024</dt>
  <dd>Deactivate TRACE in Apache.</dd>

  <dt>Version 0.5.15 - 11 June 2024</dt>
  <dd>Upgraded Apache version.</dd>

  <dt>Version 0.5.14 - 04 June 2024</dt>
  <dd>The argument to Require ldap-group must not have quotes - implement everywhere.</dd>

  <dt>Version 0.5.13 - 04 June 2024</dt>
  <dd>The argument to Require ldap-group must not have quotes.</dd>

  <dt>Version 0.5.12 - 29 May 2024</dt>
  <dd>Update GN to 8a0008a6.</dd>

  <dt>Version 0.5.11 - 23 May 2024</dt>
  <dd>Update GN to 384d7b8c.</dd>

  <dt>Version 0.5.10 - 17 May 2024</dt>
  <dd>Update GN to 57c1ae49.</dd>

  <dt>Version 0.5.9 - 17 May 2024</dt>
  <dd>Redirect HTTP to HTTPS. Update GN to c255d985.</dd>

  <dt>Version 0.5.8 - 17 May 2024</dt>
  <dd>Remove CSP form-action directive casusing problems with the login form redirection.</dd>

  <dt>Version 0.5.7 - 17 May 2024</dt>
  <dd>Updated GN to ecb45615. Added some extra CSP header entries for the validator and OGC Records API</dd>

  <dt>Version 0.5.6 - 14 May 2024</dt>
  <dd>Removed unused sdi-public-catalogue-resources-pvc volume.</dd>

  <dt>Version 0.5.5 - 13 May 2024</dt>
  <dd>Remove Authorization header for /catalogue if the site is protected with basic auth.</dd>

  <dt>Version 0.5.4 - 09 May 2024</dt>
  <dd>Use only one header in Content-Security-Policy. This allow to fix a problem with img-src ignored if
  multiple hearders are used.</dd>

  <dt>Version 0.5.3 - 09 May 2024</dt>
  <dd>Add openstreetmap.org to allowed img-src policy.</dd>

  <dt>Version 0.5.2 - 09 May 2024</dt>
  <dd>Fix typo</dd>

  <dt>Version 0.5.1 - 09 May 2024</dt>
  <dd>Tune Content-Security-Policy headers. Use Header add instead of Header set to avoid
  override previous headers already set.
  </dd>

  <dt>Version 0.5.0 - 07 May 2024</dt>
  <dd>Clean up apache config.
    Added reportUri, privilegedIPs, privilegedGroups and privilegedUsers in values.yaml.
    Add basic auth globally to the web controlled by a value.
    The ssl.conf file is now applied unconditionally.
  </dd>

</dl>


# SDI catalogue

A csw service and front end application to search and find EEA GIS datasets.

## Cronjobs

When the application was running on Rancher 1.6, it had a container, which ran the cron utility. It then ran three jobs periodically. The old mechanism is called cron and is now disabled by default. The three jobs are created as Kubernetes CronJobs, and can be enabled on an individual basis.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cron.enabled | bool | false | Use the old crontab mechanism |
| syncNcApache.enabled | bool | false | Sync NextCloud files with Apache |
| webdavMetadata.enabled | bool | false | Update webdav meta data |
| serverName | string | sdi.eea.europa.eu | Name of the server |
| serverUrl | string | <https://sdi.eea.europa.eu:443> | URL of the server. The port is required. |

## Releases

<dl>
  <dt>Version 0.7.13 - 26 Jun 2025</dt>
  <dd>Liveness and Readyness probes for GN, GN46 and GN5</dd>

  <dt>Version 0.7.12 - 26 Jun 2025</dt>
  <dd>New GN46 and GN5 versions.</dd>

  <dt>Version 0.7.11 - 11 Jun 2025</dt>
  <dd>New GN46 version. Fix /data proxypass.</dd>

  <dt>Version 0.7.10 - 10 Jun 2025</dt>
  <dd>Readiness probe for GN</dd>

  <dt>Version 0.7.9 - 10 Jun 2025</dt>
  <dd>Add health checks</dd>

  <dt>Version 0.7.8 - 10 Jun 2025</dt>
  <dd>Update GN46 and GN5</dd>

  <dt>Version 0.7.7 - 20 May 2025</dt>
  <dd>Add log directory to public-catalogue deployment</dd>

  <dt>Version 0.7.6 - 20 May 2025</dt>
  <dd>Update GN46 and GN5</dd>

  <dt>Version 0.7.5 - 25 April 2025</dt>
  <dd>Add apache redirections. Add symlinks to GN datastore. Events for updating the metadata file on metadata change. All running as www-data (33:33)</dd>

  <dt>Version 0.7.4 - 24 April 2025</dt>
  <dd>Externalise GN5 configuration yml file</dd>

  <dt>Version 0.7.3 - 24 April 2025</dt>
  <dd>Fix Nextcloud configmap values</dd>

  <dt>Version 0.7.2 - 24 April 2025</dt>
  <dd>Fix config map</dd>

  <dt>Version 0.7.1 - 24 April 2025</dt>
  <dd>Make Nextcloud's config.php not read-only. Add ConfigMap with Nextcloud config to 
  /etc/nextcloud/config/config.php and a initcontainer that creates a symlink in /var/www/html/config/k8s.config.php to that file.
  This allow to have a read-only configuration file in a ConfigMap and Nextcloud doesn't complain about config.php read-only file.
  Remove nextcloud-db container as NC can use a postgres database instead.
  </dd>

  <dt>Version 0.7.0 - 22 April 2025</dt>
  <dd>Update Nextcloud to 30 and MariaDB to 10.11</dd>

  <dt>Version 0.6.38 - 22 April 2025</dt>
  <dd>GN5 updated to d287bcfc</dd>

  <dt>Version 0.6.37 - 01 April 2025</dt>
  <dd>GN5 updated to 6cbb0735</dd>

  <dt>Version 0.6.36 - 21 March 2025</dt>
  <dd>GN5 updated to a47ed08f</dd>

  <dt>Version 0.6.35 - 07 March 2025</dt>
  <dd>GN5 updated to 5eba5900</dd>

  <dt>Version 0.6.34 - 07 March 2025</dt>
  <dd>GN5 - Removed basic auth for GN5.</dd>

  <dt>Version 0.6.33 - 06 March 2025</dt>
  <dd>GN 4.6.x - Custom datastore rollback.</dd>

  <dt>Version 0.6.32 - 06 March 2025</dt>
  <dd>GN 4.6.x - Custom datastore.</dd>

  <dt>Version 0.6.31 - 04 March 2025</dt>
  <dd>Use a switch to enable/disable GN5/GN46x services.</dd>

  <dt>Version 0.6.30 - 04 March 2025</dt>
  <dd>Update GN to 5c376d1e.</dd>

  <dt>Version 0.6.29 - 03 March 2025</dt>
  <dd>Enable CORS for Nextcloud Share link download endpoint.</dd>

  <dt>Version 0.6.28 - 19 February 2025</dt>
  <dd>Troubleshooting with basic authentication.</dd>

  <dt>Version 0.6.27 - 18 February 2025</dt>
  <dd>Fixes for GN5 and GN 4.6.x</dd>

  <dt>Version 0.6.26 - 17 February 2025</dt>
  <dd>Share data directory between GN5 and GN46.</dd>

  <dt>Version 0.6.25 - 14 February 2025</dt>
  <dd>Add GN5.</dd>

  <dt>Version 0.6.24 - 13 February 2025</dt>
  <dd>Update GN to e54c9b9d.</dd>

  <dt>Version 0.6.23 - 06 February 2025</dt>
  <dd>Update GN to 28973fb1.</dd>
  
  <dt>Version 0.6.22 - 05 February 2025</dt>
  <dd>Update GN to 6c72fe0c.</dd>

  <dt>Version 0.6.21 - 27 January 2025</dt>
  <dd>Update GN to 66a77c30.</dd>
  <dd>Add the option to allow ciertain hosts to bypass the Basic Auth in Apache.</dd>


  <dt>Version 0.6.20 - 19 December 2024</dt>
  <dd>Update GN to 3b75aaea.</dd>

  <dt>Version 0.6.19 - 17 December 2024</dt>
  <dd>Update GN to fe7ee40a.</dd>

  <dt>Version 0.6.18 - 12 December 2024</dt>
  <dd>Update GN to 72fa5c64.</dd>

  <dt>Version 0.6.17 - 05 December 2024</dt>
  <dd>Update GN to 8152c023.</dd>

  <dt>Version 0.6.16 - 21 October 2024</dt>
  <dd>Update GN to 4314733c.</dd>
  <dd>Record view / More like this / Add filter option.</dd>
  <dd>EEA / Editor / Fix open source and sibling panel. https://taskman.eionet.europa.eu/issues/277292</dd>

  <dt>Version 0.6.15 - 07 October 2024</dt>
  <dd>Update GN to e1fde81a. EEA / Statistical dataset / Default to EEA list of unit of measure.</dd>
  <dd>Keyword / Not capitalize and do not display thesaurus if no keywords.</dd>
  <dd>EEA / SDMX / Fix XPath for other constraints mapping.</dd>

  <dt>Version 0.6.14 - 02 October 2024</dt>
  <dd>Update GN to 3afedac5. EEA / Editor / Statistical data / Add action when missing unit of measure or ref period.</dd>
  
  <dt>Version 0.6.13 - 01 October 2024</dt>
  <dd>Update GN to b6d6d7da</dd>

  <dt>Version 0.6.12 - 12 September 2024</dt>
  <dd>Update GN to cef73a4c</dd>

  <dt>Version 0.6.11 - 12 September 2024</dt>
  <dd>Remove shareit job</dd>

  <dt>Version 0.6.10 - 12 September 2024</dt>
  <dd>Fix validator ConfigMap mount point</dd>

  <dt>Version 0.6.9 - 12 September 2024</dt>
  <dd>Add missing /etc/network/interfaces to validator pod as ConfigMap</dd>

  <dt>Version 0.6.8 - 12 September 2024</dt>
  <dd>Update validator pod privileges</dd>

  <dt>Version 0.6.7 - 10 September 2024</dt>
  <dd>Update GN to 295bd177. EEA / Thesaurus / Update ROD https://taskman.eionet.europa.eu/issues/270841</dd>

  <dt>Version 0.6.6 - 10 September 2024</dt>
  <dd>Update inspire validator image to 2024.2</dd>

  <dt>Version 0.6.5 - 10 September 2024</dt>
  <dd>Made sysctl updates optional, as the values are the default on the nodes now.</dd>
  <dd>Upgraded the postfix container.</dd>

  <dt>Version 0.6.4 - 08 August 2024</dt>
  <dd>Upgraded GN to b1adafc2.
    <ul>
      <li>EEA / Script / Add hierarchylevelname if not present https://taskman.eionet.europa.eu/issues/273346</li>
      <li>Record view / Improve layout of table (eg. quality measures)</li>
    </ul>
  </dd>

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

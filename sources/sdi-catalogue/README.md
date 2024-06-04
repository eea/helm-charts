# SDI catalogue

A csw service and front end application to search and find EEA GIS datasets.

## Releases

<dl>
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

  <dt>Version 0.4.10</dt>
  <dd>Add config_is_read_only=true to nextcloud config map</dd>

  <dt>Version 0.4.9</dt>
  <dd>Update GN image to eeacms/eea-geonetwork:8e0ad200</dd>
  
  <dt>Version 0.4.8</dt>
  <dd>Remove FTP service.</dd>

  <dt>Version 0.4.7</dt>
  <dd>Clean up apache configuration</dd>

  <dt>Version 0.4.6</dt>
  <dd>Update INSPIRE Validator to 2024.0.1</dd>

  <dt>Version 0.4.5</dt>
  <dd>Remove filebeat and metricbeat from the stack.</dd>

  <dt>Version 0.4.4</dt>
  <dd>Set kibana csp.strict property to false. Add it to values.yaml to allow config it without a new version.</dd>

  <dt>Version 0.4.3</dt>
  <dd>Remove unsupported kibana.index property from kibana 8</dd>

  <dt>Version 0.4.2</dt>
  <dd>Update GN image to eeacms/eea-geonetwork:56df1491</dd>

  <dt>Version 0.4.1</dt>
  <dd>Upgrade to postfix 1.1.0.</dd>

  <dt>Version 0.4.0</dt>
  <dd>Nextcloud logs constantly about a missing postfix name. Added now.
      Seems to have been forgotten at initial installation.</dd>

</dl>


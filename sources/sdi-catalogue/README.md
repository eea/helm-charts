# SDI catalogue

A csw service and front end application to search and find EEA GIS datasets.

## Releases

<dl>
  <dt>Version 0.3.5</dt>
  <dd>
    Update GN image to eeacms/eea-geonetwork:27fc3b4a.
    Use new GN configuration method with GN_CONFIG_PROPERTIES variable.
  </dd>

  <dt>Version 0.3.4</dt>
  <dd>Security upgrade of OpenSSL in the apache image.</dd>

  <dt>Version 0.3.3</dt>
  <dd>Removed the GDAL service.</dd>

  <dt>Version 0.3.2</dt>
  <dd>Added the ability to set an externalTrafficPolicy.</dd>

  <dt>Version 0.3.1</dt>
  <dd>Upgraded Apache image due to a security vulnerability in HTTPD 2.4.57.</dd>

  <dt>Version 0.3.0</dt>
  <dd>Can now deploy with empty volumes - except for ogcapi.
  If there is no ssl.conf the apache configuration, then one is created.
  Use serverCert to point to the official certificate, otherwise a self-signed cert will be used.</dd>

  <dt>Version 0.2.1</dt>
  <dd>Typo in geonetworkdb value.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Stopped using config map for Apache ssl.conf.</dd>

  <dt>Version 0.1.5</dt>
  <dd>Upgrade geonetwork to tag 0cb4b7263c292571f32318e75b82302b2d551201.
      Added Kibana smoketest.</dd>

  <dt>Version 0.1.4</dt>
  <dd>Removed geoserver smoke test. Metricbeat and Filebeat disabled by default.</dd>

  <dt>Version 0.1.3</dt>
  <dd>Removed geoserver.</dd>

  <dt>Version 0.1.2</dt>
  <dd>More smoke tests. Fixed service selector for nextcloud.</dd>

  <dt>Version 0.1.1</dt>
  <dd>Upgraded public-catalogue and added GEONETWORK env. variables.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>


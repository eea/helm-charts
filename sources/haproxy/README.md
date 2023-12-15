# HAProxy Docker image with docker links and reload support

This image is generic, thus you can obviously re-use it within your other EEA projects.

# Releases

<dl>

  <dt>Version 1.8-1.8</dt>
  <dd>Upgrade HAproxy to 1.8.31.</dd>

  <dt>Version 1.8-1.7</dt>
  <dd>Upgrade HAProxy to 1.8.30.</dd>
  <dd>Add `COOKIES_NAME` parameter to configure cookie name.</dd>
  <dd>Add `HTTPCHK_HOST` parameter to allow health check to include host HTTP Header - refs #20.</dd>

  <dt>Version 1.8-1.6</dt>
  <dd>Upgrade HAProxy to 1.8.29.</dd>
  <dd>Fixed code to work with new HAProxy configuration location - /usr/local/etc/haproxy/haproxy.cfg.</dd>
  <dd>Fix backend port when `DNS_ENABLED`.</dd>

  <dt>Version 1.8-1.5</dt>
  <dd>Add `COOKIES_PARAMS` variable to give the possibility to add expiration time to cookies.</dd>

  <dt>Version 1.8-1.4</dt>
  <dd>Upgrade HAproxy to 1.8.22.</dd>
  <dd>Fix `BACKENDS_MODE` typo, set the default values of `FRONTEND_MODE` and `BACKENDS_MODE` to depend on each other.</dd>
  <dd>Only enable /track_hosts cron when `BACKENDS` and `DNS_ENABLED` env vars are not present.</dd>
  <dd>Only add http check option when backend is of type http.</dd>

  <dt>Version 1.8-1.3</dt>
  <dd>Upgrade to haproxy 1.8.14</dd>
  <dd>Move the restart of rsyslog and cron to run at every docker start</dd>

  <dt>Version 1.8-1.2</dt>
  <dd>Upgrade to haproxy 1.8.13.</dd>

  <dt>Version 1.8-1.1</dt>
  <dd>Fix entrypoint to work when haproxy.cfg externally is provided.</dd>

  <dt>Version 1.8-1.0</dt>
  <dd>Upgrade to haproxy 1.8</dd>
  <dd>Possibility to change frontend/backend mode to TCP via environment variables `FRONTEND_MODE` and `BACKENDS_MODE`</dd>

</dl>


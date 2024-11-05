# Reportnet Varnish

Varnish for Reportek.

[See more](https://github.com/eea/eea.docker.varnish-reportek)

## Configuration

- `timezone` - Time zone.
- `varnishHTTPPort` - Port for HTTP traffic.
- `varnishHTTPSPort` - Port for HTTPS traffic.
- `varnishSize` - Size of the varnish cache.
- `autoKillCron` - Auto kill cron.
- `varnishCFGContent` - Content of the configuration file.
- `varnishBackend` - Backend to use.
- `varnishBackendPort` - Port of the backend.
- `varnishDNSTTL` - TTL for DNS.
- `varnishBERESPTTL` - TTL for BERESP.
- `varnishBERESPGrace` - Grace period for BERESP.
- `varnishBERESPKeep` - Keep period for BERESP.

## Releases

<dl>

  <dt>Version 0.1.5</dt>
  <dd>Updated appVersion to 7.5-1.0.</dd>

  <dt>Version 0.1.4</dt>
  <dd>Some refactoring and added component labels.</dd>

  <dt>Version 0.1.3</dt>
  <dd>Removed autoKillCron variable since, using it, causes varnish to no longer respond.</dd>

  <dt>Version 0.1.2</dt>
  <dd>Changed default port to 8080.</dd>

  <dt>Version 0.1.1</dt>
  <dd>Added enabled flag.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial release.</dd>

</dl>

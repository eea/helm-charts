# EUNIS

This chart is configured to require little or no configuration for development and test usage.

If you need to modify, then create a new .yaml file with the modifications.

For the database password, use the default values, or if you already have an existing database,
set the values in the database section.

## URL redirects

You can enable an Apache front proxy with `apache.enabled=true`.
Apache applies any `RewriteRule` directives defined in `apache.redirectConfig`
and proxies every unmatched request to the application.

The default redirect rule is stored in `apache.redirectConfig` and sends `/species/<id>`
to `https://biodiversity.europa.eu/species/<id>`. The chart also exposes this field
through `questions.yaml`, so it can be edited from the UI.

## Namespace-awareness

Since this app expects to find the database at the name `dbservice`, you can not
run two different EUNIS applications in the same namespace.

## Smoke test

You can run `helm test eunis` to verify the system is working correctly.

## Releases

### Version 2.2.2 - 1 April 2026
- remove legacy `redirects` values and keep redirect configuration only under `apache.*`

### Version 2.2.1 - 1 April 2026
- expose Apache redirect rules through the UI via `apache.redirectConfig`

### Version 2.2.0 - 1 April 2026
- move URI redirects from ingress to Apache and proxy unmatched traffic to Tomcat

### Version 2.1.1 - 12 March 2026
- eunis redirect to bise [Dobricean Ioan Dorian - [`482a698d`](https://github.com/eea/helm-charts/commit/482a698dfec01416d3f6c737b7b8865e9b283213)]

| Version | Comment |
| ------- | ------- |
| Version 2.2.2 - 1 Apr. 2026 | Removed legacy `redirects` values and kept redirect config only in `apache.*` |
| Version 2.2.1 - 1 Apr. 2026 | Added UI-editable Apache redirect rules through `apache.redirectConfig` |
| Version 2.2.0 - 1 Apr. 2026 | Moved URI redirects from ingress into an Apache front proxy with fallback to Tomcat |
| Version 2.1.0 - 12 Mar. 2026 | Added configurable ingress redirects, including EUNIS species to BISE redirects |
| Version 2.0.0 - 18 Feb. 2026 | Added optional autoscaling |
| Version 1.3.0 - 16 Feb. 2026 | Made the tomcat probes configurable |
| Version 1.2.0 - 18 Mar. 2025 | More lax network security policy for Tomcat |
| Version 1.1.1 - 8 Nov. 2024 | Removed old mariadb 5 |
| Version 1.1.0 - 7 Nov. 2024 | Added mariadb service to upgrade database |
| Version 1.0.4 - 9 Aug. 2024 | Removed default annotations for Ingress. |
| Version 1.0.3 - 9 Aug. 2024 | Added startup and readyness probes. Made them optional. |
| Version 1.0.2 | Made buildsw optional, and disabled by default. |
| Version 1.0.1 | Added security policy to deny outward connections from database. |
| Version 1.0.0 | Removed readyness probe. |
| Version 0.2.0 | Added network security policies. |
| Version 0.1.3 | First version to be used in production. |
| Version 0.1.0 | Initial version. |

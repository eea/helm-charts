# Eionet GEMET

This chart is (almost) configured for production.

## Releases

<dl>
  <dt>Version 0.5.2 - 13 August 2024</dt>
  <dd>Made it the address of the backend configurable.</dd>

  <dt>Version 0.5.1 - 13 August 2024</dt>
  <dd>Made replica count for webserver configurable.</dd>

  <dt>Version 0.5.0 - 7 August 2024</dt>
  <dd>Moved the security headers to standard Ingress annotations.</dd>

  <dt>Version 0.4.0 - 14 June 2024</dt>
  <dd>Implemented autoscaling for the gemet pod.</dd>

  <dt>Version 0.3.0</dt>
  <dd>Replaced the home-made postgres deployment with bitnami dependency.</dd>

  <dt>Version 0.2.0</dt>
  <dd>Removed mysql database, postfix, zope and zeo.</dd>

  <dt>Version 0.1.1</dt>
  <dd>Set UTF-8 and LANG environment variable on database pods.</dd>

  <dt>Version 0.1.0</dt>
  <dd>Initial version.</dd>

</dl>

## Deployment

The chart is not prepared for testing, and won't come up correctly with default values. However, the
only value to set is the `secretKey`, and can be set to a random string. For deployment in production,
set better values where you see 'REPLACEME'. You will still have an empty database though.

| Key | Description | Default |
| --- | ----------- | ------- |
| autoscaling.enabled | Turn on horisontal scaling for the gemet pod | false |
| secretKey | Used for gemet to async communication | "" |


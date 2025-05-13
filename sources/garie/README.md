# Garie Helm Chart

This chart is configured for production. Must run in its own namespace.

# What is Garie?

https://github.com/boyney123/garie/

## Highlights

- Get setup with polling performance data and out of the box dashboards within minutes.
- Setup CRON jobs to get performance data at any interval.
- Webhook support (e.g Trigger collection of performance data every release).
- Generates reports with recommended improvements for your website (Using Lighthouse)
- Historic reports. See any report that was generated in the past.
- Generates performance videos.
- Plugin Architecture using Docker

## [Docs](https://garie.io)

Quicklinks:

- [**Getting started**](https://garie.io/docs/getting-started/installation)
- [Viewing Dashboards](https://garie.io/docs/getting-started/viewing-dashboards)
- [Building your first dashboard](https://garie.io/docs/creating-your-own-dashboard/getting-started)
- [Examples of Garie](https://garie.io/docs/examples/example-list)

### Plugins

- [Lighthouse](https://github.com/eea/garie-lighthouse)
- [Pagespeed Insights](https://github.com/eea/garie-pagespeed-insights)
- [Browsertime](https://github.com/eea/garie-pagespeed-insights)
- [Linksintegrity](https://github.com/eea/garie-linksintegrity)
- [Sonarqube](https://github.com/eea/garie-sonarqube)
- [Uptimerobot](https://github.com/eea/garie-uptimerobot)
- [SSLlabs](https://github.com/eea/garie-ssllabs)
- [Privacyscore](https://github.com/eea/garie-privacyscore)
- [Securityheaders](https://github.com/eea/garie-securityheaders)
- [Sentry-metrics](https://github.com/eea/garie-sentry-metrics)
- [Webbkoll](https://github.com/eea/garie-webbkoll)

## Variables

- _Influx administrator username_ - used on influxdb
- _Influx administrator password_ - used on influxdb
- _Docker binary path_ - used by browsertime to start docker containers, default `/usr/bin/docker`
- _Grafana `admin` user password_
- _Pagespeed insights key_ - must be taked from Pagespeed API
- _Garie configuration_ - used for all plugins, must be json and respect the format common on all plugins https://github.com/eea/garie-plugin
- _Schedule frontend services on hosts with following host labels_ - Comma separated list of host labels (e.g. key1=value1,key2=value2) to be used for scheduling all the services besides influxdb
- _Schedule influxdb on hosts with following host labels_ - Comma separated list of host labels (e.g. key1=value1,key2=value2) to be used for scheduling influxdb
- _Time zone_ - default `Europe/Copenhagen`
- _Influxdb data volume driver_ - default local
- _Influxdb data volume driver options_ - used in rancher_ebs volumes to set size
- _Frontend services volumes' driver_ - use nfs if you don't want to pin the services to rancher hosts
- _Frontend services volumes' driver options_ - used in rancher_ebs volumes to set size

## Configuration

## Ingress

We have the following services that should be exposed in ingress:

- grafana:3000
- chronograf:8888
- garie-lighthouse:3000
- garie-browsertime:3000
- garie-webscore:3000

# Releases

### Version 0.0.1 - 13 May 2025
- Init Helm Chart [Silviu - [`90a5f25`](https://github.com/eea/helm-charts/commit/90a5f2581e73452324545ff3bc149b73e9006ea3)]

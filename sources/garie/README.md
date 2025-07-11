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

### Version 0.0.20 - 10 July 2025
- Lighthouse error handaling [Silviu - [`a453d205`](https://github.com/eea/helm-charts/commit/a453d20529762b91e78270d1cf477d24eb18229d)]

### Version 0.0.19 - 08 July 2025
- fix lighthouse memory issue. [Silviu - [`f03e0b9d`](https://github.com/eea/helm-charts/commit/f03e0b9dc26f63ad775f8d0db8ce886f37491672)]

### Version 0.0.18 - 07 July 2025
- update Lighthouse version 12.7.1 [Silviu - [`6f35a67e`](https://github.com/eea/helm-charts/commit/6f35a67e3b1657d1369c7293402fd39dec41d4c1)]

### Version 0.0.17 - 01 July 2025
- update checkmk [Silviu - [`4edacf7`](https://github.com/eea/helm-charts/commit/4edacf7ffc3c87da376aec3191cf3c16b8c8feb5)]

### Version 0.0.16 - 01 July 2025
- make config multiline [Silviu - [`8a95e10`](https://github.com/eea/helm-charts/commit/8a95e1059673a6bc275de96f1208398081fdbff6)]

### Version 0.0.15 - 27 June 2025
- Upgrade to eeacms/garie-lighthouse:1.2.15 [valentinab25 - [`97241fe`](https://github.com/eea/helm-charts/commit/97241fe0eb09d5d616ad7f2a3860f1d5a0cff957)]

### Version 0.0.14 - 13 June 2025
- patch ingress [Silviu - [`9098370`](https://github.com/eea/helm-charts/commit/90983704b44ff7963505d3b325951b70405bcce0)]

### Version 0.0.13 - 12 June 2025
- add rewrite [Silviu - [`11fccb7`](https://github.com/eea/helm-charts/commit/11fccb76db7bb4740a2fc547166e7ede250d088b)]

### Version 0.0.12 - 12 June 2025
- grafana config [Silviu - [`4241ad3`](https://github.com/eea/helm-charts/commit/4241ad3bc113f34d0f1471abdb515783da26fbb6)]

### Version 0.0.11 - 12 June 2025
- update grafana defaults [Silviu - [`177b46b`](https://github.com/eea/helm-charts/commit/177b46b74766e1c51764e46194cb021aa6180d45)]

### Version 0.0.10 - 12 June 2025
- update template targeting [Silviu - [`1827863`](https://github.com/eea/helm-charts/commit/18278630d012d3235d72d3c73a7ccf5afd02fc52)]

### Version 0.0.9 - 12 June 2025
- fix typo [Silviu - [`b52d9f8`](https://github.com/eea/helm-charts/commit/b52d9f8fa51a33f9b3d73470c8b189cb3a63d440)]

### Version 0.0.8 - 12 June 2025
- ingress patch [Silviu - [`6bf1ca5`](https://github.com/eea/helm-charts/commit/6bf1ca5ae8fc34add07c1edfaf7aba2dd111d257)]

### Version 0.0.7 - 12 June 2025
- update ingress rules [Silviu - [`10ed33f`](https://github.com/eea/helm-charts/commit/10ed33fe5571a7cd90eb9a561b86590a8a659f9c)]

### Version 0.0.6 - 12 June 2025
- add restricted ingress [Silviu - [`71a9822`](https://github.com/eea/helm-charts/commit/71a9822e4e6b4fbe04b893f51c71d3f57fb54a5a)]

### Version 0.0.5 - 14 May 2025
- fix influxdb pvc [Silviu - [`cc9ab94`](https://github.com/eea/helm-charts/commit/cc9ab947ec8211f5ab391567a57abccb10533c4d)]

### Version 0.0.4 - 14 May 2025
- fix typo [Silviu - [`82d988d`](https://github.com/eea/helm-charts/commit/82d988d367e2ace36252084a308ccb89a217188e)]

### Version 0.0.3 - 14 May 2025

- fix linksintegrity [Silviu - [`ab81b3b`](https://github.com/eea/helm-charts/commit/ab81b3b04f75d77f01fa86af5de69b8f8db8b897)]

### Version 0.0.2 - 14 May 2025

- add pvc annotations [Silviu - [`43aab12`](https://github.com/eea/helm-charts/commit/43aab12f37cdb4378ea48be4f991b584fff2641c)]

### Version 0.0.1 - 13 May 2025

- Init Helm Chart [Silviu - [`90a5f25`](https://github.com/eea/helm-charts/commit/90a5f2581e73452324545ff3bc149b73e9006ea3)]

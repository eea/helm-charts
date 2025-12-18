# Cachet Status page


Cachet is a beautiful and powerful open source status page system.

## Overview

- List your service components
- Report incidents
- Customise the look of your status page
- Markdown support for incident messages
- A powerful JSON API
- Metrics
- Multi-lingual
- Subscriber notifications via email
- Two factor authentication

## Documentation

- https://docs.cachethq.io/
- https://github.com/CachetHQ/Cachet
- https://github.com/CachetHQ/Docker
- https://github.com/castawaylabs/cachet-monitor


## Configuration

- "Cachet public url" - use full url
- "Cachet generated key" - generate with `php artisan key:generate`
- "Cachet api token" - API token for user used in monitor ( not the same as the generated key )
- "Cachet-monitor configuration" - https://github.com/castawaylabs/cachet-monitor#example-configuration
- "Debug enabled" - used in both cachet and cachet-monitor
- "Cachet database name" - Postgres database, used by cachet
- "Cachet database user" 
- "Cachet database password"
- "Schedule the database on hosts with following host labels" - Used for rancher-ebs and local db volume
- "Database data volume driver" - default rancher-nfs
- "Database data volume driver options" - used for netapp & ebs volumes
- "Cachet homeserver public FQDN" - Used by postfix
- "Cachet email FROM" - used in all emails sent by Cachet 
- "Cachet email name" - used in all emails sent by Cachet
- "Postfix relay", "Postfix relay port", "Postfix user", "Postfix password" - used to configure postfix server
- "Time zone"


## Releases

### Version 0.1.10 - 18 December 2025
- Release of dependent chart postfix:3.2.0 [EEA Jenkins - [`75c013a0`](https://github.com/eea/helm-charts/commit/75c013a076fc945676e4dae5e76f2bb78ef8ad79)]

### Version 0.1.9 - 25 November 2025
- Release of dependent chart postfix:3.1.2 [valentinab25 - [`d61a6b49`](https://github.com/eea/helm-charts/commit/d61a6b491e5bcc20f8f481d125cd5d9fc1a68c52)]

### Version 0.1.8 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`f75cf9b2`](https://github.com/eea/helm-charts/commit/f75cf9b2e05ca6d378cf5a9a48ac8cd30e6c8b1f)]

### Version 0.1.7 - 26 June 2025
- patch ingress headers [Silviu - [`64277d0`](https://github.com/eea/helm-charts/commit/64277d0b37b89fb783e30e81502bff6cf9bb2296)]

### Version 0.1.6 - 13 June 2025
- patch ingress snippet [Silviu - [`cf2932d`](https://github.com/eea/helm-charts/commit/cf2932df0312208cff704332c046bacc020c7f00)]

### Version 0.1.5 - 13 June 2025
- postgres fix [Silviu - [`5a4c1af`](https://github.com/eea/helm-charts/commit/5a4c1aff09694cc32e3bb543d831d7cceedeb664)]

### Version 0.1.4 - 13 June 2025
- update restricted ingress [Silviu - [`786b724`](https://github.com/eea/helm-charts/commit/786b724843f4a25c3215b1db6d770ac514ec5808)]

### Version 0.1.3 - 13 May 2025
- Fix ingress questions, values [valentinab25 - [`ffba3cd`](https://github.com/eea/helm-charts/commit/ffba3cdb7f49b7f806b71f3c1021602298e1ccf2)]

### Version 0.1.2 - 13 May 2025
- Add restricted ingress/service [valentinab25 - [`e151025`](https://github.com/eea/helm-charts/commit/e151025dbfb1a70032b56deaa34f68762168cc53)]

### Version 0.1.1 - 24 April 2025
- Questions and values fixed [valentinab25 - [`5e258ee`](https://github.com/eea/helm-charts/commit/5e258eea1e1ccc7439d58f75d9ec837c6b404003)]

### 0.1.0

- First release




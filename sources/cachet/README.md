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


## Upgrading from chart 0.1.x (Cachet v2.3, PostgreSQL 9.6)

Chart 0.2.0 runs Cachet v3 (`eeacms/cachet:3`) on PostgreSQL 17 (`eeacms/postgres:17s`). The image upgrades the v2.3 data in place on its first start ([details](https://github.com/eea/eea.docker.cachet/tree/3#upgrading-from-cachet-v23-eeacmscachet23-x)). PostgreSQL 17 cannot use the 9.6 data volume, so the database is dumped and restored into the new StatefulSet (`<release>-postgres17-ss`); the volume of the old `<release>-postgres-ss` StatefulSet is not deleted and stays as fallback.

Keep the same `APP_KEY` and `DB_PREFIX` values. Use `--reset-then-reuse-values` (Helm 3.14+): it applies the new chart defaults (images, volumes, probes) under your existing values, while `--reuse-values` would drop them. Example for release `status` in namespace `status`:

1. Dump the v2 database:

       kubectl -n status exec status-postgres-ss-0 -- pg_dump -U postgres -d cachet > cachet-v2.sql

2. Upgrade the chart with Cachet stopped, so it does not create an empty v3 database:

       helm upgrade status eea/cachet --version 0.2.0 --reset-then-reuse-values --set cachet.replicaCount=0 --set monitor.enabled=false

3. Restore the dump as the application user (the Cachet migrations alter the tables, so the user must own them), leaving out the PostgreSQL 9.6 specific, ownership and grant statements:

       grep -vE "^SET default_with_oids|^(CREATE|COMMENT ON) EXTENSION |^ALTER .* OWNER TO |^(GRANT|REVOKE) " cachet-v2.sql \
         | kubectl -n status exec -i status-postgres17-ss-0 -- env PGPASSWORD=<POSTGRES_DBPASS> \
           psql -h 127.0.0.1 -U cachet -d cachet -v ON_ERROR_STOP=1

4. Start Cachet; the log shows the `[v2-upgrade]` lines and the migrations:

       helm upgrade status eea/cachet --version 0.2.0 --reset-then-reuse-values --set cachet.replicaCount=1

5. cachet-monitor: create an API key in Dashboard -> API Keys, set it as `monitor.environment.CACHET_TOKEN` and enable the monitor again. The monitor now uses `eeacms/cachet-monitor:3` and `https://<hostname>/api`.

Rollback: `helm rollback` to the previous revision brings back the 9.6 StatefulSet on its untouched volume and the v2 image.

Uploads (the status page banner) are stored on the `<release>-cachet-uploads` volume (`cachet.datastorage`), mounted at `/var/www/html/storage/app/public`.

## Releases

### Version 1.0.0 - 23 October 2026
- Helm chart for cachet 3 [valentinab25 - [`4d2de3696`](https://github.com/eea/helm-charts/commit/4d2de3696d731df342ef598282167497248627fd)]


### Version 0.2.0 - 23 October 2026
- Upgrade to 2.3-1.4 [valentinab25 - [`fd3f21149`](https://github.com/eea/helm-charts/commit/fd3f21149a1f228b9ebbf0483d0cdb58fdafeb0d)]

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




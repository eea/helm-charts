# Matomo Helm Chart

## What is Matomo?
Matomo is a free and open source web analytics application written by a team of international developers that runs on a PHP/MySQL webserver. It tracks online visits to one or more websites and displays reports on these visits for analysis. As of September 2015, Matomo was used by nearly 900 thousand websites, or 1.3% of all websites, and has been translated to more than 45 languages. New versions are regularly released every few weeks.

You can learn more about Matomo at [https://www.matomo.org/](https://www.matomo.org/).

This Helm chart deploys Matomo, the open-source web analytics platform, on Kubernetes.

## Prerequisites

* Kubernetes 1.19+
* Helm 3.2.0+
* A Persistent Volume (PV) provisioner in your Kubernetes cluster if you intend to use persistent storage (recommended for production).

## Installing the Chart

To install the chart with the release name `my-matomo-release` in the `matomo-namespace`:

```bash
helm repo add eea https://artifactory.eea.europa.eu/artifactory/helm-charts
helm install my-matomo-release eea/matomo --namespace matomo-namespace --create-namespace
```

## Uninstalling the Chart

To uninstall the `my-matomo-release`:

```bash
helm uninstall my-matomo-release --namespace matomo-namespace
```

## Upgrading the Chart

To upgrade an existing release named `my-matomo-release` in the `matomo-namespace` to a new version of the chart, you can use the `helm upgrade` command:

```bash
helm upgrade my-matomo-release eea/matomo --namespace matomo-namespace
```

It's recommended to check the release notes for any breaking changes or specific upgrade instructions before upgrading. You may also want to back up your Matomo instance (database and persistent volume data) before performing an upgrade.

## Configurable Parameters

The following table lists the configurable parameters of the Matomo chart and their default values.

| Parameter                                           | Description                                                                                                   | Default Value                     |
|-----------------------------------------------------|---------------------------------------------------------------------------------------------------------------|-----------------------------------|
| `timezone`                                          | Time zone for the deployment (e.g. Europe/Copenhagen).                                                        | `Europe/Copenhagen`               |
| `pvc.resourcePolicyKeep`                            | If `true`, PersistentVolumeClaims are retained when the Helm release is deleted.                              | `true`                            |
| `matomo.hostname`                                   | The primary public hostname for accessing your Matomo instance.                                               | `matomo.eea.europa.eu`            |
| `matomo.image.repository`                           | Image repository for Matomo application.                                                                      | `eeacms/matomo`                   |
| `matomo.image.tag`                                  | Image tag for Matomo application.                                                                             | `5.3.2-1`                         |
| `matomo.replicaCount`                               | Number of Matomo application replicas (containers).                                                           | `1`                               |
|`matomo.username`                                   | Optional username for the Matomo default user. If not set, a default username 'user' will be used.                 | `""`                              |
| `matomo.password`                                   | Optional password for the Matomo default user. If set, it overrides the default password. Ensure this is a strong, unique password if set. | `""`                   |
| `matomo.token`                                      | Matomo API authentication token for a user with permissions to import logs. Found in Matomo Admin > Personal > API Authentication Token. | `REPLACEME`                       |
| `matomo.storage`                                    | Size of the persistent volume for Matomo data (e.g., 10Gi).                                                   | `10Gi`                            |
| `matomo.storageClassName`                           | StorageClass for Matomo persistent volume. Leave empty for default.                                           | `""`                              |
| `matomo.environment.PHP_MEMORY_LIMIT`               | PHP memory limit for Matomo website containers (e.g., 4096Mi). At least 4096Mi.                               | `4096Mi`                          |
| `matomo.environment.PHP_MAX_EXECUTION_TIME`         | PHP maximum execution time for Matomo website.                                                                | `"0"`                             |
| `matomo.environment.PHP_MAX_INPUT_TIME`             | PHP maximum input time for Matomo website.                                                                    | `"0"`                             |
| `matomo.environment.APACHE_HTTP_PORT_NUMBER`        | Apache HTTP port number for Matomo website.                                                                   | `"9080"`                          |
| `matomo.resources.requests.memory`                  | Matomo website memory requests (e.g., 2Gi). At least 2Gi.                                                     | `2Gi`                             |
| `matomo.resources.limits.memory`                    | Matomo website memory limit (e.g., 5Gi). Must be more than the PHP memory_limit.                              | `5Gi`                             |
| `mariadb.image.repository`                          | Image repository for MariaDB.                                                                                 | `mariadb`                         |
| `mariadb.image.tag`                                 | Image tag for MariaDB.                                                                                        | `10.11.11`                        |
| `mariadb.user`                                      | Username for Matomo to connect to MariaDB.                                                                    | `eea_matomo`                      |
| `mariadb.database`                                  | Database name for Matomo within MariaDB.                                                                      | `eea_matomo_db`                   |
| `mariadb.password`                                  | Password for the MariaDB user specified in `mariadb.user`.                                                    | `REPLACEME`                       |
| `mariadb.rootPassword`                              | Password for the MariaDB root user.                                                                           | `REPLACEME`                       |
| `mariadb.environment.MYSQL_ALLOW_EMPTY_PASSWORD`    | Set to `"yes"` to allow MariaDB to run with an empty root password. **Not recommended for production.**         | `"no"`                            |
| `mariadb.storage`                                   | Storage size for MariaDB persistent volume (e.g., 10Gi).                                                      | `10Gi`                            |
| `mariadb.storageClassName`                          | StorageClass for MariaDB persistent volume. Leave empty for default.                                          | `""`                              |
| `mariadb.resources.requests.memory`                 | MariaDB memory requests (e.g., 7Gi). At least 7Gi.                                                            | `7Gi`                             |
| `mariadb.resources.limits.memory`                   | MariaDB memory limit (e.g., 10Gi).                                                                            | `10Gi`                            |
| `mariadb.commands`                                  | MariaDB server startup commands.                                                                              | See `values.yaml`                 |
| `geoipupdate.image.repository`                      | Image repository for GeoIP update.                                                                            | `maxmindinc/geoipupdate`          |
| `geoipupdate.image.tag`                             | Image tag for GeoIP update.                                                                                   | `v7.1`                            |
| `geoipupdate.accountId`                             | Maxmind GeoIP account ID. Used for updating GeoIP database.                                                   | `REPLACEME`                       |
| `geoipupdate.licenseKey`                            | Maxmind license key. Used for updating GeoIP database.                                                        | `REPLACEME`                       |
| `geoipupdate.cronSchedule`                          | Cron schedule for updating GeoIP database.                                                                    | `"0 4 5 * *"`                     |
| `geoipupdate.environment.GEOIPUPDATE_EDITION_IDS`   | Which GeoIP databases to download (e.g., GeoLite2-City).                                                        | `GeoLite2-City`                   |
| `geoipupdate.environment.GEOIPUPDATE_VERBOSE`       | Enable verbose output for GeoIP update process (e.g., "1" for true, "0" for false).                             | `"1"`                             |
| `geoipupdate.storage`                               | Size of the persistent volume for GeoIP data (e.g., 1Gi).                                                     | `1Gi`                             |
| `geoipupdate.storageClassName`                      | StorageClass for GeoIP update persistent volume. Leave empty for default.                                     | `""`                              |
| `geoipupdate.resources.requests.memory`             | Memory requests for GeoIP update container.                                                                   | `NODATA`                          |
| `geoipupdate.resources.limits.memory`               | Memory limits for GeoIP update container.                                                                     | `NODATA`                          |
| `postfix.image.repository`                          | Image repository for Postfix.                                                                                 | `eeacms/postfix`                  |
| `postfix.image.tag`                                 | Image tag for Postfix.                                                                                        | `3.5-1.0`                         |
| `postfix.user`                                      | User for Postfix.                                                                                             | `postfix`                         |
| `postfix.password`                                  | Password for Postfix user.                                                                                    | `REPLACEME`                       |
| `postfix.relay`                                     | Relay host for Postfix to send emails.                                                                        | `ironports.eea.europa.eu`         |
| `postfix.port`                                      | Port for Postfix relay.                                                                                       | `8587`                            |
| `postfix.environment.TZ`                            | Timezone for Postfix container.                                                                               | `Europe/Copenhagen`               |
| `postfix.resources.requests.memory`                 | Postfix memory requests.                                                                                      | `256Mi`                           |
| `postfix.resources.limits.memory`                   | Postfix memory limits.                                                                                        | `256Mi`                           |
| `matomocronArchive.image.repository`                | Image repository for Matomo archive cronjob.                                                                  | `eeacms/matomo`                   |
| `matomocronArchive.image.tag`                       | Image tag for Matomo archive cronjob.                                                                         | `5.3.2-1`                         |
| `matomocronArchive.cronSchedule`                    | Cron schedule for Matomo archiving job.                                                                       | `"5 * * * *"`                     |
| `matomocronArchive.environment.PHP_MEMORY_LIMIT`    | PHP memory limit for Matomo archive containers (e.g., 7168Mi). At least 7168Mi.                               | `7168Mi`                          |
| `matomocronArchive.environment.PHP_MAX_EXECUTION_TIME` | Maximum execution time for PHP scripts in archive cronjob (0 for unlimited).                                  | `0`                               |
| `matomocronArchive.environment.PHP_MAX_INPUT_TIME`  | Maximum input time for PHP scripts in archive cronjob (0 for unlimited).                                    | `0`                               |
| `matomocronArchive.resources.requests.memory`       | Matomo archive container memory requests (e.g., 4Gi). At least 4Gi.                                           | `4Gi`                             |
| `matomocronArchive.resources.limits.memory`         | Matomo archive memory limit (e.g., 6Gi). Must be more than its PHP memory_limit.                              | `6Gi`                             |
| `matomocronLdapSync.image.repository`               | Image repository for Matomo LDAP synchronization job.                                                         | `eeacms/matomo`                   |
| `matomocronLdapSync.image.tag`                      | Image tag for Matomo LDAP synchronization job.                                                                | `5.3.2-1`                         |
| `matomocronLdapSync.cronSchedule`                   | Cron schedule for Matomo LDAP synchronization job.                                                            | `"10 1 * * *"`                    |
| `matomocronLdapSync.resources.requests.memory`      | Matomo LDAP sync job memory requests.                                                                         | `256Mi`                           |
| `matomocronLdapSync.resources.limits.memory`        | Matomo LDAP sync job memory limits.                                                                           | `256Mi`                           |
| `matomocronDeleteData.image.repository`             | Image repository for Matomo delete old raw data job.                                                          | `eeacms/matomo`                   |
| `matomocronDeleteData.image.tag`                    | Image tag for Matomo delete old raw data job.                                                                 | `5.3.2-1`                         |
| `matomocronDeleteData.cronSchedule`                 | Cron schedule for Matomo delete old raw data job.                                                             | `"0 23 * * *"`                    |
| `matomocronDeleteData.environment.PHP_MEMORY_LIMIT` | PHP memory limit for the delete old raw data job.                                                             | `512Mi`                           |
| `matomocronDeleteData.environment.siteToDelete`     | ID of the site for which to delete old raw data. Set to 'all' to delete for all sites.                        | `"22"`                            |
| `matomocronDeleteData.environment.daysToKeep`       | Number of days to keep raw visitor log data.                                                                  | `90`                              |
| `matomocronDeleteData.resources.requests.memory`    | Matomo delete data container memory requests (e.g., 512Mi). At least 512Mi.                                   | `512Mi`                           |
| `matomocronDeleteData.resources.limits.memory`      | Matomo delete data container memory limit (e.g., 2Gi). Must be more than requests.                            | `2Gi`                             |
| `rsyncAnalytics.image.repository`                   | Image repository for rsync analytics.                                                                         | `eeacms/rsync`                    |
| `rsyncAnalytics.image.tag`                          | Image tag for rsync analytics.                                                                                | `2.6`                             |
| `rsyncAnalytics.cronSchedule`                       | Cron schedule for rsync analytics log import job.                                                             | `"5 * * * *"`                     |
| `rsyncAnalytics.storage`                            | Size of the persistent volume for rsync analytics import (e.g., 1Gi).                                         | `1Gi`                             |
| `rsyncAnalytics.storageClassName`                   | StorageClass for rsync analytics persistent volume. Leave empty for default.                                  | `""`                              |
| `rsyncAnalytics.rsyncCommands`                      | Rsync command(s) to fetch logs. Example: `rsync -avz user@source:/logs/ /analytics/logs/1`.                   | `"rsync -e 'ssh -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' -avz --delete root@<IP>:<LOG_LOCATION_REMOTE> /analytics/logs/<SITE_ID>"` |
| `rsyncAnalytics.ssh_id_rsa`                         | SSH private key (id_rsa) for rsync. Paste your SSH private key. This is used for secure rsync operations.     | `REPLACEME`                       |
| `rsyncAnalytics.ssh_id_rsa_pub`                     | SSH public key (id_rsa.pub) for rsync. Paste the corresponding public key. Optional.                          | `REPLACEME`                       |
| `rsyncAnalytics.ssh_known_hosts`                    | Known Hosts content for rsync. Optional known_hosts content for verifying SSH targets.                        | `REPLACEME`                       |
| `rsyncAnalytics.ssh_config`                         | SSH Config content for rsync. Optional custom SSH config file contents.                                       | `REPLACEME`                       |
| `matomoAnalytics.image.repository`                  | Image repository for Matomo log analytics importer.                                                           | `eeacms/matomo-log-analytics`     |
| `matomoAnalytics.image.tag`                         | Image tag for Matomo log analytics importer.                                                                  | `2.4`                             |
| `matomoAnalytics.cronSchedule`                      | Cron schedule for Matomo log analytics importer job.                                                          | `"30 0 * * *"`                    |
| `matomoAnalytics.resources.requests.memory`         | Matomo log analytics job memory requests.                                                                     | `512Mi`                           |
| `matomoAnalytics.resources.limits.memory`           | Matomo log analytics job memory limits.                                                                       | `1Gi`                             |

*Note: For parameters with `REPLACEME` as the default value, you must provide a value during installation.*
*Note: For `mariadb.commands` the default value is an array, please refer to `values.yaml` for the exact content.*
*Note: `NODATA` for memory requests/limits means that no specific request/limit is set by default.*

# Backup & recovery

## Backup

Before any major changes on the matomo application, you need to backup the configuration, the database and, if applicable, the plugins.

### Configuration backup

On any matomo container:

     $ cp /bitnami/matomo/config/config.ini.php /bitnami/backup/config.ini.php.$( date +%F )

or, if you prefer to have the time included:

     $ cp /bitnami/matomo/config/config.ini.php /bitnami/backup/config.ini.php.$( date +%F.%T ) 

### Plugins backup

On any matomo container:

     $ cp -r /bitnami/matomo/plugins /bitnami/plugins.$( date +%F )

or, if you prefer to have the time included:

     $ cp -r /bitnami/matomo/plugins /bitnami/plugins.$( date +%F.%T )



### Lock database ( enable maintenance mode)

To stop all writing in the database you need to:

#### *Disable tracking* - no new pages will be added to matomo. 


This needs to be present in the configuration:

```
             [Tracker]
             record_statistics = 0
```

The `record_statistics` line was added in the configuration with the default value(1) to make it's disabling easier:

     $ sed -i 's/^record_statistics.*/record_statistics = 0/' /bitnami/matomo/config/config.ini.php
     $ grep record_statistics /bitnami/matomo/config/config.ini.php

#### *Disable UI* - the UI will have a maintenance message so it will not be available.

This needs to be present in the configuration:

```
             [General]
             maintenance_mode = 1
```

The `maintenance_mode` line was added in the configuration with the default value (0) to make it's disabling easier:

     $ sed -i 's/^maintenance_mode.*/maintenance_mode = 1/' /bitnami/matomo/config/config.ini.php
     $ grep maintenance_mode /bitnami/matomo/config/config.ini.php

#### *Restart* the container(s) to apply the change.

#### Check

- *Tracking* - `/piwik.php` will respond with HTTP 503
- *UI* - `/index.php?module=API&method=API.getPiwikVersion`  will respond with HTTP 503


### Database backup -

On the mariadb container:


    $ mysqldump -p eea_matomo_db > /bitnami/sqldump.$(date +%F ).sql
      Enter password:

After you provide the root password, you will have the current database dump saved in the /bitnami volume.

Another solution is to use `rsync` on the /bitnami volume -  https://mariadb.com/kb/en/library/incremental-backup-and-restore-with-mariadb-backup/ or `mariabackup` utility - https://mariadb.com/kb/en/library/incremental-backup-and-restore-with-mariadb-backup/ 


## Recovery

### Database restore

#### Empty database, if necessary

On the mariadb container:

   $ mysql -p
     $ drop database eea_matomo_db;
     $ create database eea_matomo_db;

#### Restore database:

On the mariadb container:

   $ mysql -p eea_matomo_db < /bitnami/sqldump.<DATE>.sql

### Restore matomo data

When making changes in the /bitnami directory in the container, make sure that the correct permisions are given:

    $ chmod -R 755 /bitnami
    $ chown -R daemon:daemon /bitnami


#### Restore configuration

Matomo configuration is stored in `/bitnami/matomo/config/config.ini.php`. If you changed any configuration regarding the database connection, you will need to manually update the restored file.

#### Restore other matomo data

1. Plugins - plugins are saved in `/bitnami/matomo/plugins` directory 
2. Logo - the logo files are saved in `/opt/bitnami/matomo/misc/user`
3. Geolite database - either you download it manually, or restore it in `/opt/bitnami/matomo/misc` ( this location is  a volume )

### Disable maintenace mode - enable database writing

#### *Enable tracking* - new pages will be added to matomo.

This should to be present in the configuration:

```
             [Tracker]
             record_statistics = 1
```

The `record_statistics` line was added in the configuration with the default value(1) to make it's enabling/disabling easier:

     $ sed -i 's/^record_statistics.*/record_statistics = 1/' /bitnami/matomo/config/config.ini.php
     $ grep record_statistics /bitnami/matomo/config/config.ini.php

#### *Enable UI* - the UI will be available.

This should to be present in the configuration:

```
             [General]
             maintenance_mode = 0
```

The `maintenance_mode` line was added in the configuration with the default value (0) to make it's disabling easier:

     $ sed -i 's/^maintenance_mode.*/maintenance_mode = 1/' /bitnami/matomo/config/config.ini.php
     $ grep maintenance_mode /bitnami/matomo/config/config.ini.php

#### *Restart* the container(s) to apply the change.

#### Check 

- *Tracking* - `/piwik.php` will respond with HTTP 200
- *UI* - `/index.php?module=API&method=API.getPiwikVersion`  will respond with HTTP 200


## Log Analytics Import

This Helm chart provides components to facilitate importing web server logs into Matomo for analysis. This is primarily handled by the `rsyncAnalytics` and `matomoAnalytics` cronjobs.

**Overview:**

1.  **Rsync Logs (`rsyncAnalytics`):** A cronjob (`rsyncAnalytics.cronSchedule`) periodically fetches logs from a remote server using rsync over SSH. These logs are stored in a persistent volume (`rsyncAnalytics.storage`).
2.  **Import Logs (`matomoAnalytics`):** Another cronjob (`matomoAnalytics.cronSchedule`) processes the fetched logs and imports them into Matomo using Matomo's log import scripts.

**Configuration:**

To enable and configure log analytics import, you will need to set several parameters in your `values.yaml` or during Helm installation:

*   **`rsyncAnalytics.cronSchedule`**: Sets the schedule for the rsync job (fetching logs).
*   **`rsyncAnalytics.rsyncCommands`**: Defines the rsync command(s) to execute. This is where you specify the source server, paths, and destination within the `/analytics/logs/<SITE_ID>` directory on the PVC.
    *   *Example*: `"rsync -e 'ssh -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' -avz --delete user@source-server.com:/path/to/logs/ /analytics/logs/1"` (replace `<SITE_ID>` with the target Matomo site ID).
*   **`rsyncAnalytics.storage`**: Size of the PVC for storing fetched logs.
*   **`rsyncAnalytics.storageClassName`**: (Optional) Storage class for the rsync PVC.
*   **SSH Configuration for Rsync:**
    *   `rsyncAnalytics.ssh_id_rsa`: The private SSH key (base64 encoded or direct multiline string) for the rsync job to connect to your log server. **This is mandatory for rsync to work.**
    *   `rsyncAnalytics.ssh_id_rsa_pub`: (Optional) The corresponding public SSH key.
    *   `rsyncAnalytics.ssh_known_hosts`: (Optional) Content for the `known_hosts` file to verify the SSH remote.
    *   `rsyncAnalytics.ssh_config`: (Optional) Custom SSH configuration for the rsync job.
*   **`matomoAnalytics.cronSchedule`**: Sets the schedule for the Matomo log import job.
*   **`matomo.token`**: The Matomo authentication token (auth token) for a user with appropriate permissions to import logs and write analytics data. This token is used by the log import scripts. You can find this in Matomo under 'Administration' -> 'Personal' -> 'API Authentication Token'.
*   **`logsHostLabels`**: (Optional) Allows you to schedule the Matomo Analytics (log import) jobs on specific nodes using host labels.

**Workflow:**

## Setting up log import flows

### Create a generic user that will be used to import logs, skip if already exists
Note the user name and password.

### Create separate site to import the logs to
Note the new site id, it will be used in the job configuration. Give the analytics user *write* access to it

### Prepare a remote rsync server with access to the logs
Make sure you add the ssh key from the existing *rsync-analytics* to the rsync server ( can be seen in docker logs). Note the location of the logs. Make sure you have access to it from the *rsync-analytics* container. Test:
     $ ssh -p 2222 <IP>


### Modify the exising Rsync commands variable to include the new flow
Add a new shell command. Should be in  the format:
     rsync -e 'ssh -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' -avz --delete root@<IP>:<LOG_LOCATION_REMOTE> /analytics/logs/<NEW_SITE_ID>
   
   This command will be run every hour, make sure that the rsync server does not take the current, incomplete log.

### Matomo log import
https://github.com/eea/eea.docker.matomo-log-analytics
You don't need to change anything on this container, it should work by having the logs located in the new <SITE_ID> directory. This job will run every hour and will import all unprocessed ( or unsuccesfully processed) logs found in /analytics/logs/<SITE>/*


## Releases

### Version 1.3.1 - 18 December 2025
- Release of dependent chart postfix:3.2.0 [EEA Jenkins - [`5e02f7d4`](https://github.com/eea/helm-charts/commit/5e02f7d414b77326cbc0eec5a6e0b3788b959975)]

### Version 1.3.0 - 30 October 2025
- Automated release of [eeacms/matomo:5.5.1-1](https://github.com/eea/eea.docker.matomo/releases) [EEA Jenkins - [`adfb6819`](https://github.com/eea/helm-charts/commit/adfb68190e3ca633175e1ee3c025ef6c1b960f0e)]

### Version 1.2.1 - 09 October 2025
- Remove replica count so it keeps on upgrade [valentinab25 - [`2928b79a`](https://github.com/eea/helm-charts/commit/2928b79ae90150c1722f76dcd36edb7da2cecddc)]

### Version 1.2.0 - 08 October 2025
- Automated release of [eeacms/matomo:5.4.0-2](https://github.com/eea/eea.docker.matomo/releases) [EEA Jenkins - [`f166cc9d`](https://github.com/eea/helm-charts/commit/f166cc9de2872a0c8f55ca204e7d4768fdfb54be)]

### Version 1.1.0 - 26 September 2025
- Automated release of [eeacms/matomo:5.4.0-1](https://github.com/eea/eea.docker.matomo/releases) [EEA Jenkins - [`c5a1c96f`](https://github.com/eea/helm-charts/commit/c5a1c96f6c983c2b2e875d47f0d9396a799d7f1a)]

### Version 1.0.17 - 15 September 2025
- Add missing update script [valentinab25 - [`55f7c2c7`](https://github.com/eea/helm-charts/commit/55f7c2c7dd6297f36f24881b7a66e4f8d13ea68d)]

### Version 1.0.16 - 29 August 2025
- Set job history to 1 fail, 1 succ [valentinab25 - [`9ca15bb1`](https://github.com/eea/helm-charts/commit/9ca15bb1132424e66a58b72190d71de8471046fa)]

### Version 1.0.15 - 28 August 2025
- Add annotations with IP to checkmk [valentinab25 - [`0eafb235`](https://github.com/eea/helm-charts/commit/0eafb23592aa99e1d84f2b11181404cb4e44c943)]

### Version 1.0.14 - 28 August 2025
- fix backoffLimit [valentinab25 - [`ca677e31`](https://github.com/eea/helm-charts/commit/ca677e314af4dfcaa75b75eb799ea8706ed3181b)]

### Version 1.0.13 - 28 August 2025
- Fix port checkmk [valentinab25 - [`bae02b10`](https://github.com/eea/helm-charts/commit/bae02b10601184bf8241c3af8bfbb930c9ed15df)]

### Version 1.0.12 - 28 August 2025
- Refactor images, mariadb service [valentinab25 - [`860408dd`](https://github.com/eea/helm-charts/commit/860408ddf68136eff5c3b313f1670622b1e79cd9)]

### Version 1.0.11 - 28 August 2025
- Added Entra ID user sync in ldapsync [miahi - [`7d8f0b68`](https://github.com/eea/helm-charts/commit/7d8f0b689fe96461f3b63913cd528d2f4dfeec7f)]

### Version 1.0.10 - 27 August 2025
- Add backoffLimit to not restart archiving [valentinab25 - [`0c8ba7b7`](https://github.com/eea/helm-charts/commit/0c8ba7b772389c0d7f204f6b430e102297cf1574)]

### Version 1.0.9 - 27 August 2025
- Fix configuration storage [valentinab25 - [`125522d3`](https://github.com/eea/helm-charts/commit/125522d3f782f8197c31af78d93e39b71fb27b6c)]

### Version 1.0.8 - 27 August 2025
- Fix typo [valentinab25 - [`df00ce4f`](https://github.com/eea/helm-charts/commit/df00ce4f6c90f62bc4e8abf4fa8bc01df5e156a1)]

### Version 1.0.7 - 27 August 2025
- Remove secrets [valentinab25 - [`aebfeebf`](https://github.com/eea/helm-charts/commit/aebfeebf143ff37ab456753781f1f0170c3a7f35)]

### Version 1.0.6 - 27 August 2025
- add tmp volume for archive [valentinab25 - [`cf22209b`](https://github.com/eea/helm-charts/commit/cf22209bad6f867c9747678279f17b330ec3b52c)]

### Version 1.0.5 - 27 August 2025
- Move healthchecks to values [valentinab25 - [`cb093518`](https://github.com/eea/helm-charts/commit/cb093518f8a8fa90b587a352f389a94a7bff62c7)]

### Version 1.0.4 - 25 August 2025
- Release of dependent chart postfix:3.1.0 [EEA Jenkins - [`e4261cca`](https://github.com/eea/helm-charts/commit/e4261cca8271ffef5569c30648a2f57901398dd6)]

### Version 1.0.3 - 25 August 2025
- Fix healthchecks [valentinab25 - [`50273c72`](https://github.com/eea/helm-charts/commit/50273c72968de0420e349681921f895ab35cd966)]

### Version 1.0.2 - 30 July 2025
- Update variables [valentinab25 - [`4b5e7d19`](https://github.com/eea/helm-charts/commit/4b5e7d1974b125b141a9d8c96d747f09afaeeddc)]

### Version 1.0.1 - 30 July 2025
- Small fixes [valentinab25 - [`1ec14065`](https://github.com/eea/helm-charts/commit/1ec14065fa01197e6d6f328e9df9965780771d21)]

### Version 1.0.0
- First draft

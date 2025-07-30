# Rsync

This helm chart deploys a rsync server and/or rsync client

Based on [www-sync](https://github.com/eea/eea.rancher.catalog/tree/master/infra-templates/www-sync)

Using [eeacms/rsync](https://github.com/eea/eea.docker.rsync) docker image



## Mounting persistent volumes

The `mounts` value is a comma separated list of Persistent Volume Claims that will be mounted
under /mnt. The volume claims must exist already.

## Rsync Server 

Enable server, choose how to expose it and under what port, add ssh keys


## Rsync client

Enable client, add crontab with rsync jobs, if needed


## Releases

### Version 1.0.3 - 30 July 2025
- Add NodePort/LB variables [valentinab25 - [`246cbe24`](https://github.com/eea/helm-charts/commit/246cbe24fef1e7d3ef8be8e0b69be9947fa30608)]

### Version 1.0.2 - 08 July 2025
- Use 2.7 version [valentinab25 - [`97b52fd3`](https://github.com/eea/helm-charts/commit/97b52fd319e4e970ba477f24003e2094726cd148)]

### Version 1.0.1 - 07 July 2025
- Fix questions [valentinab25 - [`0dd9368d`](https://github.com/eea/helm-charts/commit/0dd9368d1da562cfde72a36307288739183fa663)]


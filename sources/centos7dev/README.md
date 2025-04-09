# ALMA 9 linux (Formerly CentOS 7)

This helm chart deploys a single pod with an ALMA Linux image, which can be used for administration, or as a subchart in another helm chart.

## Mounting persistent volumes

The `mounts` value is a list of Persistent Volume Claims that will be mounted
under /mnt. The volume claims must exist already.

## Releases

| Version | Note |
| ------- | ---- |
| Version 1.0.7 - 09 April 2025 | User-defined arguments to the entrypoint. |
| Version 1.0.6 - 04 November 2024 | Use indexed name to allow mounts longer than 63 chars. |
| Version 1.0.5 - 10 September 2024 | Allow mounts to be specified as comma-separated list. |
| Version 1.0.4 - 10 September 2024 | Added questions.yaml from [Rancher documentation](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/helm-charts-in-rancher/create-apps) |
| Version 1.0.3 - 4 September 2024 | Upgrade to AlmaLinux 9.4. |
| Version 1.0.2 | Added ldap clients. |
| Version 1.0.1 | Fixed typo in network security policy. |
| Version 1.0.0 | Migrated to ALMA Linux 9.3 as CentOS has not been maintained by Redhat for a couple of years.  Added network security policy that blocks inter-namespace traffic. |

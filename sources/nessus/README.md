# Nessus Scanner

This is a scanner that contacts Tenable.io for work. It uses the [Tenable Nesus](https://hub.docker.com/r/tenable/nessus) image. Read more at [Tenable Documentation](https://docs.tenable.com/agent/Content/getting-started.htm#About-Tenable-Agents).

## Prerequisites

Tenable.io linking key.

## Releases

| Version | Date | Comment |
| ------- | -----| ------- |
| 1.1.2 | 26 August 2025 | Upgrade image to 10.9.3-oracle. |
| 1.1.1 | 10 August 2025 | Upgrade image to 10.9.2-oracle. |
| 1.1.0 | 10 July 2025 | Upgrade image to 10.9.0-oracle. |
| 1.0.2 | 3 July 2025 | More options via environment variables. |
| 1.0.1 | 2 July 2025 | Use Tenable's other image (10.8.4-oracle). |
| 1.0.0 | 18 June 2025 | Use Tenable's official image (10.8.4-ubuntu). |
| 0.3.0 | 14 Jan 2025 | Increased Nessus image version (AlmaLinux 9 image used). |
| 0.2.9 | 12 Nov 2024 | Increased Nessus image version (AlmaLinux updates applied). |
| 0.2.8 | 1 Oct. 2024 | Increased Nessus image version. |
| 0.2.7 | 30 Sept. 2024 | Added questionnaire. |
| 0.2.6 | 2 Sept. 2024 | Updated image for the Nessus scanner container. |
| 0.2.5 | | Declared for documentation purpose that Nessus opens port 8834. |
| 0.2.4 | | Changed image source to Alma8 based Nessus container. |

## Variables

| Name | Default | Label | Description |
| ---- | ------- | ----- | ----------- |
| linkingKey | "" | Nessus Agent linking key | You must retrieve the agent linking key from Tenable Vulnerability Management |
| listentoHostport | false | Use the host's network namespace | The pod will see the current node's network, not the Kubernetes-internal network. |
| scannerName | "" | Scanner name | Defaults to release name. |
| adminName | "" | Administrator name | Username for admin user creation. If not provided, defaults to admin.   |
| adminPwd | "" | Administrator password | Password for admin user creation. If not provided, a password will be generated. |
| autoUpdate | "all" | "Automatic update" | Sets whether Tenable Nessus should automatically receive updates. |
| managerHost | "cloud.tenable.com" | "Manager host" | The hostname or IP address of the manager. By default, the hostname is cloud.tenable.com. |
| managerPort | "443" | "Manager port" | The port of the manager. By default, the port is 443. |

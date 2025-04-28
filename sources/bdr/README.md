# Reportnet BDR

The Business Data Repository is part of the Reportnet architecture. The Business Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Network Security Policies

This Helm chart deploys Kubernetes Network Policies to enhance the security of the CDR application. If `defaultNetworkPolicyDeny` is enabled, these policies enforce a **whitelist** approach, meaning that network traffic is only allowed if explicitly permitted.

**Key Network Policy Configurations:**

*   **Instance Pod Egress (`instance.networkPolicy.egress` in `values.yaml`):**  Configures outbound traffic from the `cdr-instance` pods. You can configure egress rules in two ways:

    1. Using `ipBlockRules`: Define IP-based rules with specific ports for each CIDR block:
    ```yaml
    instance:
      networkPolicy:
        egress:
          ipBlockRules:
            - cidr: 10.50.4.0/24  # Legacy service network
              ports:
                - protocol: TCP
                  port: 443     # HTTPS
                - protocol: TCP
                  port: 80      # HTTP
            - cidr: 10.50.5.0/24  # Another network
              ports:
                - protocol: TCP
                  port: 5432    # PostgreSQL
    ```

    2. Using `rawRules`: For more complex scenarios, define individual egress rules using the full power of Kubernetes NetworkPolicy `to` specifications:
    ```yaml
    instance:
      networkPolicy:
        egress:
          rawRules:
            - to:
                - namespaceSelector:
                    matchLabels:
                      kubernetes.io/metadata.name: other-namespace
                  podSelector:
                    matchLabels:
                      app.kubernetes.io/name: service-name
              ports:
                - port: 8080
                  protocol: TCP
    ```

    You can use `rawRules` to define:
    *   **IP Block Rules:** Target egress traffic to specific IP address ranges
    *   **Namespace Selector Rules:** Target pods in other namespaces based on namespace labels and pod labels
    *   **Pod Selector Rules:** Target pods within the same namespace based on pod labels
    *   **Service Account Selector Rules (Advanced):** Target pods based on their service accounts

*   **Default Deny Policies:** The chart includes deny Network Policies (`netsecpol-ingress-default.yaml` and `netsecpol-egress-default.yaml`) that, when enabled with `defaultNetworkPolicyDeny.enabled: true`, block all ingress and egress traffic unless overridden by more specific policies. This ensures a secure starting point and encourages explicit definition of allowed traffic.

**Modifying Network Policies:**

To customize the network policies, you should modify the `instance.networkPolicy.egress` sections within your `values.yaml` file.  Refer to the Kubernetes Network Policy documentation for details on how to define rules using `ipBlock`, `namespaceSelector`, `podSelector`, ports, and protocols.

## Values

### rabbitmq
This can be used to set the rabbitmq host to be used.

## Releases

### Version 0.21.1 - 28 April 2025
- Updated rn-bdr-european-registry to 0.1.14 [Diana Boiangiu - [`505ceca`](https://github.com/eea/helm-charts/commit/505cecab3027b54d898dd988a021d7983c2c2781)]

### Version 0.21.0 - 17 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-233](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`d93e490`](https://github.com/eea/helm-charts/commit/d93e49023b83d2d6f4b10990e78445fe52d17c28)]

### Version 0.20.0 - 16 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-232](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`d6d2251`](https://github.com/eea/helm-charts/commit/d6d2251fdd69ab9965702c29b7b13cf93be629b9)]

### Version 0.19.0 - 16 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-231](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`202e898`](https://github.com/eea/helm-charts/commit/202e89855aacc7f6fbf090fccca3d95ab208912a)]

### Version 0.18.0 - 15 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-230](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`c494f5e`](https://github.com/eea/helm-charts/commit/c494f5efbd27b6c3112a6e785d83ce425302ce55)]

### Version 0.17.1 - 15 April 2025
- Updated rn-bdr-registry-notifications version to 0.2.1
- Updated rn-bdr-european-registry to 0.1.13 [Diana Boiangiu - [`dd973ea`](https://github.com/eea/helm-charts/commit/dd973ea649060121386872bcc198d5350522b6c0)]

### Version 0.17.0 - 15 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-229](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`710291a`](https://github.com/eea/helm-charts/commit/710291abd183d37bc27ee709e8efea56e1f15a16)]

### Version 0.16.0 - 14 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-228](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`379f602`](https://github.com/eea/helm-charts/commit/379f6026e7969f2034615ff594debb31366811e1)]

### Version 0.15.0 - 11 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-227](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`71b12c6`](https://github.com/eea/helm-charts/commit/71b12c6a17f1fd917affcacc1cee14243f055469)]

### Version 0.14.0 - 11 April 2025
- Updated rn-bdr-registry-notifications version to 0.2.0
- Updated rn-bdr-registry version to 0.2.0
- Updated rn-bdr-european-registry to 0.1.12 [Diana Boiangiu - [`34ce539`](https://github.com/eea/helm-charts/commit/34ce539944c11b6c9dde55d9da54c245de2d75ab)]

### Version 0.13.0 - 10 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-226](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`091b726`](https://github.com/eea/helm-charts/commit/091b726e8c95adc8cdda677c466cc63646ceb25f)]

### Version 0.12.0 - 01 April 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-225](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`a10d9ba`](https://github.com/eea/helm-charts/commit/a10d9bae8fff0934cd5bae4293023182ab4f4a05)]

### Version 0.11.0 - 31 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-224](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`ac5f0fb`](https://github.com/eea/helm-charts/commit/ac5f0fb8ef217a6e8c6aaa83c9ec08993f260b58)]

### Version 0.10.0 - 25 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-223](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`8021171`](https://github.com/eea/helm-charts/commit/8021171028844862011148b266c2caa8650f28cb)]

### Version 0.9.0 - 25 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-222](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`d30bd18`](https://github.com/eea/helm-charts/commit/d30bd1860cee0820316d50dbc3bea6c01c8c9aa7)]

### Version 0.8.2 - 24 March 2025
- Added zeoClientCacheSize, zeoClientBlobCacheSize, sessionManagerTimeout env variables

### Version 0.8.1 - 24 March 2025
- Added blobstorage volume for blobcache

### Version 0.8.0 - 21 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-221](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`37589ea`](https://github.com/eea/helm-charts/commit/37589ea9caec5e472dd27a59f8d14f925de667e6)]

### Version 0.7.0 - 20 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-220](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`c7285ad`](https://github.com/eea/helm-charts/commit/c7285ad6d5a582f49bdde13ec12e766ee75fcae5)]

### Version 0.6.0 - 20 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-219](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`65486ac`](https://github.com/eea/helm-charts/commit/65486acc8324f943a6926608e011a5e6efc0ac68)]

### Version 0.5.0 - 20 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-218](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`c48ac0a`](https://github.com/eea/helm-charts/commit/c48ac0aff68ea40e07a842f7c7c6c93a540926b4)]

### Version 0.4.0 - 19 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-217](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`9a0a375`](https://github.com/eea/helm-charts/commit/9a0a375f6f64ae285e4d54a681beecc569f577a5)]

### Version 0.3.0 - 18 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-216](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`44c9394`](https://github.com/eea/helm-charts/commit/44c9394bbfd2627e34888b9e9aa16b8b9ef55a4c)]

### Version 0.2.4 - 18 March 2025
- Removed most cpu limits except for clamav

### Version 0.2.3 - 18 March 2025
- Updated appVersion to 5.9.4-215

### Version 0.2.2 - 17 March 2025
- Updated rn-bdr-european-registry to 0.1.11

### Version 0.2.1 - 14 March 2025
- Added event and access log levels

### Version 0.2.0 - 14 March 2025
- Automated release of [eeacms/reportek-bdr:5.9.4-214](https://github.com/eea/eea.docker.reportek.bdr-instance/releases) [EEA Jenkins - [`3857afd`](https://github.com/eea/helm-charts/commit/3857afdddfde280379db019af437ca7ccfd2018d)]

### Version 0.1.64
- Updated rn-bdr-european-registry to 0.1.10

### Version 0.1.63
- Updated rn-bdr-european-registry to 0.1.9

### Version 0.1.62
- Updated rn-bdr-european-registry to 0.1.8

### Version 0.1.61
- Updated appVersion to 5.9.4-211.

### Version 0.1.60
- Updated appVersion to 5.9.4-209.
- Added european-registry-sync to be used for cronjobs sync offloading.

### Version 0.1.55
- Updated appVersion to 5.9.4-208.

### Version 0.1.54
- Updated rn-bdr-european-registry to 0.1.7

### Version 0.1.53
- Updated appVersion to 5.9.4-206.

### Version 0.1.52
- Added security policy for redis.

### Version 0.1.51
- Updated appVersion to 5.9.4-205.

### Version 0.1.50
- Added support for customizing the network policies.
- Updated rn-bdr-registry to 0.1.7.
- Updated rn-bdr-registry-notifications to 0.1.7.
- Updated rn-apache to 0.1.8.
- Updated rn-bdr-ldap to 0.1.2.
- Updated rn-clamav to 0.1.8.
- Updated rn-zeoserver to 0.1.9.

### Version 0.1.40
- Updated rn-bdr-european-registry to 0.1.6

### Version 0.1.39
- Updated rn-bdr-registry to 0.1.7

### Version 0.1.38
- Grouped apache resources config options in questions, in the Apache group.
- Made zeopack curl request verbose.

### Version 0.1.37
- Added apache resources config options in questions and values.

### Version 0.1.36
- Updated appVersion to 5.9.4-204.
- Updated rn-bdr-registry to 0.1.5.

### Version 0.1.35
- Updated appVersion to 5.9.4-202.
- Updated rn-bdr-registry to 0.1.4.

### Version 0.1.34
- Updated appVersion to 5.9.4-201.

### Version 0.1.33
- Updated appVersion to 5.9.4-200.

### Version 0.1.32
- Updated rn-clamav to 0.1.5

### Version 0.1.31
- Updated rn-zeoserver to 0.1.6

### Version 0.1.30
- Updated appVersion to 5.9.4-199

### Version 0.1.29
- Updated rn-apache to 0.1.6
- Added healthchecks for apache in values.yaml

### Version 0.1.28
- Updated appVersion to 5.9.4-198

### Version 0.1.27
- Updated rn-bdr-european-registry to 0.1.4
- Added auditors fetch sync job

### Version 0.1.26
- Updated rn-apache to 0.1.5

### Version 0.1.25
- Updated postfix to 3.0.6

### Version 0.1.24
- Updated postfix to 3.0.5

### Version 0.1.23
- Updated postfix to 3.0.4

### Version 0.1.22
- Updated rn-apache to 0.1.4

### Version 0.1.21
- Updated appVersion to 5.9.4-197

### Version 0.1.20
- Updated rn-bdr-registry-notifications to 0.1.6
- Updated rn-bdr-registry to 0.1.3
- Updated rn-bdr-european-registry to 0.1.3

### Version 0.1.19
- Updated rn-bdr-registry-notifications to 0.1.5
- Updated rn-bdr-registry to 0.1.2
- Updated rn-bdr-european-registry to 0.1.2

### Version 0.1.18
- Updated appVersion to 5.9.4-196.

### Version 0.1.17
- Updated rn-bdr-registry-notifications to 0.1.4

### Version 0.1.16
- Updated rn-bdr-registry-notifications to 0.1.3

### Version 0.1.15
- Updated rn-bdr-registry-notifications to 0.1.2 to add support for deploymentArgs in registry-notifications-async

### Version 0.1.14
- Updated rn-bdr-registry-notifications to 0.1.1
- Updated postfix to 3.0.3

### Version 0.1.13
- Updated rn-apache to 0.1.3
- Updated postfix to 3.0.2
- Added mailtrap specific values and questions

### Version 0.1.12
- Updated rn-bdr-ldap to 0.1.1

### Version 0.1.11
- Added additional sentry related env variables
- Single quoted env variables in instance deployment

### Version 0.1.10
- Updated rn-local-converters, rn-clamav

### Version 0.1.9
- Converted sync jobs token question to password.

### Version 0.1.8
- Updated rn-cclamav to 0.1.3
- Updated rn-bdr-registry to 0.1.1
- Updated README

### Version 0.1.7
- Updated appVersion to 5.9.4-194

### Version 0.1.6
- Removed bdr-sync job and updated questions.yaml

### Version 0.1.5
- Fixed cron-sync-cronjob.yaml template

### Version 0.1.4
- Tweaked sync cronjobs with custom backoffLimit

### Version 0.1.3
- Questions updates for some strings

### Version 0.1.2
- Questions updates

### Version 0.1.1
- Added htpasswd question

### Version 0.1.0
- Initial release

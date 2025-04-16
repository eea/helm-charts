# Reportnet MDR

The Mediterranean Data Repository is part of the Reportnet architecture. The Mediterranean Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Network Security Policies

This Helm chart deploys Kubernetes Network Policies to enhance the security of the MDR application. If `defaultNetworkPolicyDeny` is enabled, these policies enforce a **whitelist** approach, meaning that network traffic is only allowed if explicitly permitted.

**Key Network Policy Configurations:**

*   **Instance Pod Egress (`instance.networkPolicy.egress` in `values.yaml`):**  Configures outbound traffic from the `mdr-instance` pods. You can configure egress rules in two ways:

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


*   **Varnish Pod Network Policy (`varnish.networkPolicy` in `values.yaml`):** Defines additional ingress and egress rules for the `mdr-varnish` pods.  You can use `varnish.networkPolicy.additionalIngress` and `varnish.networkPolicy.additionalEgress` in `values.yaml` to add custom rules on top of the base policy defined in the templates.

*   **Default Deny Policies:** The chart includes deny Network Policies (`netsecpol-ingress-default.yaml` and `netsecpol-egress-default.yaml`) that, when enabled with `defaultNetworkPolicyDeny.enabled: true`, block all ingress and egress traffic unless overridden by more specific policies. This ensures a secure starting point and encourages explicit definition of allowed traffic.

**Modifying Network Policies:**

To customize the network policies, you should modify the `instance.networkPolicy.egress` and `varnish.networkPolicy` sections within your `values.yaml` file.  Refer to the Kubernetes Network Policy documentation for details on how to define rules using `ipBlock`, `namespaceSelector`, `podSelector`, ports, and protocols.

## Releases

### Version 0.21.0 - 16 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-243](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`437ae66`](https://github.com/eea/helm-charts/commit/437ae66b94b908015b9a74aa11017e6808174d8d)]

### Version 0.20.0 - 16 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-244](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`3a15006`](https://github.com/eea/helm-charts/commit/3a15006f8d63a50bbe01fcfe5d28343763571f40)]

### Version 0.19.0 - 15 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-243](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`381f2bb`](https://github.com/eea/helm-charts/commit/381f2bb5ae1e1f3afd5d661df4d42b1821ea3e00)]

### Version 0.18.0 - 15 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-242](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`aadc06b`](https://github.com/eea/helm-charts/commit/aadc06b5022a75ddb378822610766d21ead936aa)]

### Version 0.17.0 - 14 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-241](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`f3802fb`](https://github.com/eea/helm-charts/commit/f3802fb551f431398174f5958b4b48951fab470d)]

### Version 0.16.0 - 11 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-240](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`a82fb63`](https://github.com/eea/helm-charts/commit/a82fb63f47f381734445a84d4247a923f3cad58f)]

### Version 0.15.0 - 10 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-239](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`d006dc3`](https://github.com/eea/helm-charts/commit/d006dc35169c80ba69ba89924b746cf908e93681)]

### Version 0.14.0 - 01 April 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-238](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`22f02ad`](https://github.com/eea/helm-charts/commit/22f02adda37b839d24e97e3d0a4342cef77fc281)]

### Version 0.13.0 - 31 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-237](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`9a6d226`](https://github.com/eea/helm-charts/commit/9a6d226c70fa00d1c377d7a9282b1828a9a9a57b)]

### Version 0.12.0 - 25 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-236](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`6761c99`](https://github.com/eea/helm-charts/commit/6761c99a164b13d147be96fd7b051fad40c4e7e3)]

### Version 0.11.0 - 25 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-235](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`02619ca`](https://github.com/eea/helm-charts/commit/02619cad291ffa3e26ee6afc0b4ccdb0961fe10c)]

### Version 0.10.0 - 21 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-234](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`34063fe`](https://github.com/eea/helm-charts/commit/34063fe0658136acc2732841537d8aaad07e068c)]

### Version 0.9.0 - 20 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-233](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`6d8315a`](https://github.com/eea/helm-charts/commit/6d8315a18f61b5361ac75fd86dd9a14613dae05b)]

### Version 0.8.0 - 20 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-232](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`712d067`](https://github.com/eea/helm-charts/commit/712d0676d0f8331da1ab7b0cc65d34228ec78efa)]

### Version 0.7.0 - 20 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-231](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`14229ee`](https://github.com/eea/helm-charts/commit/14229ee70a3a8e47282c42ac9464688e333f567a)]

### Version 0.6.0 - 19 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-230](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`55ebcca`](https://github.com/eea/helm-charts/commit/55ebcca1703c40ec194cf2869319d76ac852636e)]

### Version 0.5.0 - 17 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-228](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`e8e61b2`](https://github.com/eea/helm-charts/commit/e8e61b2b87bf917bd4b58618a8395941d512e375)]

### Version 0.4.1 - 14 March 2025
- Release of dependent chart rn-varnish:0.2.0 [EEA Jenkins - [`2453385`](https://github.com/eea/helm-charts/commit/2453385d05f177563143413f5a6790779b7b1179)]

### Version 0.4.0 - 14 March 2025
- Automated release of [eeacms/reportek-mdr:3.9.1-227](https://github.com/eea/eea.docker.reportek.mdr-instance/releases) [EEA Jenkins - [`eede8bf`](https://github.com/eea/helm-charts/commit/eede8bf8207447999d71485802ea09c53a5e6192)]

### Version 0.3.22
- Updated appVersion to 3.9.1-224.

### Version 0.3.21
- Updated appVersion to 3.9.1-219.
- Made cronjob for zeopack more verbose.

### Version 0.3.20
- Updated appVersion to 3.9.1-218.
- Added network policies.

### Version 0.3.10
- Updated appVersion to 3.9.1-215.

### Version 0.3.9
- Updated appVersion to 3.9.1-214.

### Version 0.3.8
- Updated appVersion to 3.9.1-213.

### Version 0.3.7
- Updated rn-zeoserver chart to 0.1.6.

### Version 0.3.6
- Updated appVersion to 3.9.1-212.

### Version 0.3.5
- Updated appVersion to 3.9.1-211.

### Version 0.3.4
- Updated appVersion to 3.9.1-210.

### Version 0.3.3
- Updated appVersion to 3.9.1-209.

### Version 0.3.2
- Added additional sentry related env variables
- Single quoted env variables in instance deployment

### Version 0.3.1
- Updated rn-local-converters

### Version 0.3.0
- Added webforms support.
- Fixed zeopack values.

### Version 0.2.12
- Updated rn-varnish chart to 0.1.5.

### Version 0.2.11
- Updated appVersion to 3.9.1-207.

### Version 0.2.10
- Added sentryDSN variable in questions.yaml.

### Version 0.2.9
- Added zeoAddress variable in questionstions.yaml and relabeled ingress backend service name.

### Version 0.2.8
- Added varnish backend and port in questions.yaml.

### Version 0.2.7
- Updated rn-zeoserver chart to 0.1.5.

### Version 0.2.6
- Updated rn-zeoserver chart to 0.1.4.

### Version 0.2.5
- Updated rn-zeoserver chart to 0.1.3.

### Version 0.2.4
- Fixed default serviceName in ingress configuration in questions.yaml.

### Version 0.2.3
- Added additional ingress configuration options in questions.yaml.

### Version 0.2.2
- Added zeoserver storageName to questions.yaml.

### Version 0.2.1
- Added questions.yaml.

### Version 0.2.0
- Updated rn-zeoserver chart to 0.1.2.

### Version 0.1.5
- Fixed instance deployment name.

### Version 0.1.4
- Fixed liveness and readiness probes in deployment.

### Version 0.1.3
- Updated readme.
- Moved liveness probes out of the deployment.

### Version 0.1.2
- Refactoring and cleanup.
- Updated rn-varnish chart to 0.1.4.
- Updated rn-local-converters chart to 0.1.2.
- Updated rn-clamav chart to 0.1.2.
- Updated ingress

### Version 0.1.1
- Removed deployment referrence from README.

### Version 0.1.0
- Initial release.

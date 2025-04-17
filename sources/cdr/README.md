# Reportnet CDR

The Central Data Repository is part of the Reportnet architecture. The Central Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

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


*   **Varnish Pod Network Policy (`varnish.networkPolicy` in `values.yaml`):** Defines additional ingress and egress rules for the `cdr-varnish` pods.  You can use `varnish.networkPolicy.additionalIngress` and `varnish.networkPolicy.additionalEgress` in `values.yaml` to add custom rules on top of the base policy defined in the templates.

*   **Default Deny Policies:** The chart includes deny Network Policies (`netsecpol-ingress-default.yaml` and `netsecpol-egress-default.yaml`) that, when enabled with `defaultNetworkPolicyDeny.enabled: true`, block all ingress and egress traffic unless overridden by more specific policies. This ensures a secure starting point and encourages explicit definition of allowed traffic.

**Modifying Network Policies:**

To customize the network policies, you should modify the `instance.networkPolicy.egress` and `varnish.networkPolicy` sections within your `values.yaml` file.  Refer to the Kubernetes Network Policy documentation for details on how to define rules using `ipBlock`, `namespaceSelector`, `podSelector`, ports, and protocols.

## Releases

### Version 0.23.0 - 17 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-233](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`8ece20a`](https://github.com/eea/helm-charts/commit/8ece20a2af17c4d8baae5d64949b32b3c9013118)]

### Version 0.22.0 - 16 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-232](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`8ae1f34`](https://github.com/eea/helm-charts/commit/8ae1f3482dac80ff36f6f2e9d5d7e7e5c9ce8a55)]

### Version 0.21.0 - 16 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-231](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`61baa38`](https://github.com/eea/helm-charts/commit/61baa388172ac5c170a781ab1182ac17c0f673b5)]

### Version 0.20.0 - 15 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-230](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`754b90e`](https://github.com/eea/helm-charts/commit/754b90e105dc78011a06040c7ed5054b2a228062)]

### Version 0.19.0 - 15 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-229](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`73d5b40`](https://github.com/eea/helm-charts/commit/73d5b402220d67d41595ed59a22f596cbc7d1323)]

### Version 0.18.0 - 14 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-228](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`04a7ba9`](https://github.com/eea/helm-charts/commit/04a7ba991a431cff6c3591d14d0cea7fc88bce7b)]

### Version 0.17.0 - 11 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-227](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`c8261cf`](https://github.com/eea/helm-charts/commit/c8261cf95cdd4a952e62516d52d37ac58521c8da)]

### Version 0.16.0 - 10 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-226](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`9a4aaf7`](https://github.com/eea/helm-charts/commit/9a4aaf7c8b033b77cf90bc7c966777bb77bd8769)]

### Version 0.15.0 - 01 April 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-225](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`aa22bd3`](https://github.com/eea/helm-charts/commit/aa22bd3412cf96032d29eb0356fc4643a61d955b)]

### Version 0.14.0 - 31 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-224](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`6ca3871`](https://github.com/eea/helm-charts/commit/6ca38714decc7fbce9b488dd184b7de56e94cdc4)]

### Version 0.13.0 - 25 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-223](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`be62d43`](https://github.com/eea/helm-charts/commit/be62d4373ea2eed58725e7f645cd4305bffc6c10)]

### Version 0.12.0 - 25 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-222](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`472fc47`](https://github.com/eea/helm-charts/commit/472fc47ac1933759223c8159cbef75f621b40989)]

### Version 0.11.2 - 24 March 2025
- Added zeoClientCacheSize, zeoClientBlobCacheSize, sessionManagerTimeout env variables

### Version 0.11.1 - 24 March 2025
- Added blobstorage volume for blobcache

### Version 0.11.0 - 21 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-221](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`63e3356`](https://github.com/eea/helm-charts/commit/63e3356bee3e3531129535244c12e871aa1ab313)]

### Version 0.10.0 - 20 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-220](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`8bbffc9`](https://github.com/eea/helm-charts/commit/8bbffc9755feb8d0c662119dcacfd067f4b5d312)]

### Version 0.9.0 - 20 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-219](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`8b207f7`](https://github.com/eea/helm-charts/commit/8b207f74d391b808ad947202a9330c50e07083a2)]

### Version 0.8.0 - 20 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-218](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`17316a5`](https://github.com/eea/helm-charts/commit/17316a5a7c21368d37da6cbbf52cb5780213289d)]

### Version 0.7.0 - 19 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-217](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`afd357e`](https://github.com/eea/helm-charts/commit/afd357ebc5d802c0932a741cbdd65e335db1db47)]

### Version 0.6.0 - 18 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-216](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`577399f`](https://github.com/eea/helm-charts/commit/577399f1b7864e62c6c3dc6896006f78e4116a79)]

### Version 0.5.1 - 18 March 2025
- Removed most cpu limits except for clamav

### Version 0.5.0 - 17 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-215](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`103685a`](https://github.com/eea/helm-charts/commit/103685a6b143551e4472fa9751762d5f6c50c7d1)]

### Version 0.4.1 - 14 March 2025
- Release of dependent chart rn-varnish:0.2.0 [EEA Jenkins - [`2ce542a`](https://github.com/eea/helm-charts/commit/2ce542a4450495161ae638e29255f8edbc3afbc3)]

### Version 0.4.0 - 14 March 2025
- Automated release of [eeacms/reportek-cdr:6.7.3-214](https://github.com/eea/eea.docker.reportek.cdr-instance/releases) [EEA Jenkins - [`05172fd`](https://github.com/eea/helm-charts/commit/05172fd512faba5cbaf20823417d1b0f2c6209ea)]

### Version 0.3.41
- Updated appVersion to 6.7.3-211.

### Version 0.3.40
- Improved network policy configuration by allowing per-CIDR port specifications in ipBlockRules

### Version 0.3.33
- Fixed url in CSP header.

### Version 0.3.32
- Updated ingress's CSP header.

### Version 0.3.31
- Improved instance network security policy template to allow for more flexibility.

### Version 0.3.30
- Added network policies.
- Updated appVersion to 6.7.3-204.
- Updated rn-zeoserver to 0.1.9.
- Updated rn-varnish to 0.1.10.
- Updated rn-local-converters to 0.1.6.
- Updated rn-clamav to 0.1.8.

### Version 0.3.23
- Updated appVersion to 6.7.3-202.

### Version 0.3.22
- Updated appVersion to 6.7.3-201.

### Version 0.3.21
- Updated appVersion to 6.7.3-200.

### Version 0.3.20
- Added missing env variables for auto env cleanuo.

### Version 0.3.19
- Fixed cronjob command for auto fallin, auto env cleanup and auto cleanup.

### Version 0.3.18
- Updated rn-clamav chart to 0.1.5.

### Version 0.3.17
- Updated rn-zeoserver chart to 0.1.6.

### Version 0.3.16
- Fixed cronjob for auto cleanup.

### Version 0.3.15
- Added cronjob for auto cleanup.

### Version 0.3.14
- Updated appVersion to 6.7.3-199.

### Version 0.3.13
- Updated appVersion to 6.7.3-198.

### Version 0.3.12
- Updated appVersion to 6.7.3-197.

### Version 0.3.11
- Updated appVersion to 6.7.3-196.

### Version 0.3.10
- Updated appVersion to 6.7.3-195.

### Version 0.3.9
- Added computed sentry release

### Version 0.3.8
- Added sentrySite and sentryEnvironment variables.

### Version 0.3.7
- Conditionally create and mount zip_cache pvc/pv if zipCacheEnabled is true.

### Version 0.3.6
- Updated rn-clamav and rn-local-converters

### Version 0.3.5
- Converted template values to use single quotes to handle special characters.

### Version 0.3.4
- Removed repository and tag from instance in values.yaml.

### Version 0.3.3
- Added missing env variables for cronautofallin.

### Version 0.3.2
- Fixed values mix-up.

### Version 0.3.1
- Fixed the webforms related questions.

### Version 0.3.0
- Added webforms to the list of services.

### Version 0.2.15
- Updated rn-clamav chart to 0.1.3.
- Updated rn-varnish chart to 0.1.5.

### Version 0.2.14
- Updated appVersion to 6.7.3-194.

### Version 0.2.13
- questions.yaml updates.

### Version 0.2.12
- More updates to the questions.yaml related to ingress.

### Version 0.2.11
- Updated questions.yaml for ingress.

### Version 0.2.10
- Fixed SSRF on Converters/run_conversion.

### Version 0.2.9
- Added nginx server snippet to ingress to prevent SSRF on Converters/run_conversion.

### Version 0.2.8
- Added sentryDSN to questions.yaml.

### Version 0.2.7
- Added zeoAddress to questions.yaml and re-labeled ingress backend service name.

### Version 0.2.6
- Added varnish backend configuration in questions.yaml.

### Version 0.2.5
- Updated rn-zeoserver chart to 0.1.5.

### Version 0.2.4
- Added additional ingress configuration options in questions.yaml.

### Version 0.2.3
- More reorganization of questions.yaml.

### Version 0.2.2
- Reorganized questions.yaml and added more questions.

### Version 0.2.1
- Added questions.yaml.

### Version 0.2.0
- Updated rn-zeoserver chart to 0.1.2.

### Version 0.1.9
- Fixed liveness probe and readiness probe in deployment.

### Version 0.1.8
- Updated readme.
- Moved liveness probes out of the deployment.

### Version 0.1.7
- Refactoring and cleanup.
- Updated rn-varnish chart to 0.1.4.
- Updated rn-local-converters chart to 0.1.2.
- Updated rn-clamav chart to 0.1.2.
- Updated ingress.

### Version 0.1.6
- Refactored to be able to install multiple stacks in the same namespace. Due to the chart naming, we can't solely rely on appl.fullname for service naming.
- Dropped deployment since it's not needed, we can use RELEASE instead.
- Removed storage PVC since it's not needed.

### Version 0.1.5
- Added rabbitmq.create and rabbitmq.name. When create is true, the rabbitmq service will be created.

### Version 0.1.4
- Get the image and tag from image section.

### Version 0.1.3
- Changed rabbitmq to externalName.

### Version 0.1.2
- Updated rn-varnish chart to 0.1.3 and fix ingress path.

### Version 0.1.1
- Updated rn-varnish chart to 0.1.2.

### Version 0.1.0
- Initial release.

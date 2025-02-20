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

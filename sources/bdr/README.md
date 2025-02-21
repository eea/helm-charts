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

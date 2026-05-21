# Reportnet CDR on python 3

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

    Under default-deny, the chart auto-deploys ingress allows for the in-cluster `valkey` and `memcached` pods (when enabled), permitting traffic from any pod in the same release — no extra rules needed.

**Modifying Network Policies:**

To customize the network policies, you should modify the `instance.networkPolicy.egress` and `varnish.networkPolicy` sections within your `values.yaml` file.  Refer to the Kubernetes Network Policy documentation for details on how to define rules using `ipBlock`, `namespaceSelector`, `podSelector`, ports, and protocols.

## Shared Blob Storage

By default, every Zope instance pod streams blobs over the ZEO wire and caches
them locally in a per-pod `emptyDir` (`instance.env.blobStorageCacheVolumeEnabled`).
For deployments where the cluster has a `ReadWriteMany` storage class available
(e.g. `nfs-client` via `nfs-subdir-external-provisioner`), the chart can instead
have the **ZEO server's own PVC** be `ReadWriteMany` and have every instance
pod mount that same PVC at `/opt/zope/var/blobstorage` (subPath: `blobstorage`).
The base image's entrypoint sets `shared-blob-dir on` in `zodb.conf` so Zope
clients read blobs directly off the shared filesystem instead of streaming.


### Values

```yaml
zeoserver:
  accessMode: ReadWriteMany              # default ReadWriteOnce; must be RWX

instance:
  env:
    zeoSharedBlobDir: "on"               # default "off"
    blobStorageCacheVolumeEnabled: false # mutually exclusive with shared mode
```

Constraints (enforced via `helm template`-time fail-fast):

- `instance.env.zeoSharedBlobDir: on` requires `zeoserver.accessMode: ReadWriteMany`.
- `instance.env.zeoSharedBlobDir: on` requires `instance.env.blobStorageCacheVolumeEnabled: false`.
- `instance.env.zeoSharedBlobDir: on` requires `zeoserver.zeoUid: 1000` and
  `zeoserver.zeoGid: 1000` (the instance pod's hardcoded UID). The ZEO server
  and instance pods share the same filesystem, so their UIDs must match.

When `zeoSharedBlobDir: on`, the instance Deployment mounts the StatefulSet's
PVC by computed name: `<zeoserver.storageName>-<Release.Name>-zeoserver-0`.

### Enabling on a fresh deployment

If you're deploying for the first time:

1. Set the values above before the first `helm install`.
2. Make sure your storage class supports `ReadWriteMany` (the chart only
   declares the access mode; the cluster must back it).


## LDAP cache (memcached)

The Zope instances use memcached as a backend cache for LDAP lookups via the
`LDAP_MEMCACHED_SERVERS` env var (comma-separated `host:port`). To deploy an
in-cluster memcached and wire it up:

```yaml
memcached:
  enabled: true                          # deploys memcached + Service on TCP/11211

instance:
  env:
    ldapMemcachedServers: "cdr-py3-memcached:11211"
```

When `ldapMemcachedServers` is empty the env var is omitted entirely.

## Releases

### Version 0.1.3 - 21 May 2026
- Updated appVersion to z5-1.9 and added LDAP memcached deployment [Olimpiu Rob - [`d530fffb`](https://github.com/eea/helm-charts/commit/d530fffbad33b017485b067b05f38a4421191658)]

### Version 0.1.2 - 20 May 2026
- Set zeoserver image tag to z5-1.0 [Olimpiu Rob - [`7b728abb`](https://github.com/eea/helm-charts/commit/7b728abb1ea31d6e60de9bceaa9633920878ebcc)]

### Version 0.1.1 - 19 May 2026
- Fixed webforms proxy [Olimpiu Rob - [`de19303d`](https://github.com/eea/helm-charts/commit/de19303dce02ca717056182de12be9179741d6d4)]

### Version 0.1.0 - 18 May 2026
- Initial release.

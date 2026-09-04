# Reportnet BDR on python 3

The Business Data Repository is part of the Reportnet architecture. The Business Data Repository is like a bookshelf, with data reports on the environment as submitted to international clients.

This chart is almost configured for production use.

## Network Security Policies

This Helm chart deploys Kubernetes Network Policies to enhance the security of the BDR application. If `defaultNetworkPolicyDeny` is enabled, these policies enforce a **whitelist** approach, meaning that network traffic is only allowed if explicitly permitted.

**Key Network Policy Configurations:**

*   **Instance Pod Egress (`instance.networkPolicy.egress` in `values.yaml`):**  Configures outbound traffic from the `bdr-instance` pods. You can configure egress rules in two ways:

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

    Under default-deny, the chart auto-deploys ingress allows for the in-cluster `valkey` and `memcached` pods (when enabled), permitting traffic from any pod in the same release — no extra rules needed.

**Modifying Network Policies:**


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
    ldapMemcachedServers: "bdr-py3-memcached:11211"
```

When `ldapMemcachedServers` is empty the env var is omitted entirely.

## Secret handling

The instance supports either:

- `instance.existingSecret`, containing `BEAKER_SECRET`, `SESSION_SECRET`,
  `RABBITMQ_PASS`, and `SENTRY_DSN`; or
- an inline `instance.env.sessionSecret` injected at deployment time.

No credential placeholders are shipped. Inline Secret changes alter the pod
checksum and roll the instance Deployment. For an external Secret, changing the
Secret name rolls the Deployment; changing only its contents requires a
reloader controller or an explicit rollout.

PostgreSQL supports `postgresql.auth.existingSecret` with the configured
`postgres-password`, `password`, and `replication-password` keys. Admin ingress
auth similarly accepts `apache.adminAuth.existingSecret` with `auth` (nginx)
and `users` (Traefik) keys, or a deploy-time `htpasswd` value.

## Sync CronJob credentials and deadlines

When `cron.tokenSecretName` is empty, the chart renders
`templates/cron-sync-secret.yaml` as the `bdr-py3-sync-tokens` Secret in the
release namespace. Each enabled job contributes its `token` under the key set
by `tokenSecretKey`:

```yaml
cron:
  tokenSecretName: ""

synccronjobs:
  - name: sync-fgases
    enabled: true
    schedule: "2-59/5 * * * *"
    tokenSecretKey: sync-fgases
    token: "" # inject at deployment time; never commit a production token
    syncURL: https://example.invalid/sync
    backoffLimit: 1
    resources:
      requests:
        memory: 16Mi
      limits:
        memory: 16Mi
```

Alternatively, set `cron.tokenSecretName` to a caller-managed Secret containing
those keys; the chart will not render its own sync token Secret. Inline token
values are stored both in the Kubernetes Secret and in Helm release state, like
other chart-managed Secret values.

Curl runs directly without a shell and has connect/request timeouts. Job and
schedule deadlines prevent a hung job from blocking future executions under
`concurrencyPolicy: Forbid`.

## Releases

### Version 0.1.7 - 04 September 2026
- Updated appVersion to z5-1.11 [Olimpiu Rob - [`c52e46ee`](https://github.com/eea/helm-charts/commit/c52e46eec58cd69e8ee2b86af0947dfaa2817911)]

### Version 0.1.6 - 27 August 2026
- Updated appVersion to z5-1.10 [Olimpiu Rob - [`9cf3781f`](https://github.com/eea/helm-charts/commit/9cf3781fdc53ff9cd3fee63d4f2aab26bb1f897c)]

### Version 0.1.5 - 26 August 2026
- Updated appVersion to z5-1.9 [Olimpiu Rob - [`526ed93d`](https://github.com/eea/helm-charts/commit/526ed93d7d5e02c93f55270b461999b602262cdd)]

### Version 0.1.4 - 26 August 2026
- Upgraded appVersion to z5-1.8 [Olimpiu Rob - [`f29f241d`](https://github.com/eea/helm-charts/commit/f29f241db05c47b87e92d2e1fc5add3eacf9a82a)]

### Version 0.1.3 - 12 August 2026
- Updated appVersion to z5-1.7 [Olimpiu Rob - [`72c360f7`](https://github.com/eea/helm-charts/commit/72c360f74a08ed2c76dc7361f9e973c5185b795a)]

### Version 0.1.2 - 12 August 2026
- Updated appVersion to z5-1.6 [Olimpiu Rob - [`215a1636`](https://github.com/eea/helm-charts/commit/215a16361c6cc9fbb9c54b9f6f3827d1fcc14937)]

### Version 0.1.1 - 11 August 2026
- Added betterleaks:allow to suppress false positives [Olimpiu Rob - [`df1c2bdb`](https://github.com/eea/helm-charts/commit/df1c2bdb2f4e34f1f492c219bc7949e3f5b0a36a)]

### Version 0.1.0 - 10 Aug 2026
- Initial release.

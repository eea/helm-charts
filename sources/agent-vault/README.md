# agent-vault

Deploys [Infisical Agent Vault](https://github.com/Infisical/agent-vault) following the
[`nginx-public-ui-proxy`](https://github.com/Infisical/agent-vault/tree/main/examples/nginx-public-ui-proxy)
pattern: a private Agent Vault Deployment (management UI on `14321`, MITM proxy on `14322`)
behind a public nginx reverse proxy that only ever forwards to `14321`.

```
PUBLIC INTERNET                              CLUSTER-INTERNAL
───────────────                              ─────────────────────────────────
                                               ┌────────────────────────────┐
[browser] ─HTTPS─► [Ingress] ─► [nginx proxy] ─► │ agent-vault Service        │
                                               │   14321  management UI     │
                                               │   14322  MITM proxy        │
                                               └────────────────────────────┘
                                                      ▲                 │
                                                      │ HTTPS_PROXY     ▼
                                               [agent pods]      [external APIs]
```

`14322` is never reachable from the Ingress or the reverse proxy — only from pods in the
same namespace (agent workloads point `HTTPS_PROXY` at the **vault** Service directly,
`<vault-service>:14322`, not the nginx proxy — the reverse proxy exists solely for browser
access to the UI on `14321`). `14321` is also reachable from any in-namespace pod, not just
the reverse proxy — agent workloads need it too, for the token-validation call `agent-vault
run` makes before switching to the MITM proxy. This is enforced both structurally (the
proxy's nginx config only ever `proxy_pass`es to `14321`, never `14322`) and, if
`networkPolicy.enabled` is `true` (default), by a NetworkPolicy. See
[Running agentic tools against this vault](#running-agentic-tools-against-this-vault) below
for exposing `14322` to agents running outside the cluster.

## Required values

`agentVault.database.enabled` defaults to `true` (see [Scaling](#scaling-the-agent-vault-backend)),
so a PostgreSQL connection is required out of the box. Either point at an externally managed
instance:

```yaml
hostname: "val-agent-vault.01dev.eea.europa.eu"
agentVault:
  masterPassword: ""  # set via --set-string or a values file kept out of git
  database:
    url: "postgres://agentvault:<password>@db.example.com:5432/agentvault?sslmode=require"
```

or deploy PostgreSQL from this chart's own templates instead (`templates/postgres-*.yaml`) by
setting `postgres.enabled: true` — `agentVault.database.url`/`existingSecret` are then ignored
and the connection string is derived from `postgres.auth.*`:

```yaml
hostname: "val-agent-vault.01dev.eea.europa.eu"
agentVault:
  masterPassword: ""  # set via --set-string or a values file kept out of git
postgres:
  enabled: true
  auth:
    password: ""  # set via --set-string or a values file kept out of git
```

The bundled PostgreSQL is a single-replica StatefulSet with its own PVC
(`postgres.persistence.*`) and, when `networkPolicy.enabled` is `true` (default), a
NetworkPolicy restricting it to the Agent Vault pods only. It is not highly available — for
production-grade durability (backups, failover, replicas) point `agentVault.database.url` at
a managed/externally operated instance instead.

To use the embedded SQLite store instead (single instance only, data on a PVC), set
`agentVault.database.enabled: false`.

## Scaling the Agent Vault backend

`agentVault.database.enabled` is `true` by default, which makes instances stateless — no
local volume, CA root cert shared via the encrypted DB, advisory locks guard concurrent
config writes (see
[`docs/self-hosting/postgres.mdx`](https://github.com/Infisical/agent-vault/blob/main/docs/self-hosting/postgres.mdx)
upstream) — so they scale horizontally behind the `agent-vault` Service like any other
stateless Deployment:

```yaml
agentVault:
  database:
    url: "postgres://agentvault:<password>@db.example.com:5432/agentvault?sslmode=require"
    # or, to avoid putting the URL in values: leave `url` empty and set
    # existingSecret to the name of a Secret containing an existingSecretKey
    # (default DATABASE_URL) key with the connection string.

  replicaCount: 2
  # or:
  # autoscaling:
  #   enabled: true
  #   minReplicas: 2
  #   maxReplicas: 5
```

If `agentVault.database.enabled` is set to `false` (embedded SQLite on a local volume),
the chart refuses to render (`fail`) when `replicaCount > 1` or `autoscaling.enabled` is
set — this guardrail exists because SQLite-backed multi-instance deployments silently
corrupt data rather than erroring at request time.

When `database.enabled` is `true`, the chart skips the `/data` PVC/volume entirely
(`agentVault.persistence.*` is ignored) and adds `DATABASE_URL` to the container env.
Readiness/liveness probes hit `GET /health`, which pings the configured store.

## Securing the admin (management UI) Ingress

The Ingress uses `ingressClassName: nginx` by default (`ingress.className`); set it to
`traefik` to use Traefik instead — `redirectHttps`/`ipAllowList` below render as the
matching controller's mechanism either way. Three independent controls harden access to
the management UI beyond Agent Vault's own login:

```yaml
ingress:
  className: nginx               # or traefik
  certManager:
    enabled: true
    clusterIssuer: letsencrypt-prod
  certificate: agent-vault-tls   # secret cert-manager will create
  redirectHttps: true            # default — requires ingress.certificate to be set
  ipAllowList:
    - "10.0.0.0/8"
    - "203.0.113.4/32"
```

- **`certManager.enabled`** adds the `cert-manager.io/cluster-issuer` annotation so
  cert-manager requests a Let's Encrypt certificate into the Secret named by
  `ingress.certificate`, instead of requiring a pre-existing TLS secret. Controller-agnostic.
- **`redirectHttps`** (default `true`) only takes effect once `ingress.certificate` is set
  — there's nothing to redirect to otherwise.
  - `ingress-nginx`: sets `nginx.ingress.kubernetes.io/force-ssl-redirect: "true"`.
  - `traefik`: creates a `RedirectScheme` Middleware and attaches it via
    `traefik.ingress.kubernetes.io/router.middlewares`.
- **`ipAllowList`** restricts which source CIDRs may reach the UI at all.
  - `ingress-nginx`: sets `nginx.ingress.kubernetes.io/whitelist-source-range`.
  - `traefik`: creates an `IPAllowList` Middleware (`traefik.io/v1alpha1`, requires the
    Traefik CRDs to be installed — they are with the `traefik` chart in this repo).

  This is enforced only at the ingress controller (which reads the real client IP via
  `X-Forwarded-For`) — **not** by a NetworkPolicy on the proxy pods. A CIDR-based
  NetworkPolicy can't do this correctly in the default topology: the proxy pod sees the
  ingress controller's own pod IP as the connection source, not the client's, unless the
  Service in front of the controller preserves it end to end (`externalTrafficPolicy:
  Local`, proxy protocol, etc) — without that, such a policy would block the ingress
  controller itself and take the UI down entirely for everyone.

## SMTP (email verification, vault invites, notifications)

Disabled by default — Agent Vault runs without email support until `smtp.enabled: true`
(or `mailtrap.enabled: true`, see below) and `smtp.from` is set:

```yaml
smtp:
  enabled: true
  host: smtp.example.com
  port: 587                    # 465 (implicit TLS) / 587 (STARTTLS) / 25 for an unauthenticated internal relay
  from: agent-vault@example.com
  # username/password only needed if the relay requires auth
  # username: ...
  # password: ""  # set via --set-string or a values file kept out of git
```

This follows the same pattern used elsewhere in this repo (e.g. the `postfix` chart
dependency in `cca-backend`, `advisory-board-backend`, etc.): point the app at an
unauthenticated internal relay Service on port 25 (no `username`/`password`, no TLS —
`tlsMode: none`) for an actual outbound relay, or use a catch-all mail viewer for
test/dev environments.

### Bundled mailtrap (dev/test only)

For test/dev environments, this chart can deploy the
[`mailtrap`](https://github.com/eea/helm-charts/tree/main/sources/mailtrap) chart (Postfix
+ a web viewer for captured emails, nothing is really delivered) as a dependency instead
of a separate release:

```yaml
mailtrap:
  enabled: true
  hostname: mailtrap-agent-vault.01dev.eea.europa.eu   # omit to keep the web UI cluster-internal only
  ingress:
    enabled: true
    certificate: mailtrap-agent-vault.01dev.eea.europa.eu-tls
    annotations:
      cert-manager.io/cluster-issuer: 01dev-eea-letsencrypt
```

`mailtrap.enabled: true` implies `smtp.enabled` — `smtp.host`/`port`/`tlsMode` are derived
automatically (unauthenticated relay on port 25); `smtp.from` is still required. Run `helm
dependency update` before packaging/installing after changing `Chart.yaml`.

**Limitation**: mailtrap's Postfix only accepts mail addressed to its own hostname or
`localhost` — real recipient domains (actual user email addresses) get `454 Relay access
denied`. So verification/invite emails to real users will **not** deliver through it; it's
only useful for scenarios where the recipient address is deliberately chosen to match
mailtrap's own domain. This is an upstream constraint in the `mailtrap` chart/image, not
something configured here — use a real SMTP relay (`smtp.*` above, with `mailtrap.enabled:
false`) for anything that needs to reach real recipients.

See
[`docs/self-hosting/environment-variables.mdx`](https://github.com/Infisical/agent-vault/blob/main/docs/self-hosting/environment-variables.mdx)
upstream for the full variable reference. Verify with `agent-vault owner email test` (run
as the instance owner) once configured.

## Running agentic tools against this vault

Agent Vault wraps a tool's process (`agent-vault run -- <opencode|claude|codex|hermes|...>`),
injecting `HTTPS_PROXY`/CA-trust env vars so the tool's own outbound HTTP(S) calls get
routed through the MITM proxy, which attaches real credentials transparently — the tool
process itself never holds them, only a vault-scoped token. Three environment variables
point it at the server (agent mode, e.g. CI/unattended use) before running
`agent-vault run -- opencode`:

- the vault (or agent) token, from `agent-vault agent create`
- the target vault's name
- the vault Service's in-cluster address on port `14321`, e.g.
  `http://<vault-service>.<namespace>.svc.cluster.local:14321`

**`AGENT_VAULT_ADDR` must point at the vault Service directly (port `14321`), not the
nginx reverse proxy** — the CLI derives the MITM proxy URL (`14322`) from the same host, and
the reverse proxy only ever forwards `14321`. This only works for tools running as pods in
the same namespace by default (see the architecture note above).

For agentic tools running outside the cluster (a developer's own machine over VPN, not an
in-cluster pod), set `mitmService.enabled: true` to expose `14322` via a dedicated
`LoadBalancer` Service, restricted to `mitmService.loadBalancerSourceRanges` (required —
the MITM proxy's auth token rides in the URL, so this must never be unrestricted):

```yaml
mitmService:
  enabled: true
  loadBalancerSourceRanges:
    - "10.0.0.0/8"
  # This cluster's MetalLB pools don't auto-assign — get a static IP from
  # whoever manages MetalLB address pools first, then:
  annotations:
    metallb.universe.tf/loadBalancerIPs: "10.50.x.x"
```

Without the `metallb.universe.tf/loadBalancerIPs` annotation (or an equivalent for
whichever LoadBalancer implementation the cluster uses), the Service's `EXTERNAL-IP` stays
`<pending>` forever and `helm upgrade --wait` will time out — confirmed against 01dev's
MetalLB, which requires a pre-reserved static IP per Service rather than auto-assigning
from a pool.

This is deliberately **not** routed through the Ingress: the MITM proxy is a raw
`CONNECT`-tunnel forward proxy (the client picks an arbitrary destination per-request), not
a normal HTTP backend an `Ingress` object can route to by host/path — a `LoadBalancer`
Service is the correct, native way to expose a raw TCP port with source-IP restriction.
Even with `mitmService.enabled: true`, `AGENT_VAULT_ADDR`/the control API (`14321`) itself
is still not exposed externally — only the MITM port. Off-cluster use of `agent-vault run`
therefore needs a session token minted some other way (e.g. `agent-vault agent create` run
by someone with cluster access) rather than an on-machine `agent-vault auth login`.

## Notes

- `agentVault.trustedProxies` should be set to the CIDR the reverse proxy pods run on
  (e.g. the cluster's pod CIDR), otherwise Agent Vault's audit log records the reverse
  proxy's IP instead of the real client's.
- `networkPolicy.enabled: true` requires a NetworkPolicy-enforcing CNI (Calico, Cilium,
  etc). If the cluster's CNI does not enforce NetworkPolicy, this setting has no effect —
  the Ingress/Service topology (only the proxy Service is fronted by Ingress) is what
  actually keeps `14322` off the public internet.
- TLS is terminated at the Ingress (`ingress.certificate`), not at the reverse proxy pod —
  matching the upstream example, which assumes TLS termination happens in front of it.
- The nginx reverse proxy uses the stock `nginx:1.27-alpine` image; its config is supplied
  via a ConfigMap (`templates/proxy-configmap.yaml`), mirroring the upstream example's
  `nginx.conf` / `default.conf.template` without needing a custom-built image.

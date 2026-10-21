# EEA Goldpinger (No separate RBAC chart required)

Goldpinger monitors connectivity between Kubernetes pods running on different nodes. This chart deploys one non-root agent on each eligible Linux node, a ClusterIP service for its connectivity graph, and a dedicated service account with namespace-only permission to list pods.

Application image: **docker.io/bloomberg/goldpinger:3.11.5**.

## Install on a test cluster

The package is a standard Helm chart archive. It contains the source templates, values, schema, Rancher questions, dashboard, and example values. No separate RBAC chart is required. Install using an infrastructure administrator account.

Standalone installation (no Prometheus Operator/Grafana required):

```bash
helm --kubeconfig 02test.yaml upgrade --install goldpinger ./goldpinger-0.1.2.tgz \
  --namespace eea-monitoring --create-namespace --wait --timeout 5m
```

Installation with Rancher Monitoring and the Rancher sidebar link (Grafana dashboard disabled):

```bash
tar -xzf goldpinger-0.1.2.tgz
# Review this example before installing: labels, tolerations, NavLink availability.
helm --kubeconfig 02test.yaml upgrade --install goldpinger ./eea-goldpinger \
  --namespace eea-monitoring --create-namespace \
  --values ./eea-goldpinger/examples/values-02test.yaml \
  --wait --timeout 5m
```

These examples do not assume cluster-specific IP addresses. The namespace `eea-monitoring` can be shared with other monitoring apps (Blackbox); all names and discovery selectors are specific to this release.

The monitoring examples require the ServiceMonitor, PrometheusRule and NavLink APIs. They disable Grafana dashboard provisioning, so no dashboard namespace is needed. Enabling the optional dashboard requires an existing namespace watched by Grafana and installer permission to create a ConfigMap there.

## Verify monitoring selection

Before enabling monitoring, inspect the Prometheus selectors:

```bash
kubectl --kubeconfig 02test.yaml get prometheus -A \
  -o custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,SERVICEMONITORS:.spec.serviceMonitorSelector,MONITOR_NAMESPACES:.spec.serviceMonitorNamespaceSelector,RULES:.spec.ruleSelector,RULE_NAMESPACES:.spec.ruleNamespaceSelector'
```

Set `serviceMonitor.labels` and `prometheusRule.labels` to match the selectors. Empty example labels are intentional: do not assume every installation requires `release: rancher-monitoring`. Prometheus must also select the `eea-monitoring` namespace. If needed, configure the Prometheus namespace selectors through Rancher Monitoring's values. Alert delivery uses the existing Alertmanager configuration.

## Rancher sidebar access and upgrade from 0.1.0 or 0.1.1

The examples enable `rancherNavLink.enabled` and disable `grafanaDashboard.enabled`. The group is blank: using `Monitoring` creates a separate custom group, rather than adding the link to Rancher's built-in Monitoring section. The link appears as a standalone **Goldpinger** entry in the selected cluster sidebar and opens a new tab. Rancher builds the authenticated proxy URL from the current cluster, release namespace, service name and service port; no Rancher hostname or cluster ID is stored in the chart. The path is `/` (not `proxy/`), because Rancher's UI adds the proxy segment itself.

Check API availability before upgrading:

```bash
kubectl --kubeconfig 02test.yaml get crd navlinks.ui.cattle.io
```

Preserve your current settings, including custom tolerations and monitoring selectors, and apply the two changes explicitly:

```bash
helm --kubeconfig 02test.yaml upgrade goldpinger ./goldpinger-0.1.2.tgz \
  -n eea-monitoring --reuse-values \
  --set rancherNavLink.enabled=true \
  --set rancherNavLink.label=Goldpinger \
  --set-string rancherNavLink.group=''  \
  --set rancherNavLink.target=_blank \
  --set grafanaDashboard.enabled=false \
  --wait --timeout 5m
```

Explicit NavLink fields above are needed with `--reuse-values`, because the old release has no values for this new feature. Helm removes the chart-owned dashboard ConfigMap during upgrade. Grafana's sidecar/provisioning settings determine when its UI removes the dashboard; separately saved copies remain. Prometheus scraping and alert rules retain their current settings. Refresh Rancher after upgrading. The chart-version change also updates the configuration checksum, causing a normal rolling update of the agents.

NavLink is cluster-scoped and named uniquely for this release and namespace; the installer needs permission to manage it. It grants no service-proxy permissions to viewers and does not broaden the agent's namespace-only RBAC. Viewers need access to NavLinks and the service proxy under their existing Rancher/Kubernetes roles. The chart uses Rancher's existing CRD and never installs it. If the API is unavailable, use `rancherNavLink.enabled=false` and bookmark the already-tested proxy URL.

Reference: [Rancher 2.14 custom navigation links](https://rancher.github.io/product-docs-playbook/rancher-manager/v2.14/en/rancher-admin/global-configuration/custom-branding.html).

## Who can see the NavLink and connectivity graph?

Goldpinger's runtime permissions and human access are separate. The chart's ServiceAccount and namespace-only `list pods` Role let the agents discover peers; they do not grant users access to the web UI. Enabling `rancherNavLink.enabled` creates the shortcut but does not create viewer RoleBindings.

For access through Rancher, two permissions are required:

| Permission | Purpose |
|---|---|
| Read NavLinks (`get`, `list`, `watch` on `navlinks.ui.cattle.io`) | Allows Rancher to retrieve the cluster-scoped navigation entries. Standard Rancher project Read-only roles already include this. |
| `get` on the specific `services/proxy` resource in the installation namespace | Allows the user to open Goldpinger through Rancher's authenticated Kubernetes service proxy. Standard project Read-only and View Services permissions do not include this. |

The chart uses a `toService` NavLink. Rancher 2.14 checks access to its destination service proxy and filters out the link when access is denied. A user can therefore have permission to read NavLinks but still not see the Goldpinger entry. A bookmarked proxy URL does not bypass service-proxy authorization.

With standard, unmodified roles, the expected behavior is:

| User permissions | Expected Goldpinger access through Rancher |
|---|---|
| Rancher administrator or Cluster Owner | Yes. |
| Project Owner or Project Member in the project containing the installation namespace | Yes, through their inherited namespace admin/edit permissions. |
| Project Read-only in that project | Requires the additional Goldpinger service-proxy permission shown below. |
| Access only to another project | Not granted by this chart; requires separately assigned permissions. |
| View Monitoring only | Does not by itself grant Goldpinger proxy access; the built-in monitoring permission targets the named Grafana, Prometheus and Alertmanager services. |

Custom roles and additional bindings can change these results. Check the user's effective permissions rather than relying only on the role's display name.

### Grant access to existing Read-only project users

An administrator can create a Role and RoleBinding in the installation namespace. This example assumes namespace `eea-monitoring`, release `goldpinger`, service `goldpinger-eea-goldpinger` and HTTP service port `8080`. Adjust these to match the actual NavLink target.

First, have the intended user run `kubectl auth whoami` with their own Rancher-downloaded kubeconfig. Use the returned Kubernetes **Username**, often a Rancher ID such as `u-abcde`, rather than assuming their email address is the Kubernetes username.

Save the following as `goldpinger-ui-access.yaml`, replacing `REPLACE_WITH_KUBERNETES_USERNAME`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: goldpinger-ui-view
  namespace: eea-monitoring
rules:
  - apiGroups: [""]
    resources: ["services/proxy"]
    resourceNames:
      - "http:goldpinger-eea-goldpinger:8080"
    verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: goldpinger-ui-viewers
  namespace: eea-monitoring
subjects:
  - kind: User
    name: REPLACE_WITH_KUBERNETES_USERNAME
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: goldpinger-ui-view
  apiGroup: rbac.authorization.k8s.io
```

Apply it with an administrator kubeconfig:

```bash
kubectl --kubeconfig ADMIN.yaml apply -f goldpinger-ui-access.yaml
```

Add more `User` entries under `subjects` for additional viewers, or bind a verified Kubernetes `Group` identity supplied by the authentication provider. This example does not automatically include all current or future Read-only project members. It grants only GET access through this named service proxy; it does not grant workload modification, pod listing, logs or exec permissions. Existing permissions remain in effect. These manually created resources are managed separately from the Goldpinger Helm release.

### Verify a viewer's access

Run these commands with the viewer's own kubeconfig, not an administrator's:

```bash
kubectl --kubeconfig USER.yaml auth can-i list navlinks.ui.cattle.io

kubectl --kubeconfig USER.yaml -n eea-monitoring auth can-i \
  get services/http:goldpinger-eea-goldpinger:8080 \
  --subresource=proxy
```

Both should return `yes`. Refresh Rancher and open the Goldpinger sidebar entry to verify the complete browser flow. If proxy access is allowed but the entry is absent, also check that NavLink is enabled, exists in this cluster and points to the correct namespace, service and port.

### Scope of the graph and other access paths

A viewer sees the connectivity information exposed by this Goldpinger release, including its participating nodes and configured extra targets. The graph is not filtered to the viewer's application namespaces or project. Grant access only where that visibility is appropriate.

`goldpinger.graphOnly` hides navigation items; it does not change authorization or block the underlying API endpoints. Goldpinger itself has no built-in authentication. Rancher proxy permissions govern access through Rancher; an ingress, direct in-cluster connection or port-forward uses its own access controls. Port-forward access requires separate Kubernetes permissions and is not granted by the Role above. Grafana dashboard access is also separate from access to Goldpinger's own UI.

References: [Rancher 2.14 NavLink destination authorization](https://github.com/rancher/rancher/blob/release/v2.14/pkg/api/steve/navlinks/store.go), [Rancher role definitions](https://github.com/rancher/rancher/blob/release/v2.14/pkg/data/management/role_data.go), and [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

## Alternative: Open the connectivity graph

```bash
kubectl --kubeconfig 02test.yaml --namespace eea-monitoring \
  port-forward service/goldpinger-eea-goldpinger 8080:8080
```

Open <http://localhost:8080/> while that command runs. This is the live connectivity graph; the Grafana dashboard contains time-series history and health summaries. The service name above assumes release name `goldpinger` and the default chart name.

The UI has **no built-in authentication**. No NodePort is created. Optional ingress is disabled by default; configure controller authentication, TLS and access restrictions before enabling it. The chart exposes the UI at `/` because its static assets/API use root paths. An HTTPS certificate alone does not authenticate users.

## Node coverage and taints

```bash
kubectl --kubeconfig 02test.yaml -n eea-monitoring get daemonset goldpinger-eea-goldpinger
kubectl --kubeconfig 02test.yaml -n eea-monitoring \
  get pods -l app.kubernetes.io/instance=goldpinger -o wide
kubectl --kubeconfig 02test.yaml get nodes -o custom-columns='NODE:.metadata.name,TAINTS:.spec.taints'
```

Compare desired/current/ready counts and node placement with the nodes you intend to monitor. Default tolerations cover standard RKE2 control-plane/master/etcd `NoSchedule` taints. Custom taints require explicit tolerations; do not assume the examples cover every cluster. Helm replaces lists, so preserve the standard tolerations when adding custom ones. `nodeSelector`, `affinity`, `tolerations`, resources, priority and rollout settings are configurable in values. Array/map settings should be edited in Rancher's **Edit YAML**; common scalar settings appear in its installation form.

Nodes without agents are not tested. A healthy graph is not proof of complete node coverage. Application-specific NetworkPolicies can differ from those applying to this namespace. Agents use pod IPs and ordinary CNI networking, with host networking disabled. No host paths, host ports, privileged containers, node RBAC or NET_RAW capability are required for the default IPv4 mode.

## Discovery and RBAC

Each agent receives `NAMESPACE` from its own pod namespace. Its label selector includes both the chart name and Helm release name. The chart creates a ServiceAccount, Role and RoleBinding together with the workload. The Role grants exactly:

```yaml
apiGroups: [""]
resources: ["pods"]
verbs: ["list"]
```

These permissions apply only within the installation namespace. A label selector filters discovery; it does not restrict the account's authorization. The account can list full pod specifications for all pods in that namespace, but cannot list pods elsewhere, read Secret objects, fetch pod logs, exec into pods or modify resources through this Role. Restrict installation/upgrades and pod modification/exec access to infrastructure administrators. Splitting RBAC into another Helm release does not remove the workload's ability to use its assigned service-account permissions.

To reuse separately managed RBAC:

```yaml
rbac:
  create: false
serviceAccount:
  create: false
  name: goldpinger
```

Ensure that account exists in the installation namespace and has a RoleBinding granting pod listing there. The existing EEA `goldpinger-rbac` chart can supply that binding. Do not use an account with broader permissions merely to avoid creating these resources. With `rbac.create: false`, this chart cannot revoke permissions supplied by another release.

This chart intentionally selects IPv4 for the current RKE2 setup. Upstream IPv6 discovery can require reading Node objects when the Pod's HostIP is from another address family; such permissions are deliberately not granted here.

## Checks and scaling

Default checks run every 30 seconds and test all peers through HTTP. This is HTTP-based connectivity testing, not ICMP ping. `goldpinger.pingNumber: 0` means all peers; for N agents there are approximately N² peer calls per interval, plus API discovery and any optional checks. Each agent has a 20m CPU/64Mi memory request and a 256Mi memory limit. Review consumption after installing; these are starting values, not guarantees for large clusters.

Optional `dnsTargets`, `tcpTargets` and `httpTargets` are YAML lists. HTTP checks require status 200 and use Goldpinger's normal TLS verification; this chart does not add a TLS-verification bypass. Avoid placing credentials or sensitive URLs in target values. DNS/TCP/HTTP checks run from every agent; their results can influence reported health. The test examples include only DNS resolution of `kubernetes.default.svc.cluster.local`.

Peer timeouts default to 1s for ping, 5s for check and 15s for the graph's check-all operation. Additional slow/failing external targets may require increasing check/check-all timeouts. Keep the check-all timeout comfortably above the per-peer check timeout, and above external-target work for your setup.

Optional `goldpinger.udp.enabled: true` enables peer UDP echo probes on port 6969, measuring loss and RTT. Allow UDP between agent pods if NetworkPolicies are present. The live graph uses upstream UDP information; the bundled historical dashboard focuses on HTTP/health. UDP is disabled by default. The service exposes HTTP only; UDP probes address peer pod IPs directly.

Local startup, readiness and liveness probes check HTTP serving at `/`, so peer failures do not cause the diagnostic agents to be restarted or removed from the Service.

## Grafana and alerts

The optional dashboard is provisioned as a ConfigMap labelled `grafana_dashboard: "1"`. Configure its namespace, labels and datasource UID to match Grafana. Its UID is derived from the release name and namespace, allowing separate releases to coexist; `grafanaDashboard.uid` can override it. Queries restrict data to this release's namespace and ServiceMonitor job, with a source-node selector.

Panels show scraped instances, worst unhealthy-peer count, unhealthy peers per observer, average HTTP ping response time, health timelines and external target errors. Collection/discovery diagnostics are in a collapsed row. Missing time-series data remains missing. HTTP latency averages describe successful observations and do not substitute for the health panels. Provisioned JSON is authoritative: export UI edits and incorporate them into the chart before upgrading. Dashboard ConfigMaps restore the dashboard following Grafana pod replacement when its sidecar is correctly configured.

Three optional warning rules cover unhealthy peers, failed scrapes and repeated Kubernetes discovery errors. By default they require 5 minutes before firing. `up == 0` covers targets that remain discovered but cannot be scraped; it does not catch a missing ServiceMonitor, an entire disappeared target set, or nodes where an agent was never scheduled. Check DaemonSet coverage and Prometheus Targets as well. The chart does not configure receivers or send notifications itself.

## Upgrade or uninstall

Use the same release name, namespace and values file for upgrades. Changing selector names (`nameOverride`) after installation can require recreating the DaemonSet; retain them across upgrades.

```bash
helm --kubeconfig 02test.yaml uninstall goldpinger -n eea-monitoring
```

Uninstall removes chart-owned resources, including its dashboard ConfigMap. It does not delete the shared namespace, externally managed RBAC or Grafana UI changes saved elsewhere.

## Validation

See `VALIDATION.md` for the checks performed on this package and their limits. It has not been installed on an EEA cluster during preparation.

## Upstream

- Goldpinger: <https://github.com/bloomberg/goldpinger>
- Application source tag: <https://github.com/bloomberg/goldpinger/tree/v3.11.5>
- EEA separately managed RBAC: <https://github.com/eea/helm-charts/tree/main/sources/goldpinger-rbac>

This chart is an EEA-oriented deployment package, not the upstream Bloomberg chart. The upstream application binary is not modified. The chart bundles customized static HTML pages for graph-only mode and optional target labels, retaining the upstream license headers.

## Target display labels

Optional `goldpinger.targetLabels` entries replace the labels of additional DNS, TCP and HTTP(S) target nodes in the connectivity graph. Match each key exactly to its configured target, including scheme, port, path and trailing slash where present. Targets without a label continue to display their original address.

```yaml
goldpinger:
  dnsTargets:
    - kubernetes.default.svc.cluster.local
  tcpTargets:
    - kubernetes.default.svc.cluster.local:443
  httpTargets:
    - https://www.google.com/
  targetLabels:
    kubernetes.default.svc.cluster.local: Cluster DNS resolution
    "kubernetes.default.svc.cluster.local:443": Kubernetes API TCP
    "https://www.google.com/": Google HTTPS
```

Configure the map through **Edit YAML** when installing or upgrading in Rancher, or in a Helm values file. `targetLabels` defaults to `{}`. It is a map, not a list or a string. Labels work with both `graphOnly: true` and `graphOnly: false`.

Only the displayed text changes. Probe destinations, graph node IDs, peer-node names, edge status/latency and Prometheus metric labels remain unchanged. Click a target node to see its original address and diagnostic data. Duplicate display labels are allowed, but distinct names are easier to read. An unmatched map key has no effect; for example, `https://www.google.com` does not match `https://www.google.com/`.

A label is not a probe definition: keep ports out of `dnsTargets`, use `host:port` for `tcpTargets`, and a full URL for `httpTargets`. Labeling a literal IP as a DNS query does not make it one: Goldpinger's hostname lookup can return a literal IP without contacting DNS.

The chart serves a customized HTML page whenever graph-only mode or target labels are enabled. Changes to labels update the page checksum and roll the agents so that their mounted page is refreshed. After upgrading, reload the browser page; use a hard refresh if it still shows old labels. With `graphOnly: false` and no labels, the unmodified page supplied by the image is used. The custom pages are based on application version 3.11.5 and need review when upgrading the image.

## Graph-only interface

`goldpinger.graphOnly` defaults to `true` and appears as **Show graph only** in Rancher's installation/upgrade form. It keeps the connectivity graph, Goldpinger title and Reload button and removes the Data, Heatmap, Raw and Metrics navigation. Node interactions and existing diagnostic error handling are retained. The page refreshes on demand using Reload; it does not add automatic refresh.

Set `goldpinger.graphOnly: false` to restore the full upstream page. This changes presentation only: API endpoints and their service-proxy permissions remain unchanged.

The customized page is derived from Goldpinger 3.11.5's Apache-2.0-licensed `static/index.html`, retaining its license header. Helm mounts it read-only at `/static/index.html` using a ConfigMap; the official image and its other static assets remain in use. Page changes trigger a DaemonSet rollout through a checksum annotation. Changing the option also updates pod mounts, so the switch takes effect after rollout. Review this page when upgrading the Goldpinger application image.

## Option to only enable the goldpinger connectivity graph in the UI (0.1.4)

## Default namespace supplied for the goldpinger Grafana dashboard (0.1.5)

## Expanded Readme regarding the Goldpinger navlink and graphical UI access (0.1.6)

## Added graph labels for checks that involve non-Goldpinger resources (0.1.7)

## Updated Readme (0.1.8) 


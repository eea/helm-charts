# EEA Goldpinger (No separate RBAC chart required)

Goldpinger monitors connectivity between Kubernetes pods running on different nodes. This chart deploys one non-root agent on each eligible Linux node, a ClusterIP service for its connectivity graph, and a dedicated service account with namespace-only permission to list pods. It complements Blackbox Exporter: Goldpinger shows the network between per-node agents, while Blackbox checks configured destinations.

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

These examples do not assume cluster-specific IP addresses. The namespace `eea-monitoring` can be shared with Blackbox; all names and discovery selectors are specific to this release.

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

These permissions apply only within the installation namespace. A label selector filters discovery; it does not restrict the account's authorization. The account can list full pod specifications for all pods in that namespace, including Blackbox pods and literal environment values, but cannot list pods elsewhere, read Secret objects, fetch pod logs, exec into pods or modify resources through this Role. Restrict installation/upgrades and pod modification/exec access to infrastructure administrators. Splitting RBAC into another Helm release does not remove the workload's ability to use its assigned service-account permissions.

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

Uninstall removes chart-owned resources, including its dashboard ConfigMap. It does not delete the shared namespace, Blackbox resources, externally managed RBAC or Grafana UI changes saved elsewhere.

## Validation

See `VALIDATION.md` for the checks performed on this package and their limits. It has not been installed on an EEA cluster during preparation.

## Upstream

- Goldpinger: <https://github.com/bloomberg/goldpinger>
- Application source tag: <https://github.com/bloomberg/goldpinger/tree/v3.11.5>
- EEA separately managed RBAC: <https://github.com/eea/helm-charts/tree/main/sources/goldpinger-rbac>

This chart is an EEA-oriented deployment package, not the upstream Bloomberg chart. No upstream application source is modified or bundled.

## Graph-only interface

`goldpinger.graphOnly` defaults to `true` and appears as **Show graph only** in Rancher's installation/upgrade form. It keeps the connectivity graph, Goldpinger title and Reload button and removes the Data, Heatmap, Raw and Metrics navigation. Node interactions and existing diagnostic error handling are retained. The page refreshes on demand using Reload; it does not add automatic refresh.

Set `goldpinger.graphOnly: false` to restore the full upstream page. This changes presentation only: API endpoints and their service-proxy permissions remain unchanged.

The customized page is derived from Goldpinger 3.11.5's Apache-2.0-licensed `static/index.html`, retaining its license header. Helm mounts it read-only at `/static/index.html` using a ConfigMap; the official image and its other static assets remain in use. Page changes trigger a DaemonSet rollout through a checksum annotation. Changing the option also updates pod mounts, so the switch takes effect after rollout. Review this page when upgrading the Goldpinger application image.

## Option to only enable the goldpinger connectivity graph in the UI (0.1.4)

## Default namespace supplied for the goldpinger Grafana dashboard (0.1.5)

Prometheus Blackbox Exporter checks service availability from the kubernetes internal network perspective using HTTP/HTTPS, TCP, DNS and ICMP probes, exposing their success and duration as Prometheus metrics.

The EEA Helm chart deploys an exporter pod on each eligible Kubernetes worker, providing a per-worker view of connectivity to internal and external services. 
Reusable probe modules are supplied by default, while targets and cluster-specific settings are configured through Helm values. 
The chart integrates with Rancher Monitoring through ServiceMonitors and an optional Grafana dashboard showing collection health, probe status and duration, with host and probe filters.

The examples folder provides some pre-defined tests which you can use - or define your own.

# EEA Blackbox Exporter Helm chart

## Architecture

- DaemonSet: one exporter pod per eligible node, pod network (not hostNetwork).
- ServiceMonitor: **one ServiceMonitor per target**, each discovers the DaemonSet pods individually via Service endpoints. The `source_node` label comes from pod discovery metadata.
- No ingress, cluster-wide RBAC, or elevated Linux capabilities.
- Target-specific status: `probe_success{probe_name="api-service",source_node="..."}`. A missing time series is **not** a success; monitor `up` and target discovery separately.

## Install

```bash
helm lint ./blackbox-exporter
helm template bb ./blackbox-exporter -n eea-monitoring -f ./blackbox-exporter/examples/values-02test.yaml
helm upgrade --install bb ./blackbox-exporter -n eea-monitoring --create-namespace -f ./blackbox-exporter/examples/values-02test.yaml
```

The `serviceMonitor.enabled=true` option requires the ServiceMonitor CRD. Configure `serviceMonitor.labels` to match your Prometheus `serviceMonitorSelector`. Prometheus must also select the namespace in which the chart is installed.

The default chart has no targets and monitoring disabled. It is deliberately cluster-neutral. The 02test example uses a 60-second scrape interval and the verified DNS Service `rke2-coredns-rke2-coredns.kube-system.svc.cluster.local:53`. Verify DNS names in other clusters.

## Rancher questions

Simple fields are exposed in `questions.yaml`. Edit advanced structures (e.g. `tolerations`, `nodeSelector`, `affinity`, `serviceMonitor.targets`, `config.modules`) in Rancher's YAML values editor. Some Rancher versions do not render arbitrary YAML arrays as convenient form fields.

## Example queries

```promql
probe_success{probe_name="api-service"}
min_over_time(probe_success{probe_name="api-service"}[5m])
sum_over_time((probe_success == bool 0)[1h:30s])
```

For per-node missing-series detection, alert on absent probe data or use an expected-node inventory metric in addition to `probe_success`.

## Important caveats

- DNS probes resolve the DNS server hostname before sending the DNS query. To test a specific DNS server independently, use its ClusterIP as the target and adjust the module query name.
- `kubernetes.default.svc:443` tests TCP connectivity to the API Service, not authenticated API health.
- These probes originate from the DaemonSet pod, not arbitrary application pods. Cross-node pod-to-pod testing needs dedicated stable endpoints, not a load-balanced Service.
- NetworkPolicy is not included. ICMP probing is available through `icmp_ipv4`; Linux requires a group allowed by `net.ipv4.ping_group_range` or the `NET_RAW` capability.
- The image tag is a starting value: review/pin a vetted version before production rollout.
- Validate Prometheus Operator's EndpointSlice/Endpoints discovery behavior in your environment.

## Grafana dashboard

`grafanaDashboard.enabled` optionally provisions the exported Blackbox state timeline through a ConfigMap. It is disabled by default and enabled in the 02test example. That example writes the ConfigMap to the existing `cattle-dashboards` namespace, watched by Rancher Grafana for `grafana_dashboard: "1"`. The installer needs permission to create ConfigMaps there. No Namespace resource is created.

The query automatically uses the Helm release namespace. Configure `grafanaDashboard.datasourceUid` to match the Grafana Prometheus datasource UID. Values 0 and 1 map to red Failure and green Success. Gaps remain gaps; missing data is not success. New probe targets appear automatically.

The dashboard is provisioned from the chart’s ConfigMap, which is the authoritative source for its configuration. Make lasting changes in dashboards/blackbox.json and apply them through a Helm upgrade. The dashboard uses a fixed UID, so deploy only one copy per Grafana instance unless you assign a different UID to additional copies. Provisioning automatically restores the dashboard after Grafana pod replacement.
Apply locally to 02test after extracting this package:


```bash
helm --kubeconfig 02test.yaml upgrade bb ./blackbox-exporter \
  -n eea-monitoring -f ./blackbox-exporter/examples/values-02test.yaml
```

Version 0.1.1 adds dashboard provisioning and corrects the 02test DNS example. 

## Standard probe modules

The default values define `http_2xx`, `https_internal`, `tcp_connect`, `dns_kubernetes` and `icmp_ipv4`. Defining a module does not start probes. Each cluster selects its targets in `serviceMonitor.targets`; the default target list remains empty. Cluster values can add or override modules for authentication, custom DNS queries or response validation.

To ping Google from each eligible exporter pod, append this entry to the cluster's existing target list:

```yaml
serviceMonitor:
  targets:
    # Keep the cluster's other targets here as well. Helm replaces lists.
    - name: google-ping
      address: google.com
      module: icmp_ipv4
```

ICMP addresses are hostnames or IPs without a URL scheme or port. `icmp_ipv4` disables IPv6 fallback. A hostname also requires DNS resolution. No additional capability is granted by default. If probe diagnostics show an ICMP socket permission error, the cluster can explicitly opt in:

```yaml
securityContext:
  capabilities:
    drop: [ALL]
    add: [NET_RAW]
```

Version 0.1.2 adds the reusable IPv4 ICMP module without adding external targets to the 02test example.

## Dashboard filters and host sections (0.1.3)

Host and Probe filters support multiple selections and default to All. Each selected host has an expanded, repeatable row heading, separating its full-width status timeline from the next host. A separate full-width probe-duration time series follows the timeline and uses seconds (Grafana can format subsecond values automatically). Host choices/headings show the short hostname while filtering by the full source_node label. Distinct FQDNs with the same short name remain distinct filter values.

The filters discover hosts and probes from up metadata in the selected time range and refresh when that range changes. A host with no series in the range will not be listed; the dashboard is not an expected-node inventory. Pod replacements are aggregated into one series per source_node and probe_name. Renaming a probe still creates a separate historical series. Missing data is not connected across gaps. Duration includes failed probes as well as successful ones.

The 02test example now calls its DNS target internal-dns. Renaming changes the probe_name label and temporarily shows both historical names. Retain your own external targets when updating your cluster values; the 0.1.6 example includes the uploaded API, DNS, internal HTTPS, external ping and external TCP targets.

Version 0.1.4 fixes the dashboard filter interpolation: queries use the Prometheus datasource's default variable escaping instead of generic `:regex` formatting. This avoids invalid single-backslash dot escapes in quoted PromQL strings for FQDN host values. Both panel queries and the chained Probe variable query use the corrected interpolation.

## Collection health and stable dashboard series (0.1.5)

Each host section includes collection health (up) per probe, followed by probe status and duration. Collection success does not imply probe success. Failed collection leaves the probe panels blank instead of displaying an older result. Filters use up metadata so a discovered but unsuccessfully scraped target remains selectable. Targets absent from discovery still leave gaps; this dashboard does not replace expected-node inventory or missing-exporter alerts. Minimum status/collection health and maximum duration are used during overlapping pod identities. No scheduled restarts are configured.

## Module configuration update (0.1.6)

Includes the supplied values.yaml and examples/values-02test.yaml unchanged. tcp_connect explicitly uses IPv4 without IPv6 fallback. The reusable https_internal module uses IPv4, follows redirects and disables TLS certificate trust and hostname verification; it tests HTTPS reachability and a successful HTTP response rather than certificate validity. http_2xx retains certificate validation.

The 02test targets include NeuVector HTTPS on 8443, Metrics Server /readyz over HTTPS, ICMP to 8.8.8.8 and TCP to google.com:443, alongside API TCP and internal DNS. The optional Google HTTPS entry remains commented out. No new ICMP permissions or restart schedule is enabled.

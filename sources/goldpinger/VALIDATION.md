# Package validation

Prepared on 14 October 2026.

## Version 0.1.2 checks

- Strict Helm lint and both test-cluster renders passed.
- The default NavLink omits `spec.group`, retaining its previous resource name and service target. Named custom groups remain optional.
- Rendered Helm notes show Rancher sidebar access when enabled and port-forward instructions only when the sidebar link is disabled. The ServiceMonitor reminder is removed.
- Dashboard remains disabled in both examples; ServiceMonitor and PrometheusRule remain enabled.
- Live sidebar placement must be verified after upgrade.

## Version 0.1.1 checks

- Helm 3.19.0 strict lint passed.
- Both test-cluster examples rendered with a single cluster-scoped NavLink, ServiceMonitor and PrometheusRule; the Grafana dashboard ConfigMap is absent.
- NavLink targets the release's HTTP service and namespace on port 8080, with path `/`; Rancher's service model adds `/proxy/` itself. Fields checked against Rancher release/v2.14 API types and the Dashboard service/NavLink models.
- Standalone resources match 0.1.0 except chart-version labels and the dependent configuration checksum. The checksum change causes a normal DaemonSet rolling update.
- Missing NavLink API produces an actionable rendering error; optional Grafana provisioning still renders when enabled. Namespace-only list-pods RBAC remains unchanged.
- Rancher sidebar visibility and Grafana dashboard removal require verification after the user upgrades; no live cluster was accessed for this revision.

## Original 0.1.0 validation (unchanged workload and monitoring implementation)

- Helm 3.19.0 strict lint and rendering.
- Render matrix: standalone defaults; test monitoring examples; optional UDP; TLS ingress; externally managed service account/RBAC; second release in another namespace.
- Assertions: no ClusterRole/ClusterRoleBinding, exact namespace-only `list pods` permission, release-specific discovery selector, namespace from the Downward API, host networking disabled, no host ports, stable release-specific dashboard UID, matching Service/DaemonSet/ServiceMonitor selectors and source-node relabeling.
- Expected rejection: missing monitoring CRDs, missing existing service-account name, missing ingress hostname/TLS secret, non-positive refresh interval, unsupported cluster-wide RBAC option, and alert rules enabled without scraping.
- Kubernetes 1.33 schema validation: all 43 built-in resources in the seven successful render scenarios passed. The six monitoring custom resources were initially excluded from built-in validation; the complete 02test render subsequently passed all nine resources using upstream Prometheus Operator ServiceMonitor and PrometheusRule schemas, with no skips.
- Prometheus 3.15.0 promtool: all three alert rules and all ten dashboard PromQL expressions parsed successfully after expanding Grafana variables.
- Alert evaluation tests: all three alerts fire for persistent faults; healthy data produces no alerts; faults from a different release do not trigger this release's rules.
- Public image `docker.io/bloomberg/goldpinger:3.11.5` exists for Linux amd64. Its selected platform manifest digest at preparation was `sha256:4b89d4b8c6b016bbb8643f4ff170b0556cac015b0c190e1be71cefdfc550dab9`.
- The actual binary from that image started locally with the chart environment and chart logging configuration against a mocked Kubernetes API. `/`, `/metrics` and `/check_all` returned HTTP 200. Captured discovery requests used only the installation namespace and exact release labels.

## Limits

No EEA cluster was accessed and no release was installed during preparation. The local binary smoke test ran under the execution environment's current UID; UID 1000 execution was not available there. The manifest configures non-root UID/GID 1000, consistent with upstream's non-root deployment. Real pod admission, CNI connectivity, taint coverage, resource usage, Grafana rendering/sidecar pickup, Prometheus selectors and Alertmanager delivery need to be checked on the chosen test cluster. Optional UDP was validated in the manifests, not through a live cluster network.

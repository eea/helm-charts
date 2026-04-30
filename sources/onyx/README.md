# Dependency updates (when subchart versions are bumped)
* If updating subcharts, you need to run this before committing!
* cd charts/onyx
* helm dependency update .

# Local testing

## One time setup
* brew install kind
* Ensure you have no config at ~/.kube/config
* kind create cluster
* mv ~/.kube/config ~/.kube/kind-config

## Automated install and test with ct
* export KUBECONFIG=~/.kube/kind-config
* kubectl config use-context kind-kind
* from source root run the following. This does a very basic test against the web server
  * ct install --all --helm-extra-set-args="--set=nginx.enabled=false" --debug --config ct.yaml

## Output template to file and inspect
* cd charts/onyx
* helm template test-output . > test-output.yaml

## Test the entire cluster manually
* cd charts/onyx
* helm install onyx . -n onyx --set postgresql.primary.persistence.enabled=false
  * the postgres flag is to keep the storage ephemeral for testing. You probably don't want to set that in prod.
  * no flag for ephemeral vespa storage yet, might be good for testing
* kubectl -n onyx port-forward service/onyx-nginx 8080:80
  * this will forward the local port 8080 to the installed chart for you to run tests, etc.
* When you are finished
  * helm uninstall onyx -n onyx
  * Vespa leaves behind a PVC. Delete it if you are completely done.
    * k -n onyx get pvc
    * k -n onyx delete pvc vespa-storage-da-vespa-0
  * If you didn't disable Postgres persistence earlier, you may want to delete that PVC too.

## Run as non-root user
By default, some onyx containers run as root. If you'd like to explicitly run the onyx containers as a non-root user, update the values.yaml file for the following components:
  * `celery_shared`, `api`, `webserver`, `indexCapability`, `inferenceCapability`
    ```yaml
    securityContext:
      runAsNonRoot: true
      runAsUser: 1001
    ```
  * `vespa`
    ```yaml
    podSecurityContext:
      fsGroup: 1000
    securityContext:
      privileged: false
      runAsUser: 1000
    ```

## Resourcing
In the helm charts, we have resource suggestions for all Onyx-owned components. 
These are simply initial suggestions, and may need to be tuned for your specific use case.

Please talk to us in Slack if you have any questions!

## Autoscaling options
The chart renders Kubernetes HorizontalPodAutoscalers by default. To keep this behavior, leave
`autoscaling.engine` as `hpa` and adjust the per-component `autoscaling.*` values as needed.

If you would like to use KEDA ScaledObjects instead:

1. Install and manage the KEDA operator in your cluster yourself (for example via the official KEDA Helm chart). KEDA is no longer packaged as a dependency of the Onyx chart.
2. Set `autoscaling.engine: keda` in your `values.yaml` and enable autoscaling for the components you want to scale.

When `autoscaling.engine` is set to `keda`, the chart will render the existing ScaledObject templates; otherwise HPAs will be rendered.


## Releases

### Version 0.5.0 - 22 April 2026
- Set chart `appVersion` to `v3.2.1-eea.0.0.106-dev` and keep image tag resolution automatic from chart appVersion when `global.version` is empty.
- Added Vespa migration fix support:
  - optional Vespa deploy proxy (`vespa.deployProxy.*`) that appends `ignoreValidationErrors=true` for `prepareandactivate`.
  - optional no-op ranksetup verification ConfigMap (`vespa.migrationFix.*`) for migration windows.
  - automatic `VESPA_HOST` switch to deploy-proxy service when proxy is enabled.
- Added upstream monitoring integration:
  - optional Grafana dashboard ConfigMap via `monitoring.grafana.dashboards.enabled`.
- Added upstream Code Interpreter integration:
  - `codeInterpreter` dependency and `CODE_INTERPRETER_BASE_URL` env wiring.
  - network policy rules for API/Celery egress to port `8000` and Code Interpreter ingress from backend pods.
- Updated dev values to mount `vespa-verify-ranksetup-bin` from `vespa-noop-verify` ConfigMap and enable the deploy proxy.
- OpenSearch migration note: if API startup fails on `... requires setting [index.knn]`, delete stale old-format index so Onyx can recreate it with k-NN settings.

### Vespa Migration Fix (Documents Migration)

Use this only during Vespa document/schema migration windows:

1. Enable `vespa.migrationFix.enabled: true` to create `vespa-noop-verify`.
2. Mount `vespa-verify-ranksetup-bin` into Vespa at `/opt/vespa/bin/vespa-verify-ranksetup-bin`.
3. Enable `vespa.deployProxy.enabled: true` and point `VESPA_HOST` to the proxy (handled automatically by the chart).
4. Upgrade chart and restart API if needed.

Verification checks:
- `kubectl -n <ns> get deploy <release>-onyx-stack-api-server`
- `kubectl -n <ns> get deploy vespa-deploy-proxy` (or custom proxy name)
- `kubectl -n <ns> get cm vespa-noop-verify`
- `kubectl -n <ns> exec deploy/<release>-onyx-stack-api-server -- wget -qO- http://localhost:8080/health`

### Version 0.4.12 - 18 December 2025
- Release of dependent chart postfix:3.2.0 [EEA Jenkins - [`db97375f`](https://github.com/eea/helm-charts/commit/db97375fccb5b7460fb4809d77e3092727ff2848)]

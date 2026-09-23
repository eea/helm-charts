{{/*
Expand the name of the chart.
*/}}
{{- define "onyx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "onyx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "onyx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "onyx.labels" -}}
helm.sh/chart: {{ include "onyx.chart" . }}
{{ include "onyx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "onyx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "onyx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "onyx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "onyx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Set secret name
*/}}
{{- define "onyx.secretName" -}}
{{- default .secretName .existingSecret }}
{{- end }}

{{/*
Create env vars from secrets (global secrets only — skips entries with allPods: false)
*/}}
{{- define "onyx.envSecrets" -}}
    {{- range $secretSuffix, $secretContent := .Values.auth }}
    {{- /* Note: `| default true` here would be wrong — sprig's `default` treats
           the Go zero value `false` as empty and would silently override an explicit
           `allPods: false`, so restricted entries must be detected via hasKey instead. */}}
    {{- $restricted := and (hasKey $secretContent "allPods") (eq $secretContent.allPods false) }}
    {{- if and (ne $secretContent.enabled false) ($secretContent.secretKeys) (not $restricted) }}
    {{- range $name, $key := $secretContent.secretKeys }}
- name: {{ $name | upper | replace "-" "_" | quote }}
  valueFrom:
    secretKeyRef:
      name: {{ include "onyx.secretName" $secretContent }}
      key: {{ default $name $key }}
    {{- end }}
    {{- end }}
    {{- end }}
{{- end }}

{{/*
Create env vars from secrets restricted to specific pods (entries with allPods: false)
*/}}
{{- define "onyx.envSecretsRestricted" -}}
    {{- range $secretSuffix, $secretContent := .Values.auth }}
    {{- $restricted := and (hasKey $secretContent "allPods") (eq $secretContent.allPods false) }}
    {{- if and (ne $secretContent.enabled false) ($secretContent.secretKeys) $restricted }}
    {{- range $name, $key := $secretContent.secretKeys }}
- name: {{ $name | upper | replace "-" "_" | quote }}
  valueFrom:
    secretKeyRef:
      name: {{ include "onyx.secretName" $secretContent }}
      key: {{ default $name $key }}
    {{- end }}
    {{- end }}
    {{- end }}
{{- end }}

{{/*
Helpers for mounting a psql convenience script into pods.
*/}}
{{- define "onyx.pgInto.enabled" -}}
{{- if and .Values.tooling .Values.tooling.pgInto .Values.tooling.pgInto.enabled }}true{{- end }}
{{- end }}

{{- define "onyx.pgInto.configMapName" -}}
{{- printf "%s-pginto" (include "onyx.fullname" .) -}}
{{- end }}

{{- define "onyx.pgInto.checksumAnnotation" -}}
{{- if (include "onyx.pgInto.enabled" .) }}
checksum/pginto: {{ include (print $.Template.BasePath "/tooling-pginto-configmap.yaml") . | sha256sum }}
{{- end }}
{{- end }}

{{- define "onyx.pgInto.volumeMount" -}}
{{- if (include "onyx.pgInto.enabled" .) }}
- name: pginto-script
  mountPath: {{ default "/usr/local/bin/pginto" .Values.tooling.pgInto.mountPath }}
  subPath: pginto
  readOnly: true
{{- end }}
{{- end }}

{{- define "onyx.pgInto.volume" -}}
{{- if (include "onyx.pgInto.enabled" .) }}
- name: pginto-script
  configMap:
    name: {{ include "onyx.pgInto.configMapName" . }}
    defaultMode: 0755
{{- end }}
{{- end }}

{{/*
Resolve which data caches (HF, tiktoken, NLTK) a component uses. Mount paths are
defined once under hfCache/tiktokenCache/nltkCache so they stay aligned across all
pods; each component opts in or out through its own `caches` block. A cache is on
when it is enabled globally and the component does not set `caches.<name>: false`.
Call with: (dict "ctx" . "caches" .Values.<component>.caches)
Returns JSON: {"hf": bool, "tiktoken": bool, "nltk": bool, "xdgCacheHome": string}
*/}}
{{- define "onyx.caches.resolve" -}}
{{- $v := .ctx.Values -}}
{{- $c := .caches | default dict -}}
{{- $nltk := $v.nltkCache | default dict -}}
{{- $r := dict -}}
{{- $_ := set $r "hf" (and (eq (toString $v.hfCache.enabled) "true") (ne (toString (index $c "hf")) "false")) -}}
{{- $_ := set $r "tiktoken" (and (eq (toString $v.tiktokenCache.enabled) "true") (ne (toString (index $c "tiktoken")) "false")) -}}
{{- $_ := set $r "nltk" (and (eq (toString $nltk.enabled) "true") (ne (toString (index $c "nltk")) "false")) -}}
{{- $_ := set $r "xdgCacheHome" (index $c "xdgCacheHome" | default "") -}}
{{- $r | toJson -}}
{{- end }}

{{/*
Env vars pointing each library at the component's cache directories.
Call with: (dict "ctx" . "caches" .Values.<component>.caches)
*/}}
{{- define "onyx.caches.env" -}}
{{- $r := include "onyx.caches.resolve" . | fromJson -}}
{{- if $r.hf }}
- name: HF_HOME
  value: {{ .ctx.Values.hfCache.mountPath | quote }}
{{- end }}
{{- if $r.tiktoken }}
- name: TIKTOKEN_CACHE_DIR
  value: {{ .ctx.Values.tiktokenCache.mountPath | quote }}
{{- end }}
{{- if $r.nltk }}
- name: NLTK_DATA
  value: {{ .ctx.Values.nltkCache.mountPath | quote }}
{{- end }}
{{- with $r.xdgCacheHome }}
- name: XDG_CACHE_HOME
  value: {{ . | quote }}
{{- end }}
{{- end }}

{{- define "onyx.renderVolumeMounts" -}}
{{- $pginto := include "onyx.pgInto.volumeMount" .ctx -}}
{{- $existing := .volumeMounts -}}
{{- $r := include "onyx.caches.resolve" . | fromJson -}}
{{- if or $pginto $existing $r.hf $r.tiktoken $r.nltk -}}
volumeMounts:
{{- if $r.hf }}
  - name: hf-cache
    mountPath: {{ .ctx.Values.hfCache.mountPath }}
{{- end }}
{{- if $r.tiktoken }}
  - name: tiktoken-cache
    mountPath: {{ .ctx.Values.tiktokenCache.mountPath }}
{{- end }}
{{- if $r.nltk }}
  - name: nltk-cache
    mountPath: {{ .ctx.Values.nltkCache.mountPath }}
{{- end }}
{{- if $pginto }}
{{ $pginto | nindent 2 }}
{{- end }}
{{- if $existing }}
{{ toYaml $existing | nindent 2 }}
{{- end }}
{{- end -}}
{{- end }}

{{/*
Cache emptyDir volumes only; used by templates that render their own volume list.
Call with: (dict "ctx" . "caches" .Values.<component>.caches)
*/}}
{{- define "onyx.caches.volumes" -}}
{{- $r := include "onyx.caches.resolve" . | fromJson -}}
{{- if $r.hf }}
- name: hf-cache
  emptyDir: {}
{{- end }}
{{- if $r.tiktoken }}
- name: tiktoken-cache
  emptyDir: {}
{{- end }}
{{- if $r.nltk }}
- name: nltk-cache
  emptyDir: {}
{{- end }}
{{- end }}

{{- define "onyx.renderVolumes" -}}
{{- $pginto := include "onyx.pgInto.volume" .ctx -}}
{{- $existing := .volumes -}}
{{- $cacheVols := include "onyx.caches.volumes" . -}}
{{- if or $pginto $existing $cacheVols -}}
volumes:
{{- if $cacheVols }}
{{- $cacheVols | nindent 2 }}
{{- end }}
{{- if $pginto }}
{{ $pginto | nindent 2 }}
{{- end }}
{{- if $existing }}
{{ toYaml $existing | nindent 2 }}
{{- end }}
{{- end -}}
{{- end }}

{{/*
Cache init container — copies baked-in HF/tiktoken/NLTK data from the image into
the component's emptyDirs before the main container starts. Volumes are mounted at
temporary paths so the image's own baked-in content stays visible to the init container.
Call with: (dict "ctx" . "image" "<repo>:<tag>" "caches" .Values.<component>.caches)
*/}}
{{- define "onyx.hfCache.initContainer" -}}
{{- $r := include "onyx.caches.resolve" . | fromJson -}}
{{- if or $r.hf $r.tiktoken $r.nltk }}
- name: hf-cache-init
  image: "{{ .image }}"
  imagePullPolicy: {{ .ctx.Values.global.pullPolicy }}
  command:
    - /bin/sh
    - -c
    - |
      set -e
      {{- if $r.hf }}
      [ -d {{ .ctx.Values.hfCache.mountPath }} ] && cp -r {{ .ctx.Values.hfCache.mountPath }}/. /hf-cache-target || echo "hf cache not found in image, skipping"
      {{- end }}
      {{- if $r.tiktoken }}
      [ -d {{ .ctx.Values.tiktokenCache.mountPath }} ] && cp -r {{ .ctx.Values.tiktokenCache.mountPath }}/. /tiktoken-cache-target || echo "tiktoken cache not found in image, skipping"
      {{- end }}
      {{- if $r.nltk }}
      [ -d {{ .ctx.Values.nltkCache.mountPath }} ] && cp -r {{ .ctx.Values.nltkCache.mountPath }}/. /nltk-cache-target || echo "nltk data not found in image, skipping"
      {{- end }}
      echo "Cache seeded"
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    readOnlyRootFilesystem: true
    privileged: false
    capabilities:
      drop: [ALL]
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      cpu: 500m
      memory: 1Gi
  volumeMounts:
    {{- if $r.hf }}
    - name: hf-cache
      mountPath: /hf-cache-target
    {{- end }}
    {{- if $r.tiktoken }}
    - name: tiktoken-cache
      mountPath: /tiktoken-cache-target
    {{- end }}
    {{- if $r.nltk }}
    - name: nltk-cache
      mountPath: /nltk-cache-target
    {{- end }}
{{- end }}
{{- end }}

{{/*
Return the configured autoscaling engine; defaults to HPA when unset.
*/}}
{{- define "onyx.autoscaling.engine" -}}
{{- $engine := default "hpa" .Values.autoscaling.engine -}}
{{- $engine | lower -}}
{{- end }}

{{/*
"true" when ENABLE_CRAFT is set in configMap, empty otherwise.
*/}}
{{- define "onyx.craftEnabled" -}}
{{- if eq (toString (index .Values.configMap "ENABLE_CRAFT" | default "")) "true" -}}true{{- end -}}
{{- end }}

{{- define "onyx.sandboxProxyHost" -}}
{{- (index .Values.configMap "SANDBOX_PROXY_HOST") | default (printf "%s-sandbox-proxy.%s.svc.cluster.local" (include "onyx.fullname" .) .Release.Namespace) -}}
{{- end }}

{{- define "onyx.sandboxProxyPort" -}}
8080
{{- end }}

{{- define "onyx.sandboxPushDaemonPort" -}}
8731
{{- end }}

{{/* Sandbox egress-proxy env. Mirrors _proxy_main_container_env_vars(). */}}
{{- define "onyx.sandboxProxyEnv" -}}
{{- $proxyUrl := printf "http://sandbox-proxy:%v" .proxyPort }}
- { name: HTTPS_PROXY, value: "{{ $proxyUrl }}" }
- { name: HTTP_PROXY, value: "{{ $proxyUrl }}" }
- { name: https_proxy, value: "{{ $proxyUrl }}" }
- { name: http_proxy, value: "{{ $proxyUrl }}" }
- { name: NO_PROXY, value: "127.0.0.1,localhost" }
- { name: no_proxy, value: "127.0.0.1,localhost" }
- { name: NODE_EXTRA_CA_CERTS, value: "{{ .caBundleFile }}" }
- { name: REQUESTS_CA_BUNDLE, value: "{{ .caBundleFile }}" }
- { name: SSL_CERT_FILE, value: "{{ .caBundleFile }}" }
- { name: AWS_CA_BUNDLE, value: "{{ .caBundleFile }}" }
- { name: CURL_CA_BUNDLE, value: "{{ .caBundleFile }}" }
- { name: GIT_SSL_CAINFO, value: "{{ .caBundleFile }}" }
{{- end }}

{{/*
"true" when custom CA certificates are configured, empty otherwise.
*/}}
{{- define "onyx.customCACerts.enabled" -}}
{{- if and .Values.customCACerts .Values.customCACerts.enabled -}}true{{- end -}}
{{- end }}

{{/*
Volume sourcing the custom CA certificates from a Secret or ConfigMap.
*/}}
{{- define "onyx.customCACerts.volume" -}}
{{- if include "onyx.customCACerts.enabled" . -}}
{{- if and .Values.customCACerts.secretName .Values.customCACerts.configMapName -}}
{{- fail "customCACerts.secretName and customCACerts.configMapName are mutually exclusive; set exactly one" -}}
{{- end -}}
{{- if .Values.customCACerts.secretName -}}
- name: custom-ca-certs
  secret:
    secretName: {{ .Values.customCACerts.secretName }}
{{- else if .Values.customCACerts.configMapName -}}
- name: custom-ca-certs
  configMap:
    name: {{ .Values.customCACerts.configMapName }}
{{- else -}}
{{- fail "customCACerts.enabled is true but neither customCACerts.secretName nor customCACerts.configMapName is set" -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Mount for the custom CA certificates. update-ca-certificates picks up
PEM files with a .crt suffix from /usr/local/share/ca-certificates.
*/}}
{{- define "onyx.customCACerts.volumeMount" -}}
{{- if include "onyx.customCACerts.enabled" . -}}
- name: custom-ca-certs
  mountPath: /usr/local/share/ca-certificates
  readOnly: true
{{- end -}}
{{- end }}

{{/*
Env vars so Python HTTP clients (which default to certifi's bundle) trust
the system bundle regenerated by update-ca-certificates.
*/}}
{{- define "onyx.customCACerts.env" -}}
{{- if include "onyx.customCACerts.enabled" . -}}
- name: REQUESTS_CA_BUNDLE
  value: /etc/ssl/certs/ca-certificates.crt
- name: SSL_CERT_FILE
  value: /etc/ssl/certs/ca-certificates.crt
{{- end -}}
{{- end }}

{{/*
Items to prepend to an exec-form container command so update-ca-certificates
runs first; sh passes the original command through via "$0" "$@".
Emits a single line ending with a comma.
*/}}
{{- define "onyx.customCACerts.commandPrefix" -}}
{{- if include "onyx.customCACerts.enabled" . -}}
"/bin/sh", "-c", "update-ca-certificates && exec \"$0\" \"$@\"",
{{- end -}}
{{- end }}

{{/*
Render a volumeMounts block combining pod-specific mounts (plus this chart's
own pginto/HF/tiktoken mounts, via onyx.renderVolumeMounts) with the custom
CA mount. Usage: include "onyx.volumeMountsWithCA" (dict "ctx" . "volumeMounts" <list>)
*/}}
{{- define "onyx.volumeMountsWithCA" -}}
{{- $rendered := include "onyx.renderVolumeMounts" . -}}
{{- $ca := include "onyx.customCACerts.volumeMount" .ctx -}}
{{- if or $ca $rendered -}}
{{- if $rendered -}}
{{ $rendered }}
{{- if $ca }}
{{ $ca | nindent 2 }}
{{- end }}
{{- else -}}
volumeMounts:
{{- if $ca }}
{{ $ca | nindent 2 }}
{{- end }}
{{- end }}
{{- end -}}
{{- end }}

{{/*
Render a volumes block combining pod-specific volumes (plus this chart's own
pginto/HF/tiktoken/NLTK cache volumes, via onyx.renderVolumes) with the custom CA volume.
Usage: include "onyx.volumesWithCA" (dict "ctx" . "volumes" <list>)
*/}}
{{- define "onyx.volumesWithCA" -}}
{{- $rendered := include "onyx.renderVolumes" . -}}
{{- $ca := include "onyx.customCACerts.volume" .ctx -}}
{{- if or $ca $rendered -}}
{{- if $rendered -}}
{{ $rendered }}
{{- if $ca }}
{{ $ca | nindent 2 }}
{{- end }}
{{- else -}}
volumes:
{{- if $ca }}
{{ $ca | nindent 2 }}
{{- end }}
{{- end }}
{{- end -}}
{{- end }}

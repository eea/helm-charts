{{/*
Expand the name of the chart.
*/}}
{{- define "appl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "appl.fullname" -}}
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
{{- define "appl.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "appl.labels" -}}
helm.sh/chart: {{ include "appl.chart" . }}
{{ include "appl.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "appl.selectorLabels" -}}
app.kubernetes.io/name: {{ include "appl.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "appl.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "appl.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Resolve the release version used in BACKEND_VERSION and SENTRY_RELEASE.
*/}}
{{- define "cca-backend.releaseVersion" -}}
{{- if .component.releaseVersion -}}
{{- .component.releaseVersion -}}
{{- else if .root.Values.releaseVersion -}}
{{- .root.Values.releaseVersion -}}
{{- else -}}
{{- .root.Chart.AppVersion -}}
{{- end -}}
{{- end }}

{{/*
Render the shared Plone-related environment variables.
*/}}
{{- define "cca-backend.backendEnv" -}}
{{- $root := .root -}}
{{- $component := .component | default dict -}}
{{- $env := merge (deepCopy (default dict $root.Values.commonEnv)) (deepCopy (default dict $component.environment)) -}}
{{- $reserved := list "SERVER_NAME" "SENTRY_SITE" "GRAYLOG_FACILITY" "BACKEND_VERSION" "SENTRY_RELEASE" "TZ" "RELSTORAGE_DSN" "REDIS_HOST" "REDIS_PORT" -}}
- name: SERVER_NAME
  value: "{{ $root.Values.plone.hostname }}"
- name: SENTRY_SITE
  value: "{{ $root.Values.plone.hostname }}"
- name: GRAYLOG_FACILITY
  value: "{{ $root.Values.plone.hostname }}"
- name: BACKEND_VERSION
  value: "{{ include "cca-backend.releaseVersion" (dict "root" $root "component" $component) }}"
- name: SENTRY_RELEASE
  value: "{{ include "cca-backend.releaseVersion" (dict "root" $root "component" $component) }}"
- name: TZ
  value: "{{ $root.Values.timezone }}"
- name: RELSTORAGE_DSN
  value: "host='postgres' dbname='{{ $root.Values.plone.database.POSTGRES_DB }}' user='{{ $root.Values.plone.database.POSTGRES_USER }}' password='{{ $root.Values.plone.database.POSTGRES_PASSWORD }}'"
{{- if $root.Values.redis.enabled }}
- name: REDIS_HOST
  value: "redis"
- name: REDIS_PORT
  value: "6379"
{{- end }}
{{- range $key, $value := $env }}
{{- if and $value (not (has $key $reserved)) }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Shared PVC-backed mounts used by the Plone family of workloads.
*/}}
{{- define "cca-backend.sharedVolumeMounts" -}}
{{- if .Values.persistence.data.enabled }}
- name: shared-data
  mountPath: {{ .Values.persistence.data.mountPath }}
{{- end }}
{{- if .Values.persistence.import.enabled }}
- name: import-data
  mountPath: {{ .Values.persistence.import.mountPath }}
{{- end }}
{{- if .Values.persistence.legacyImport.enabled }}
- name: legacy-import-data
  mountPath: {{ .Values.persistence.legacyImport.mountPath }}
{{- end }}
{{- if .Values.persistence.sources.enabled }}
- name: sources-data
  mountPath: {{ .Values.persistence.sources.mountPath }}
{{- end }}
{{- end }}

{{/*
Shared PVC-backed volumes used by the Plone family of workloads.
*/}}
{{- define "cca-backend.sharedVolumes" -}}
{{- if .Values.persistence.data.enabled }}
- name: shared-data
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.data.existingClaim | default (printf "%s-shared-data" .Release.Name) }}
{{- end }}
{{- if .Values.persistence.import.enabled }}
- name: import-data
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.import.existingClaim | default (printf "%s-import" .Release.Name) }}
{{- end }}
{{- if .Values.persistence.legacyImport.enabled }}
- name: legacy-import-data
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.legacyImport.existingClaim | default (printf "%s-legacy-import" .Release.Name) }}
{{- end }}
{{- if .Values.persistence.sources.enabled }}
- name: sources-data
  persistentVolumeClaim:
    claimName: {{ .Values.persistence.sources.existingClaim | default (printf "%s-sources" .Release.Name) }}
{{- end }}
{{- end }}

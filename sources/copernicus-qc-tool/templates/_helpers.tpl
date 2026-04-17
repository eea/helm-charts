{{/* Expand the name of the chart. */}}
{{- define "qctool.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create a default fully qualified app name. */}}
{{- define "qctool.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "qctool.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "qctool.labels" -}}
helm.sh/chart: {{ include "qctool.chart" . }}
{{ include "qctool.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels */}}
{{- define "qctool.selectorLabels" -}}
app.kubernetes.io/name: {{ include "qctool.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Service account name */}}
{{- define "qctool.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "qctool.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/* Service names */}}
{{- define "qctool.frontendServiceName" -}}
{{- printf "%s-frontend" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.nextcloudServiceName" -}}
{{- printf "%s-nextcloud" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.databaseServiceName" -}}
{{- printf "%s-database" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.mariadbServiceName" -}}
{{- printf "%s-db" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.redisServiceName" -}}
{{- printf "%s-redis" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.postfixServiceName" -}}
{{- if .Values.postfix.serviceName -}}
{{- .Values.postfix.serviceName -}}
{{- else if .Values.postfix.fullnameOverride -}}
{{- .Values.postfix.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-postfix" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Workload names */}}
{{- define "qctool.frontendName" -}}
{{- printf "%s-frontend" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.workerName" -}}
{{- printf "%s-worker" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.nextcloudName" -}}
{{- printf "%s-nextcloud" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.nextcloudCronName" -}}
{{- printf "%s-nextcloudcron" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.mariadbName" -}}
{{- printf "%s-db" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.redisName" -}}
{{- printf "%s-redis" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.volumeTesterName" -}}
{{- printf "%s-volume-tester" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Claim names */}}
{{- define "qctool.claimName" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $volume := .volume -}}
{{- if $volume.existingClaim -}}
{{- $volume.existingClaim -}}
{{- else -}}
{{- printf "%s-%s" (include "qctool.fullname" $root) ($name | kebabcase) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* URLs */}}
{{- define "qctool.workerPullJobUrl" -}}
{{- if .Values.worker.pullJobUrl -}}
{{- .Values.worker.pullJobUrl -}}
{{- else -}}
{{- printf "http://%s:%v/pull_job" (include "qctool.frontendServiceName" .) .Values.frontend.service.port -}}
{{- end -}}
{{- end -}}

{{- define "qctool.frontendPublicUrl" -}}
{{- printf "https://%s" .Values.ingress.frontend.host -}}
{{- end -}}

{{- define "qctool.frontendApiUrl" -}}
{{- printf "%s/api" (include "qctool.frontendPublicUrl" .) -}}
{{- end -}}

{{- define "qctool.frontendCsrfTrustedOrigins" -}}
{{- printf "%s,http://localhost,http://127.0.0.1" (include "qctool.frontendPublicUrl" .) -}}
{{- end -}}

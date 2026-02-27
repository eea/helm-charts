{{/* Expand the name of the chart. */}}
{{- define "appl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Create a default fully qualified app name. */}}
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

{{/* Create chart name and version as used by the chart label. */}}
{{- define "appl.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "appl.labels" -}}
helm.sh/chart: {{ include "appl.chart" . }}
{{ include "appl.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "appl.selectorLabels" -}}
app.kubernetes.io/name: {{ include "appl.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Service account name */}}
{{- define "appl.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "appl.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Secret name */}}
{{- define "appl.secretName" -}}
{{- if .Values.secrets.create }}
{{- printf "%s-secret" (include "appl.fullname" .) }}
{{- else }}
{{- .Values.secrets.existingSecret }}
{{- end }}
{{- end }}

{{/* Service names */}}
{{- define "appl.webServiceName" -}}
{{- printf "%s-web" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.databaseServiceName" -}}
{{- printf "%s-database" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.mailserverServiceName" -}}
{{- printf "%s-mailserver" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.webserverServiceName" -}}
{{- printf "%s-webserver" (include "appl.fullname" .) }}
{{- end }}

{{/* Workload names */}}
{{- define "appl.webName" -}}
{{- printf "%s-web" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.cronName" -}}
{{- printf "%s-cron" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.databaseName" -}}
{{- printf "%s-database" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.backupName" -}}
{{- printf "%s-backupdb" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.mailserverName" -}}
{{- printf "%s-mailserver" (include "appl.fullname" .) }}
{{- end }}

{{- define "appl.webserverName" -}}
{{- printf "%s-webserver" (include "appl.fullname" .) }}
{{- end }}

{{/* Shared PVC names */}}
{{- define "appl.staticClaimName" -}}
{{- if .Values.persistence.staticfiles.existingClaim }}
{{- .Values.persistence.staticfiles.existingClaim }}
{{- else }}
{{- printf "%s-staticfiles" (include "appl.fullname" .) }}
{{- end }}
{{- end }}

{{- define "appl.loggingClaimName" -}}
{{- if .Values.persistence.logging.existingClaim }}
{{- .Values.persistence.logging.existingClaim }}
{{- else }}
{{- printf "%s-logging" (include "appl.fullname" .) }}
{{- end }}
{{- end }}

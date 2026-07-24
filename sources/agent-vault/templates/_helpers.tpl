{{- define "agent-vault.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "agent-vault.fullname" -}}
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

{{- define "agent-vault.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "agent-vault.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "agent-vault.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agent-vault.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "agent-vault.vault.fullname" -}}
{{- printf "%s-vault" (include "agent-vault.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "agent-vault.vault.selectorLabels" -}}
{{ include "agent-vault.selectorLabels" . }}
component: vault
{{- end -}}

{{- define "agent-vault.proxy.fullname" -}}
{{- printf "%s-proxy" (include "agent-vault.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "agent-vault.proxy.selectorLabels" -}}
{{ include "agent-vault.selectorLabels" . }}
component: proxy
{{- end -}}

{{- define "agent-vault.postgres.fullname" -}}
{{- printf "%s-postgres" (include "agent-vault.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "agent-vault.postgres.selectorLabels" -}}
{{ include "agent-vault.selectorLabels" . }}
component: postgres
{{- end -}}

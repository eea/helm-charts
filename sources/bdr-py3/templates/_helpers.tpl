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
Use a caller-managed Secret when configured, otherwise use the Secret rendered
by this chart.
*/}}
{{- define "appl.instanceSecretName" -}}
{{- default (printf "%s-instance-env" (include "appl.fullname" .)) .Values.instance.existingSecret }}
{{- end }}

{{/*
The admin auth Secret can likewise be supplied externally. Both nginx and
Traefik references must use this helper so switching ingress implementations
keeps the selected Secret name.
*/}}
{{- define "appl.adminAuthSecretName" -}}
{{- default (printf "%s-admin-basic-auth" (include "appl.fullname" .)) .Values.apache.adminAuth.existingSecret }}
{{- end }}

{{/*
Use a caller-managed sync token Secret when configured, otherwise use the
Secret rendered by this chart.
*/}}
{{- define "appl.syncTokenSecretName" -}}
{{- default (printf "%s-sync-tokens" (include "appl.fullname" .)) .Values.cron.tokenSecretName }}
{{- end }}

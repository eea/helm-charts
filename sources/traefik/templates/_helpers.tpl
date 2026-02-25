{{- define "traefik.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "traefik.fullname" -}}
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

{{- define "traefik.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "traefik.labels" -}}
helm.sh/chart: {{ include "traefik.chart" . }}
app.kubernetes.io/name: {{ include "traefik.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "traefik.selectorLabels" -}}
app.kubernetes.io/name: {{ include "traefik.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "traefik.prometheusName" -}}
{{- printf "%s-prometheus" (include "traefik.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "traefik.grafanaName" -}}
{{- printf "%s-grafana" (include "traefik.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

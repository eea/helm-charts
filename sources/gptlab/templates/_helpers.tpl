{{/*
Expand the name of the chart.
*/}}
{{- define "gptlab.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gptlab.fullname" -}}
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
{{- define "gptlab.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Compute dynamic image tag based on appVersion and prefix
*/}}
{{- define "gptlab.computeImageTag" -}}
{{- $prefix := .prefix }}
{{- $appVersion := .Chart.AppVersion -}}
{{- printf "%s%s" $prefix $appVersion }}
{{- end }}

{{/*
Get image tag for a service with fallback to computed value
*/}}
{{- define "gptlab.imageTag" -}}
{{- $service := .service }}
{{- $serviceMap := index .Values "services" $service }}
{{- if hasKey $serviceMap "image" }}
  {{- if and (hasKey $serviceMap.image "tag") $serviceMap.image.tag (ne $serviceMap.image.tag "") }}
    {{- $serviceMap.image.tag }}
  {{- else if hasKey $serviceMap.image "prefix" }}
    {{- $prefix := $serviceMap.image.prefix }}
    {{- include "gptlab.computeImageTag" (dict "prefix" $prefix "Chart" .Chart) }}
  {{- else }}
    {{- .Chart.AppVersion }}
  {{- end }}
{{- else }}
  {{- .Chart.AppVersion }}
{{- end }}
{{- end }}

{{/*
Safely handle environment variables, omitting them if value is empty
*/}}
{{- define "gptlab.env" -}}
{{- $name := .name }}
{{- $value := .value }}
{{- if $value }}
- name: {{ $name }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gptlab.labels" -}}
helm.sh/chart: {{ include "gptlab.chart" . }}
{{ include "gptlab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gptlab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gptlab.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gptlab.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gptlab.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}




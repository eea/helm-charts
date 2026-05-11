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
Whether an Apache front proxy should be placed in front of Tomcat.
*/}}
{{- define "appl.apacheEnabled" -}}
{{- if and .Values.apache .Values.apache.enabled -}}
true
{{- else -}}
false
{{- end -}}
{{- end }}

{{/*
Name of the service exposed to ingress and end users.
*/}}
{{- define "appl.frontServiceName" -}}
{{- include "appl.fullname" . -}}
{{- end }}

{{/*
Port exposed by the front service.
*/}}
{{- define "appl.frontServicePort" -}}
{{- if eq (include "appl.apacheEnabled" .) "true" -}}
80
{{- else -}}
{{- .Values.service.port -}}
{{- end -}}
{{- end }}

{{/*
Internal Tomcat service name.
When Apache is enabled, Tomcat gets a dedicated internal service.
*/}}
{{- define "appl.tomcatServiceName" -}}
{{- if eq (include "appl.apacheEnabled" .) "true" -}}
{{- printf "%s-tomcat" (include "appl.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "appl.fullname" . -}}
{{- end -}}
{{- end }}

{{/*
Front component selected by ingress.
*/}}
{{- define "appl.frontComponent" -}}
{{- if eq (include "appl.apacheEnabled" .) "true" -}}
apache
{{- else -}}
frontend
{{- end -}}
{{- end }}

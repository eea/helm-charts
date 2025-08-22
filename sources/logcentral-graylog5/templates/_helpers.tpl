{{/*
Expand the name of the chart.
*/}}
{{- define "logcentral-graylog5.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "logcentral-graylog5.fullname" -}}
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
{{- define "logcentral-graylog5.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "logcentral-graylog5.labels" -}}
helm.sh/chart: {{ include "logcentral-graylog5.chart" . }}
{{ include "logcentral-graylog5.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "logcentral-graylog5.selectorLabels" -}}
app.kubernetes.io/name: {{ include "logcentral-graylog5.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "logcentral-graylog5.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "logcentral-graylog5.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Postfix labels
*/}}
{{- define "logcentral-graylog5.postfix.labels" -}}
{{ include "logcentral-graylog5.labels" . }}
app.kubernetes.io/component: postfix
{{- end }}

{{/*
Postfix selector labels
*/}}
{{- define "logcentral-graylog5.postfix.selectorLabels" -}}
{{ include "logcentral-graylog5.selectorLabels" . }}
app.kubernetes.io/component: postfix
{{- end }}

{{/*
MongoDB labels
*/}}
{{- define "logcentral-graylog5.mongodb.labels" -}}
{{ include "logcentral-graylog5.labels" . }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
MongoDB selector labels
*/}}
{{- define "logcentral-graylog5.mongodb.selectorLabels" -}}
{{ include "logcentral-graylog5.selectorLabels" . }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
Graylog Master labels
*/}}
{{- define "logcentral-graylog5.graylog-master.labels" -}}
{{ include "logcentral-graylog5.labels" . }}
app.kubernetes.io/component: graylog-master
{{- end }}

{{/*
Graylog Master selector labels
*/}}
{{- define "logcentral-graylog5.graylog-master.selectorLabels" -}}
{{ include "logcentral-graylog5.selectorLabels" . }}
app.kubernetes.io/component: graylog-master
{{- end }}

{{/*
Graylog Client labels
*/}}
{{- define "logcentral-graylog5.graylog-client.labels" -}}
{{ include "logcentral-graylog5.labels" . }}
app.kubernetes.io/component: graylog-client
{{- end }}

{{/*
Graylog Client selector labels
*/}}
{{- define "logcentral-graylog5.graylog-client.selectorLabels" -}}
{{ include "logcentral-graylog5.selectorLabels" . }}
app.kubernetes.io/component: graylog-client
{{- end }}

{{/*
Load Balancer labels
*/}}
{{- define "logcentral-graylog5.loadbalancer.labels" -}}
{{ include "logcentral-graylog5.labels" . }}
app.kubernetes.io/component: loadbalancer
{{- end }}

{{/*
Load Balancer selector labels
*/}}
{{- define "logcentral-graylog5.loadbalancer.selectorLabels" -}}
{{ include "logcentral-graylog5.selectorLabels" . }}
app.kubernetes.io/component: loadbalancer
{{- end }}

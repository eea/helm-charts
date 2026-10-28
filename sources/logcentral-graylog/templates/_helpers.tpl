{{/*
Expand the name of the chart.
*/}}
{{- define "appl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
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
app.kubernetes.io/name: {{ include "appl.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
MongoDB: StatefulSet, Secret and ConfigMap name, and its headless Service.
*/}}
{{- define "appl.mongodbName" -}}
{{- printf "%s-mongodb" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "appl.mongodbHeadless" -}}
{{- printf "%s-headless" (include "appl.mongodbName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
MongoDB selector labels
*/}}
{{- define "appl.mongodbSelectorLabels" -}}
app.kubernetes.io/name: {{ include "appl.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
Replica set members, comma separated: <sts>-<i>.<headless>.<namespace>.svc.cluster.local:27017
*/}}
{{- define "appl.mongodbMembers" -}}
{{- $hosts := list }}
{{- range $i := until (int .Values.mongodb.replicas) }}
{{- $hosts = append $hosts (printf "%s-%d.%s.%s.svc.cluster.local:27017" (include "appl.mongodbName" $) $i (include "appl.mongodbHeadless" $) $.Release.Namespace) }}
{{- end }}
{{- join "," $hosts }}
{{- end }}

{{/*
Full name the official graylog subchart gives its resources: the release name when it already
contains "graylog", else "<release>-graylog" (e.g. Service "<this>-svc").
*/}}
{{- define "appl.graylogFullname" -}}
{{- if contains "graylog" .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-graylog" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

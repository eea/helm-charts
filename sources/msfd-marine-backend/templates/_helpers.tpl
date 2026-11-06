{{/*
Expand the name of the chart.
*/}}
{{- define "appl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
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
Block the Plone/Zope portal_modifier remote code execution vector
(Plone security fix 20261110).

Zope acquisition makes portal_modifier reachable at any depth in the path
(/portal_modifier/..., /folder/page/portal_modifier/...), so match the whole
normalised, percent-decoded $uri instead of a fixed prefix. Ingress-nginx
resolves ".." and duplicated slashes, so /%70ortal_modifier and //portal_modifier
are covered as well.

Applied as a server-snippet so it is evaluated before any location/rewrite
from the individual ingress rules.
*/}}
{{- define "appl.blockPortalModifier" -}}
nginx.ingress.kubernetes.io/server-snippet: |
  if ($uri ~* "portal_modifier") {
    return 403;
  }
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

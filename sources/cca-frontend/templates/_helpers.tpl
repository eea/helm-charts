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
Create a release-specific name for component-scoped resources.
*/}}
{{- define "cca-frontend.componentName" -}}
{{- printf "%s-%s" (include "appl.fullname" .root) .component | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Resolve the release version used in frontend release-related env vars.
*/}}
{{- define "cca-frontend.releaseVersion" -}}
{{- if .Values.releaseVersion -}}
{{- .Values.releaseVersion -}}
{{- else -}}
{{- .Chart.AppVersion -}}
{{- end -}}
{{- end }}

{{/*
Resolve the public URL used by Volto and generated robots.txt.
*/}}
{{- define "cca-frontend.publicURL" -}}
{{- if .Values.volto.environment.RAZZLE_PUBLIC_URL -}}
{{- .Values.volto.environment.RAZZLE_PUBLIC_URL -}}
{{- else -}}
{{- printf "%s://%s" (.Values.volto.publicScheme | default "https") .Values.volto.hostname -}}
{{- end -}}
{{- end }}

{{/*
Resolve the backend path used by VirtualHostBase rewrites.
*/}}
{{- define "cca-frontend.virtualHostRoot" -}}
{{- .Values.backend.virtualHostRoot | default "cca" | trimPrefix "/" | trimSuffix "/" -}}
{{- end }}

{{/*
Default robots.txt content, generated from the public URL when not overridden.
*/}}
{{- define "cca-frontend.robotsTxt" -}}
{{- if .Values.volto.environment.VOLTO_ROBOTSTXT -}}
{{- .Values.volto.environment.VOLTO_ROBOTSTXT -}}
{{- else -}}
Sitemap: {{ include "cca-frontend.publicURL" . }}/sitemap-index.xml
User-agent: *
Disallow: /sandbox
Disallow: /en/sandbox
Disallow: /admin
Disallow: /_admin
Disallow: /contact-footer
Disallow: /en/observatory/metadata/
Disallow: /de/observatory/metadata/
Disallow: /fr/observatory/metadata/
Disallow: /es/observatory/metadata/
Disallow: /it/observatory/metadata/
Disallow: /pl/observatory/metadata/
Disallow: /@@multilingual-selector
Disallow: /*/observatory/metadata/
Disallow: /*/sandbox
{{- end -}}
{{- end }}

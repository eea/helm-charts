{{- define "gp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "gp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "gp.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- define "gp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- define "gp.labels" -}}
{{ include "gp.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote }}
{{- end -}}
{{- define "gp.serviceAccount" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "gp.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- required "serviceAccount.name must identify an existing service account when serviceAccount.create=false" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
{{- define "gp.dashboardUid" -}}
{{- default (printf "eea-gp-%s" (printf "%s/%s" .Release.Namespace .Release.Name | sha256sum | trunc 16)) .Values.grafanaDashboard.uid -}}
{{- end -}}

{{/* Render the optional custom page for graph-only mode or target labels. */}}
{{- define "gp.uiHtml" -}}
{{- $path := ternary "files/graph-only.html" "files/full-ui.html" .Values.goldpinger.graphOnly -}}
{{- .Files.Get $path | replace "__GOLDPINGER_TARGET_LABELS_JSON__" (mustToJson (mustToJson (default dict .Values.goldpinger.targetLabels))) -}}
{{- end -}}

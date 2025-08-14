{{/*
Dynamically replace image repositories and tags for Danswer images.
Usage:
  {{ include "onyx-stack.image" (dict "image" .Values.webserver.image.repository "tag" .Values.webserver.image.tag "context" .) }}
*/}}
{{- define "onyx-stack.image" -}}
{{- $repo := .image -}}
{{- $tag := .tag -}}
{{- $ctx := .context -}}
{{- if and $ctx.Values.imageMapping.enabled (hasKey $ctx.Values.imageMapping.replacements $repo) -}}
  {{- $replacement := index $ctx.Values.imageMapping.replacements $repo -}}
  {{- $newRepo := $replacement.repo -}}
  {{- $tagSuffix := $replacement.tagSuffix -}}
  {{- if and $tag (ne $tag "") }}
    {{- printf "%s:%s-%s" $newRepo $tagSuffix $tag -}}
  {{- else if and $ctx.Chart.AppVersion (ne $ctx.Chart.AppVersion "") }}
    {{- if hasPrefix "v" $ctx.Chart.AppVersion }}
      {{- printf "%s:%s-%s" $newRepo $tagSuffix $ctx.Chart.AppVersion -}}
    {{- else }}
      {{- printf "%s:%s-v%s" $newRepo $tagSuffix $ctx.Chart.AppVersion -}}
    {{- end }}
  {{- else }}
    {{- printf "%s:%s-latest" $newRepo $tagSuffix -}}
  {{- end }}
{{- else -}}
  {{- if and $tag (ne $tag "") }}
    {{- printf "%s:%s" $repo $tag -}}
  {{- else if and $ctx.Values.global.version (ne $ctx.Values.global.version "") }}
    {{- printf "%s:%s" $repo $ctx.Values.global.version -}}
  {{- else if and $ctx.Chart.AppVersion (ne $ctx.Chart.AppVersion "") }}
    {{- printf "%s:%s" $repo $ctx.Chart.AppVersion -}}
  {{- else }}
    {{- printf "%s:latest" $repo -}}
  {{- end }}
{{- end -}}
{{- end -}}

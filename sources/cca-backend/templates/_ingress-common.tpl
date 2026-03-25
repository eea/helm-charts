{{/*
Common ingress configuration snippet shared by CCA backend routes migrated from Apache.
*/}}
{{- define "cca-backend.ingressCommonConfigurationSnippet" -}}
proxy_set_header X-Forwarded-Host {{ .Values.plone.hostname }};
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Port 443;
{{- end }}

{{/*
Security headers previously set by Apache.
X-Frame-Options remains disabled for embed-chart paths, matching the old behavior.
*/}}
{{- define "cca-backend.ingressSecurityHeaders" -}}
if ($request_uri !~ "^/.*embed-chart") {
  more_set_headers "X-Frame-Options: SAMEORIGIN";
}
more_set_headers "Strict-Transport-Security: max-age=15768000;";
more_set_headers "X-Content-Type-Options: nosniff";
more_set_headers "Referrer-Policy: strict-origin-when-cross-origin";
more_set_headers "Expect-CT: max-age=604800, report-uri=https://sentry.eea.europa.eu/api/25/security/?sentry_key=36e966c526304fb38680f19ac1927bb5";
more_set_headers "Server: HTTPS";
more_set_headers "X-XSS-Protection: 1";
{{- end }}

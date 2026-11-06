{{/*
Common ingress configuration snippet shared by CCA backend routes migrated from Apache.
*/}}
{{- define "cca-backend.ingressCommonConfigurationSnippet" -}}
proxy_set_header X-Forwarded-Host {{ .Values.plone.hostname }};
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Port 443;
{{- end }}

{{/*
Edge guard for the CMFEditions portal_modifier tool.

portal_modifier is an OFS OrderedFolder mounted in the portal root, so it is
reachable from the web through any URL that reaches classic Plone traversal.
The cca-* ingresses talk to the backend varnish directly, bypassing the
frontend nginx (which carries the same guard in its own config), so it is
repeated here as defence in depth. Blocking the path at the edge is the
mitigation recommended on community.plone.org while the upstream fix is
prepared.

$uri is the normalised, percent-decoded path, so /portal%5Fmodifier and
/a/b/portal_modifier are matched too. Nothing in Climate-ADAPT has a content
id or view named portal_modifier, so this cannot produce false 403s.
*/}}
{{- define "cca-backend.ingressClassicToolGuard" -}}
if ($uri ~* "portal_modifier") {
  return 403;
}
{{- end -}}

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

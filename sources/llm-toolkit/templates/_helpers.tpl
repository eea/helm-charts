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
{{- if .Values.langfuse.serviceAccount.create }}
{{- default (include "appl.fullname" .) .Values.langfuse.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.langfuse.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return PostgreSQL hostname
*/}}
{{- define "appl.postgresql.hostname" -}}
{{- if .Values.postgresql.host }}
{{- .Values.postgresql.host }}
{{- else if .Values.postgresql.deploy }}
{{- printf "%s-postgresql" (include "appl.fullname" .) -}}
{{- end }}
{{- end }}

{{/*
Return Redis hostname
*/}}
{{- define "appl.redis.hostname" -}}
{{- if .Values.redis.host }}
{{- .Values.redis.host }}
{{- else if .Values.redis.deploy }}
{{- printf "%s-%s-master" (include "appl.fullname" .) (default "redis" .Values.redis.nameOverride) -}}
{{- else }}
{{- fail "redis.host must be set when redis.deploy is false" }}
{{- end }}
{{- end }}

{{/*
Return ClickHouse hostname (without protocol)
*/}}
{{- define "appl.clickhouse.hostname" -}}
{{- if .Values.clickhouse.host }}
{{- if hasPrefix "http://" .Values.clickhouse.host -}}
{{- trimPrefix "http://" .Values.clickhouse.host -}}
{{- else if hasPrefix "https://" .Values.clickhouse.host -}}
{{- trimPrefix "https://" .Values.clickhouse.host -}}
{{- else -}}
{{- .Values.clickhouse.host -}}
{{- end -}}
{{- else if .Values.clickhouse.deploy }}
{{- printf "%s-clickhouse" (include "appl.fullname" .) -}}
{{- else }}
{{- fail "clickhouse.host must be set when clickhouse.deploy is false" }}
{{- end }}
{{- end }}

{{/*
Return S3/MinIO endpoint -- if not set uses auto-discovery
*/}}
{{- define "appl.minio.endpoint" -}}
{{- if or .Values.minio.eventUpload.endpoint .Values.minio.endpoint }}
{{- .Values.minio.eventUpload.endpoint | default .Values.minio.endpoint }}
{{- else if .Values.minio.deploy }}
{{- printf "http://%s-%s:9000" (include "appl.fullname" .) (default "minio" .Values.minio.nameOverride) -}}
{{- else }}
{{- end }}
{{- end }}

{{/*
Get a value from either a direct value or a secret reference, or nothing if neither is provided
*/}}
{{- define "appl.getValueOrSecret" -}}
{{- if (and .value.secretKeyRef.name .value.secretKeyRef.key) -}}
{{- if .value.value -}}
{{- fail (printf ".value and .secretKeyRef are mutually exclusive for %s" .key) -}}
{{- end -}}
valueFrom:
  secretKeyRef:
    name: {{ .value.secretKeyRef.name }}
    key: {{ .value.secretKeyRef.key }}
{{- else if .value.value -}}
value: {{ .value.value | quote }}
{{- end -}}
{{- end -}}

{{/*
    Get a required value from either a direct value or a secret reference
*/}}
{{- define "appl.getRequiredValueOrSecret" -}}
{{- with (include "appl.getValueOrSecret" .) -}}
{{ . }}
{{- else -}}
{{ fail (printf "no valid value or secretKeyRef provided for %s" .key) }}
{{- end -}}
{{- end -}}

{{/*
Get value of a specific environment variable from additionalEnv if it exists
*/}}
{{- define "appl.getEnvVar" -}}
{{- $envVarName := .name -}}
{{- range .env -}}
{{- if eq .name $envVarName -}}
{{ .value }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
    Database related configurations by environment variables
    Compare with https://langfuse.com/self-hosting/configuration#environment-variables
*/}}
{{- define "appl.databaseEnv" -}}
{{- with (include "appl.getEnvVar" (dict "env" .Values.langfuse.additionalEnv "name" "DATABASE_URL")) -}}
{{/*
    If DATABASE_URL is set, we do nothing in databaseEnv.
*/}}
{{- else -}}
- name: DATABASE_HOST
  value: {{ include "appl.postgresql.hostname" . | quote }}
{{- if .Values.postgresql.port }}
- name: DATABASE_PORT
  value: {{ .Values.postgresql.port | quote }}
{{- end }}
{{- if .Values.postgresql.auth.username }}
- name: DATABASE_USERNAME
  value: {{ .Values.postgresql.auth.username | quote }}
{{- end }}
- name: DATABASE_PASSWORD
{{- if .Values.postgresql.auth.existingSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.auth.existingSecret }}
      key: {{ required "postgresql.auth.secretKeys.userPasswordKey is required when using an existing secret" .Values.postgresql.auth.secretKeys.userPasswordKey }}
{{- else }}
  value: {{ required "Using an existing secret or postgresql.auth.password is required" .Values.postgresql.auth.password | quote }}
{{- end }}
{{- end }}
{{- if .Values.postgresql.auth.database }}
- name: DATABASE_NAME
  value: {{ .Values.postgresql.auth.database | quote }}
{{- end }}
{{- if .Values.postgresql.args }}
- name: DATABASE_ARGS
  value: {{ .Values.postgresql.args | quote }}
{{- end }}
{{- if .Values.postgresql.directUrl }}
- name: DIRECT_URL
  value: {{ .Values.postgresql.directUrl | quote }}
{{- end }}
{{- if .Values.postgresql.shadowDatabaseUrl }}
- name: SHADOW_DATABASE_URL
  value: {{ .Values.postgresql.shadowDatabaseUrl | quote }}
{{- end }}
- name: LANGFUSE_AUTO_POSTGRES_MIGRATION_DISABLED
  value: {{ not .Values.postgresql.migration.autoMigrate | quote }}
{{- end -}}

{{/*
    Langfuse Server related configurations by environment variables
    Compare with https://langfuse.com/self-hosting/configuration#environment-variables
*/}}
{{- define "appl.serverEnv" -}}
- name: NODE_ENV
  value: {{ .Values.langfuse.nodeEnv | quote }}
- name: LANGFUSE_LOG_LEVEL
  value: {{ .Values.langfuse.logging.level | quote }}
- name: LANGFUSE_LOG_FORMAT
  value: {{ .Values.langfuse.logging.format | quote }}
{{- with (include "appl.getRequiredValueOrSecret" (dict "key" "appl.salt" "value" .Values.langfuse.salt) ) }}
- name: SALT
  {{- . | nindent 2 }}
{{- end }}
{{- with (include "appl.getValueOrSecret" (dict "key" "appl.encryptionKey" "value" .Values.langfuse.encryptionKey) ) }}
- name: ENCRYPTION_KEY
  {{- . | nindent 2 }}
{{- end }}
{{- with (include "appl.getValueOrSecret" (dict "key" "appl.licenseKey" "value" .Values.langfuse.licenseKey)) }}
- name: LANGFUSE_EE_LICENSE_KEY
  {{- . | nindent 2 }}
{{- end }}
- name: TELEMETRY_ENABLED
  value: {{ .Values.langfuse.features.telemetryEnabled | quote }}
- name: AUTH_DISABLE_SIGNUP
  value: {{ .Values.langfuse.features.signUpDisabled | quote }}
- name: ENABLE_EXPERIMENTAL_FEATURES
  value: {{ .Values.langfuse.features.experimentalFeaturesEnabled | quote }}
{{- end -}}

{{/*
    NextAuth related configurations by environment variables
    Compare with https://langfuse.com/self-hosting/configuration#environment-variables
*/}}
{{- define "appl.nextauthEnv" -}}
- name: NEXTAUTH_URL
  value: {{ .Values.langfuse.nextauth.url | quote }}
- name: NEXTAUTH_SECRET
  {{- include "appl.getRequiredValueOrSecret" (dict "key" "appl.nextauth.secret" "value" .Values.langfuse.nextauth.secret) | nindent 2 }}
{{- end -}}

{{/*
    Redis related configurations by environment variables
    Compare with https://langfuse.com/self-hosting/configuration#environment-variables
*/}}
{{- define "appl.redisEnv" -}}
- name: REDIS_PASSWORD
{{- if .Values.redis.auth.existingSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.redis.auth.existingSecret }}
      key: {{ required "redis.auth.existingSecretPasswordKey is required when using an existing secret" .Values.redis.auth.existingSecretPasswordKey }}
{{- else }}
  value: {{ required "Using an existing secret or redis.auth.password is required" .Values.redis.auth.password | quote }}
{{- end }}
- name: REDIS_TLS_ENABLED
  value: {{ .Values.redis.tls.enabled | quote }}
- name: REDIS_CONNECTION_STRING
  value: "{{ if .Values.redis.tls.enabled }}rediss{{ else }}redis{{ end }}://{{ .Values.redis.auth.username }}:$(REDIS_PASSWORD)@{{ include "appl.redis.hostname" . }}:{{ .Values.redis.port }}/{{ .Values.redis.auth.database }}"
{{- if .Values.redis.tls.enabled }}
{{- if .Values.redis.tls.caPath }}
- name: REDIS_TLS_CA_PATH
  value: {{ .Values.redis.tls.caPath | quote }}
{{- end }}
{{- if .Values.redis.tls.certPath }}
- name: REDIS_TLS_CERT_PATH
  value: {{ .Values.redis.tls.certPath | quote }}
{{- end }}
{{- if .Values.redis.tls.keyPath }}
- name: REDIS_TLS_KEY_PATH
  value: {{ .Values.redis.tls.keyPath | quote }}
{{- end }}
{{- end }}
{{- end -}}


{{/*
Return ClickHouse protocol (http or https)
*/}}
{{- define "appl.clickhouse.protocol" -}}
{{- if .Values.clickhouse.host }}
{{- if hasPrefix "https://" .Values.clickhouse.host -}}
{{- print "https" -}}
{{- else -}}
{{- print "http" -}}
{{- end -}}
{{- else -}}
{{- print "http" -}}
{{- end -}}
{{- end }}

{{/*
    Clickhouse related configurations by environment variables
    Compare with https://langfuse.com/self-hosting/configuration#environment-variables
*/}}
{{- define "appl.clickhouseEnv" -}}
- name: CLICKHOUSE_MIGRATION_URL
  {{- if .Values.clickhouse.migration.url }}
  value: {{ .Values.clickhouse.migration.url | quote }}
  {{- else }}
  value: "clickhouse://{{ include "appl.clickhouse.hostname" . }}:{{ .Values.clickhouse.nativePort }}"
  {{- end }}
- name: CLICKHOUSE_MIGRATION_SSL
  value: {{ .Values.clickhouse.migration.ssl | quote }}
- name: CLICKHOUSE_URL
  value: "{{ include "appl.clickhouse.protocol" . }}://{{ include "appl.clickhouse.hostname" . }}:{{ .Values.clickhouse.httpPort }}"
- name: CLICKHOUSE_USER
  value: {{ required "clickhouse.auth.username is required" .Values.clickhouse.auth.username | quote }}
- name: CLICKHOUSE_PASSWORD
{{- if .Values.clickhouse.auth.existingSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.clickhouse.auth.existingSecret }}
      key: {{ required "clickhouse.auth.existingSecretKey is required when using an existing secret" .Values.clickhouse.auth.existingSecretKey }}
{{- else }}
  value: {{ required "Configuring an existing secret or clickhouse.auth.password is required" .Values.clickhouse.auth.password | quote }}
{{- end }}
{{- if $.Values.clickhouse.replicaCount | int | eq 1 }}
- name: CLICKHOUSE_CLUSTER_ENABLED
  value: "false"
{{- end }}
- name: LANGFUSE_AUTO_CLICKHOUSE_MIGRATION_DISABLED
  value: {{ not .Values.clickhouse.migration.autoMigrate | quote }}
{{- end -}}

{{/*
    Get a minio related config by value or secret. Lookup the bucket value, if not found lookup the shared config.
    If no value or secret is found, return an empty value (e.g. for role IRSA on AWS)
*/}}
{{- define "appl.getS3ValueOrSecret" -}}
{{- with (include "appl.getValueOrSecret" (dict "key" (printf ".Values.minio.%s.%s" .bucket .key) "value" (index .values .bucket .key)) ) -}}
{{- . }}
{{- else }}
{{- with (include "appl.getValueOrSecret" (dict "key" (printf ".Values.minio.%s" .key) "value" (index .values .key)) ) -}}
{{- . }}
{{- else -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
    S3/MinIO related configurations by environment variables
    Compare with https://langfuse.com/self-hosting/configuration#environment-variables
*/}}
{{- define "appl.s3Env" -}}
- name: LANGFUSE_S3_EVENT_UPLOAD_BUCKET
{{- if $.Values.minio.deploy }}
  value: {{ required "minio.[eventUpload].bucket is required" (coalesce .Values.minio.eventUpload.bucket .Values.minio.bucket .Values.minio.defaultBuckets) | quote }}
{{- else }}
  value: {{ required "minio.[eventUpload].bucket is required" (.Values.minio.eventUpload.bucket | default .Values.minio.bucket) | quote }}
{{- end }}
{{- if .Values.minio.eventUpload.prefix }}
- name: LANGFUSE_S3_EVENT_UPLOAD_PREFIX
  value: {{ .Values.minio.eventUpload.prefix | quote }}
{{- end }}
{{- if or .Values.minio.eventUpload.region .Values.minio.region }}
- name: LANGFUSE_S3_EVENT_UPLOAD_REGION
  value: {{ .Values.minio.eventUpload.region | default .Values.minio.region | quote }}
{{- end }}
{{- with (include "appl.minio.endpoint" .) }}
- name: LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT
  value: {{ . | quote }}
{{- end }}
{{- with (include "appl.getS3ValueOrSecret" (dict "key" "accessKeyId" "bucket" "eventUpload" "values" .Values.minio) ) }}
- name: LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID
  {{- . | nindent 2 }}
{{- else }}
{{- if .Values.minio.deploy }}
- name: LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID
  {{- if and .Values.minio.auth.existingSecret .Values.minio.auth.rootUserSecretKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: {{ .Values.minio.auth.rootUserSecretKey }}
  {{- else }}
  value: {{ .Values.minio.auth.rootUser | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- with (include "appl.getS3ValueOrSecret" (dict "key" "secretAccessKey" "bucket" "eventUpload" "values" .Values.minio) ) }}
- name: LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY
  {{- . | nindent 2 }}
{{- else }}
{{- if .Values.minio.deploy }}
- name: LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY
  {{- if and .Values.minio.auth.existingSecret .Values.minio.auth.rootPasswordSecretKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: {{ .Values.minio.auth.rootPasswordSecretKey }}
  {{- else }}
  value: {{ .Values.minio.auth.rootPassword | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- if or (hasKey .Values.minio.eventUpload "forcePathStyle") (hasKey .Values.minio "forcePathStyle") }}
- name: LANGFUSE_S3_EVENT_UPLOAD_FORCE_PATH_STYLE
  value: {{ .Values.minio.eventUpload.forcePathStyle | default .Values.minio.forcePathStyle | quote }}
{{- end }}
- name: LANGFUSE_S3_BATCH_EXPORT_ENABLED
  value: {{ .Values.minio.batchExport.enabled | quote }}
  {{- if $.Values.minio.batchExport.enabled }}
- name: LANGFUSE_S3_BATCH_EXPORT_BUCKET
{{- if $.Values.minio.deploy }}
  value: {{ required "minio.[batchExport].bucket is required" (coalesce .Values.minio.batchExport.bucket .Values.minio.bucket .Values.minio.defaultBuckets) | quote }}
{{- else }}
  value: {{ required "minio.[batchExport].bucket is required" (.Values.minio.batchExport.bucket | default .Values.minio.bucket) | quote }}
{{- end }}
{{- if or .Values.minio.batchExport.prefix .Values.minio.prefix }}
- name: LANGFUSE_S3_BATCH_EXPORT_PREFIX
  value: {{ .Values.minio.batchExport.prefix | default .Values.minio.prefix | quote }}
{{- end }}
{{- if or .Values.minio.batchExport.region .Values.minio.region }}
- name: LANGFUSE_S3_BATCH_EXPORT_REGION
  value: {{ .Values.minio.batchExport.region | default .Values.minio.region | quote }}
{{- end }}
{{- with (include "appl.minio.endpoint" .) }}
- name: LANGFUSE_S3_BATCH_EXPORT_ENDPOINT
  value: {{ . | quote }}
{{- end }}
{{- with (include "appl.getS3ValueOrSecret" (dict "key" "accessKeyId" "bucket" "batchExport" "values" .Values.minio) ) }}
- name: LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID
  {{- . | nindent 2 }}
{{- else }}
{{- if .Values.minio.deploy }}
- name: LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID
  {{- if and .Values.minio.auth.existingSecret .Values.minio.auth.rootUserSecretKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: {{ .Values.minio.auth.rootUserSecretKey }}
  {{- else }}
  value: {{ .Values.minio.auth.rootUser | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- with (include "appl.getS3ValueOrSecret" (dict "key" "secretAccessKey" "bucket" "batchExport" "values" .Values.minio) ) }}
- name: LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY
  {{- . | nindent 2 }}
{{- else }}
{{- if .Values.minio.deploy }}
- name: LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY
  {{- if and .Values.minio.auth.existingSecret .Values.minio.auth.rootPasswordSecretKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: {{ .Values.minio.auth.rootPasswordSecretKey }}
  {{- else }}
  value: {{ .Values.minio.auth.rootPassword | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- if or (hasKey .Values.minio.batchExport "forcePathStyle") (hasKey .Values.minio "forcePathStyle") }}
- name: LANGFUSE_S3_BATCH_EXPORT_FORCE_PATH_STYLE
  value: {{ .Values.minio.batchExport.forcePathStyle | default .Values.minio.forcePathStyle | quote }}
{{- end }}
{{- end }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_BUCKET
{{- if $.Values.minio.deploy }}
  value: {{ required "minio.[mediaUpload].bucket is required" (coalesce .Values.minio.mediaUpload.bucket .Values.minio.bucket .Values.minio.defaultBuckets) | quote }}
{{- else }}
  value: {{ required "minio.[mediaUpload].bucket is required" (.Values.minio.mediaUpload.bucket | default .Values.minio.bucket) | quote }}
{{- end }}
{{- if or .Values.minio.mediaUpload.prefix .Values.minio.prefix }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_PREFIX
  value: {{ .Values.minio.mediaUpload.prefix | default .Values.minio.prefix | quote }}
{{- end }}
{{- if or .Values.minio.mediaUpload.region .Values.minio.region }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_REGION
  value: {{ .Values.minio.mediaUpload.region | default .Values.minio.region | quote }}
{{- end }}
{{- with (include "appl.minio.endpoint" .) }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT
  value: {{ . | quote }}
{{- end }}
{{- with (include "appl.getS3ValueOrSecret" (dict "key" "accessKeyId" "bucket" "mediaUpload" "values" .Values.minio) ) }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID
  {{- . | nindent 2 }}
{{- else }}
{{- if .Values.minio.deploy }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID
  {{- if and .Values.minio.auth.existingSecret .Values.minio.auth.rootUserSecretKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: {{ .Values.minio.auth.rootUserSecretKey }}
  {{- else }}
  value: {{ .Values.minio.auth.rootUser | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- with (include "appl.getS3ValueOrSecret" (dict "key" "secretAccessKey" "bucket" "mediaUpload" "values" .Values.minio) ) }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY
  {{- . | nindent 2 }}
{{- else }}
{{- if .Values.minio.deploy }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY
  {{- if and .Values.minio.auth.existingSecret .Values.minio.auth.rootPasswordSecretKey }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: {{ .Values.minio.auth.rootPasswordSecretKey }}
  {{- else }}
  value: {{ .Values.minio.auth.rootPassword | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- if or (hasKey .Values.minio.mediaUpload "forcePathStyle") (hasKey .Values.minio "forcePathStyle") }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_FORCE_PATH_STYLE
  value: {{ .Values.minio.mediaUpload.forcePathStyle | default .Values.minio.forcePathStyle | quote }}
{{- end }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_MAX_CONTENT_LENGTH
  value: {{ .Values.minio.mediaUpload.maxContentLength | quote }}
- name: LANGFUSE_S3_MEDIA_UPLOAD_DOWNLOAD_URL_EXPIRY_SECONDS
  value: {{ .Values.minio.mediaUpload.downloadUrlExpirySeconds | quote }}
  {{- if hasKey .Values.minio "concurrency" }}
  {{- if hasKey .Values.minio.concurrency "reads" }}
- name: LANGFUSE_S3_CONCURRENT_READS
  value: {{ .Values.minio.concurrency.reads | quote }}
{{- end }}
{{- if hasKey .Values.minio.concurrency "writes" }}
- name: LANGFUSE_S3_CONCURRENT_WRITES
  value: {{ .Values.minio.concurrency.writes | quote }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Generate TZ environment variable structure
*/}}
{{- define "appl.tzEnvVar" -}}
- name: TZ
  value: {{ .Values.timezone | default "UTC" | quote }}
{{- end -}}

{{/*
Common environment variables for all deployments
*/}}
{{- define "appl.commonEnv" -}}
- name: TZ
  value: {{ .Values.timezone | default "UTC" | quote }}
{{ include "appl.serverEnv" . }}
{{ include "appl.nextauthEnv" . }}
{{ include "appl.databaseEnv" . }}
{{ include "appl.redisEnv" . }}
{{ include "appl.clickhouseEnv" . }}
{{ include "appl.s3Env" . }}
{{- end -}}

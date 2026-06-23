{{/* Expand the name of the chart. */}}
{{- define "qctool.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create a default fully qualified app name. */}}
{{- define "qctool.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "qctool.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "qctool.labels" -}}
helm.sh/chart: {{ include "qctool.chart" . }}
{{ include "qctool.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels */}}
{{- define "qctool.selectorLabels" -}}
app.kubernetes.io/name: {{ include "qctool.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Service account name */}}
{{- define "qctool.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "qctool.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/* Service names */}}
{{- define "qctool.frontendServiceName" -}}
{{- printf "%s-frontend" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.nextcloudServiceName" -}}
{{- printf "%s-nextcloud" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.databaseServiceName" -}}
{{- printf "%s-database" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.mariadbServiceName" -}}
{{- printf "%s-db" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.redisServiceName" -}}
{{- printf "%s-redis" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.postfixServiceName" -}}
{{- if .Values.postfix.serviceName -}}
{{- .Values.postfix.serviceName -}}
{{- else if .Values.postfix.fullnameOverride -}}
{{- .Values.postfix.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-postfix" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Workload names */}}
{{- define "qctool.frontendName" -}}
{{- printf "%s-frontend" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.workerName" -}}
{{- printf "%s-worker" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.nextcloudName" -}}
{{- printf "%s-nextcloud" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.nextcloudCronName" -}}
{{- printf "%s-nextcloudcron" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.mariadbName" -}}
{{- printf "%s-db" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.redisName" -}}
{{- printf "%s-redis" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "qctool.volumeTesterName" -}}
{{- printf "%s-volume-tester" (include "qctool.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Claim names */}}
{{- define "qctool.claimName" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- $volume := .volume -}}
{{- if $volume.existingClaim -}}
{{- $volume.existingClaim -}}
{{- else -}}
{{- printf "%s-%s" (include "qctool.fullname" $root) ($name | kebabcase) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* URLs */}}
{{- define "qctool.workerPullJobUrl" -}}
{{- if .Values.worker.pullJobUrl -}}
{{- .Values.worker.pullJobUrl -}}
{{- else -}}
{{- printf "http://%s:%v/pull_job" (include "qctool.frontendServiceName" .) .Values.frontend.service.port -}}
{{- end -}}
{{- end -}}

{{- define "qctool.frontendPublicUrl" -}}
{{- printf "https://%s" .Values.ingress.frontend.host -}}
{{- end -}}

{{- define "qctool.frontendApiUrl" -}}
{{- printf "%s/api" (include "qctool.frontendPublicUrl" .) -}}
{{- end -}}

{{- define "qctool.frontendCsrfTrustedOrigins" -}}
{{- printf "%s,http://localhost,http://127.0.0.1" (include "qctool.frontendPublicUrl" .) -}}
{{- end -}}

{{/* Sync existing Nextcloud config.php from persistent volumes with Helm values. */}}
{{- define "qctool.nextcloudConfigSyncInitContainer" -}}
- name: sync-nextcloud-config
  image: "{{ .Values.nextcloud.image.repository }}:{{ .Values.nextcloud.image.tag }}"
  imagePullPolicy: {{ .Values.nextcloud.image.pullPolicy }}
  command:
    - /bin/sh
    - -ec
  args:
    - |
      config=/var/www/html/config/config.php
      [ -f "$config" ] || exit 0
      php <<'PHP'
      <?php
      $configFile = '/var/www/html/config/config.php';
      include $configFile;

      if (!isset($CONFIG) || !is_array($CONFIG)) {
          exit(0);
      }

      $changed = false;
      $set = function ($key, $value) use (&$CONFIG, &$changed) {
          if ($value !== '' && (!array_key_exists($key, $CONFIG) || $CONFIG[$key] !== $value)) {
              $CONFIG[$key] = $value;
              $changed = true;
          }
      };

      $trustedDomain = getenv('NEXTCLOUD_TRUSTED_DOMAIN') ?: '';
      if ($trustedDomain !== '') {
          $domains = isset($CONFIG['trusted_domains']) && is_array($CONFIG['trusted_domains'])
              ? $CONFIG['trusted_domains']
              : [];
          if (!in_array($trustedDomain, $domains, true)) {
              $domains[] = $trustedDomain;
              $changed = true;
          }
          $domains = array_values(array_unique($domains));
          if (($CONFIG['trusted_domains'] ?? null) !== $domains) {
              $CONFIG['trusted_domains'] = $domains;
              $changed = true;
          }
          $set('overwrite.cli.url', 'https://' . $trustedDomain);
      }

      $set('dbhost', getenv('MYSQL_HOST') ?: '');

      if (!isset($CONFIG['redis']) || !is_array($CONFIG['redis'])) {
          $CONFIG['redis'] = [];
          $changed = true;
      }
      $redisHost = getenv('REDIS_HOST') ?: '';
      if ($redisHost !== '' && (($CONFIG['redis']['host'] ?? null) !== $redisHost)) {
          $CONFIG['redis']['host'] = $redisHost;
          $changed = true;
      }
      $redisPort = getenv('REDIS_HOST_PORT') ?: '';
      if ($redisPort !== '' && ctype_digit($redisPort)) {
          $redisPort = (int) $redisPort;
          if (($CONFIG['redis']['port'] ?? null) !== $redisPort) {
              $CONFIG['redis']['port'] = $redisPort;
              $changed = true;
          }
      }

      if ($changed) {
          file_put_contents($configFile, "<?php\n\$CONFIG = " . var_export($CONFIG, true) . ";\n");
      }
      PHP
  env:
    - name: NEXTCLOUD_TRUSTED_DOMAIN
      value: {{ .Values.ingress.nextcloud.host | quote }}
    - name: MYSQL_HOST
      value: {{ include "qctool.mariadbServiceName" . | quote }}
    - name: REDIS_HOST
      value: {{ include "qctool.redisServiceName" . | quote }}
    - name: REDIS_HOST_PORT
      value: {{ .Values.redis.service.port | quote }}
  volumeMounts:
    - name: nextcloud-appdata
      mountPath: /var/www/html
{{- end -}}

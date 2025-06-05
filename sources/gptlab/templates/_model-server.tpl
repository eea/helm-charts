{{/*
Common template for model server deployments
*/}}
{{- define "gptlab.modelServer" -}}
{{- $serverName := .serverName }}
{{- $serviceName := .serviceName }}
{{- $imageRepo := .imageRepo }}
{{- $serviceDict := .serviceDict }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "gptlab.fullname" . }}-{{ $serverName }}
  labels:
    {{- include "gptlab.labels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $serverName }}
spec:
  replicas: {{ $serviceDict.replicas }}
  selector:
    matchLabels:
      {{- include "gptlab.selectorLabels" . | nindent 6 }}
      app.kubernetes.io/component: {{ $serverName }}
  template:
    metadata:
      labels:
        {{- include "gptlab.selectorLabels" . | nindent 8 }}
        app.kubernetes.io/component: {{ $serverName }}
    spec:
      containers:
        - name: {{ $serverName }}
          image: "{{ $imageRepo }}:{{ include "gptlab.imageTag" (dict "service" $serviceName "Values" .Values "Chart" .Chart) }}"
          command:
            - /bin/sh
            - -c
            - >-
              if [ "{{ .Values.nlpModel.disableModelServer }}" = "True" ]; then
                echo 'Skipping service...';
                exit 0;
              else
                exec uvicorn model_server.main:app --host 0.0.0.0 --port 9000;
              fi
          ports:
            - containerPort: 9000
              name: http
          env:
            - name: TZ
              value: {{ .Values.timezone | default "UTC" | quote }}
            - name: MIN_THREADS_ML_MODELS
              value: {{ .Values.nlpModel.minThreadsMlModels | quote }}
            {{- if eq $serverName "indexing-model-server" }}
            - name: INDEXING_ONLY
              value: "True"
            {{- end }}
            - name: LOG_LEVEL
              value: {{ .Values.logging.logLevel | quote }}
            - name: SENTRY_DSN
              value: {{ .Values.logging.sentryDsn | quote }}
          volumeMounts:
            - mountPath: /root/.cache/torch/
              name: model-cache-torch
            - mountPath: /root/.cache/huggingface/
              name: model-cache-huggingface
          resources:
            limits:
              memory: {{ $serviceDict.resources.memLimit }}
            requests:
              memory: {{ $serviceDict.resources.memRequest }}
      volumes:
        - name: model-cache-torch
          persistentVolumeClaim:
            claimName: {{ include "gptlab.fullname" . }}-model-cache-torch
        - name: model-cache-huggingface
          persistentVolumeClaim:
            claimName: {{ include "gptlab.fullname" . }}-model-cache-huggingface
{{- end }}

{{/*
Common template for model server services
*/}}
{{- define "gptlab.modelServerService" -}}
{{- $serverName := .serverName }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "gptlab.fullname" . }}-{{ $serverName }}
  labels:
    {{- include "gptlab.labels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $serverName }}
spec:
  ports:
    - port: 9000
      targetPort: 9000
      protocol: TCP
      name: http
  selector:
    {{- include "gptlab.selectorLabels" . | nindent 4 }}
    app.kubernetes.io/component: {{ $serverName }}
{{- end }}
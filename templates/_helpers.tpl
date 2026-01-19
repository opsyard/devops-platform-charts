{{/*
Expand the name of the chart.
*/}}
{{- define "devops-monitor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "devops-monitor.fullname" -}}
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
{{- define "devops-monitor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "devops-monitor.labels" -}}
helm.sh/chart: {{ include "devops-monitor.chart" . }}
{{ include "devops-monitor.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "devops-monitor.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devops-monitor.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Backend labels
*/}}
{{- define "devops-monitor.backend.labels" -}}
{{ include "devops-monitor.labels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Backend selector labels
*/}}
{{- define "devops-monitor.backend.selectorLabels" -}}
{{ include "devops-monitor.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "devops-monitor.frontend.labels" -}}
{{ include "devops-monitor.labels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "devops-monitor.frontend.selectorLabels" -}}
{{ include "devops-monitor.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
PostgreSQL labels
*/}}
{{- define "devops-monitor.postgresql.labels" -}}
{{ include "devops-monitor.labels" . }}
app.kubernetes.io/component: postgresql
{{- end }}

{{/*
PostgreSQL selector labels
*/}}
{{- define "devops-monitor.postgresql.selectorLabels" -}}
{{ include "devops-monitor.selectorLabels" . }}
app.kubernetes.io/component: postgresql
{{- end }}

{{/*
Webhook labels
*/}}
{{- define "devops-monitor.webhook.labels" -}}
{{ include "devops-monitor.labels" . }}
app.kubernetes.io/component: webhook
{{- end }}

{{/*
Webhook selector labels
*/}}
{{- define "devops-monitor.webhook.selectorLabels" -}}
{{ include "devops-monitor.selectorLabels" . }}
app.kubernetes.io/component: webhook
{{- end }}

{{/*
Event Processor labels
*/}}
{{- define "devops-monitor.eventProcessor.labels" -}}
{{ include "devops-monitor.labels" . }}
app.kubernetes.io/component: event-processor
{{- end }}

{{/*
Event Processor selector labels
*/}}
{{- define "devops-monitor.eventProcessor.selectorLabels" -}}
{{ include "devops-monitor.selectorLabels" . }}
app.kubernetes.io/component: event-processor
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "devops-monitor.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "devops-monitor.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create database URL (for backend/event-processor with full access)
*/}}
{{- define "devops-monitor.databaseUrl" -}}
{{- if .Values.postgresql.enabled }}
{{- $host := printf "%s-postgresql" (include "devops-monitor.fullname" .) }}
{{- $port := .Values.postgresql.service.port | toString }}
{{- $user := .Values.postgresql.auth.username }}
{{- $db := .Values.postgresql.auth.database }}
{{- printf "postgresql+asyncpg://%s:$(DATABASE_PASSWORD)@%s:%s/%s" $user $host $port $db }}
{{- else if .Values.externalDatabase.url }}
{{- .Values.externalDatabase.url }}
{{- else }}
{{- $host := .Values.externalDatabase.host }}
{{- $port := .Values.externalDatabase.port | toString }}
{{- $user := .Values.externalDatabase.username }}
{{- $db := .Values.externalDatabase.database }}
{{- printf "postgresql+asyncpg://%s:$(DATABASE_PASSWORD)@%s:%s/%s" $user $host $port $db }}
{{- end }}
{{- end }}

{{/*
Create webhook database URL (for webhook service with limited access)
*/}}
{{- define "devops-monitor.webhookDatabaseUrl" -}}
{{- if .Values.postgresql.enabled }}
{{- $host := printf "%s-postgresql" (include "devops-monitor.fullname" .) }}
{{- $port := .Values.postgresql.service.port | toString }}
{{- $user := .Values.postgresql.auth.webhookUsername }}
{{- $db := .Values.postgresql.auth.database }}
{{- printf "postgresql+asyncpg://%s:$(DATABASE_PASSWORD)@%s:%s/%s" $user $host $port $db }}
{{- else if .Values.externalDatabase.webhookUrl }}
{{- .Values.externalDatabase.webhookUrl }}
{{- else }}
{{- $host := .Values.externalDatabase.host }}
{{- $port := .Values.externalDatabase.port | toString }}
{{- $user := .Values.externalDatabase.webhookUsername | default "webhook_writer" }}
{{- $db := .Values.externalDatabase.database }}
{{- printf "postgresql+asyncpg://%s:$(DATABASE_PASSWORD)@%s:%s/%s" $user $host $port $db }}
{{- end }}
{{- end }}

{{/*
Image pull secrets
*/}}
{{- define "devops-monitor.imagePullSecrets" -}}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}

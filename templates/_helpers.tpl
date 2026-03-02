{{/*
Expand the name of the chart.
*/}}
{{- define "openstatus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "openstatus.fullname" -}}
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
Chart label
*/}}
{{- define "openstatus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openstatus.labels" -}}
helm.sh/chart: {{ include "openstatus.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: openstatus
{{- end }}

{{/*
Selector labels for a component
Usage: {{ include "openstatus.selectorLabels" (dict "context" . "component" "server") }}
*/}}
{{- define "openstatus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openstatus.name" .context }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Component labels (common + selector)
Usage: {{ include "openstatus.componentLabels" (dict "context" . "component" "server") }}
*/}}
{{- define "openstatus.componentLabels" -}}
{{ include "openstatus.labels" .context }}
{{ include "openstatus.selectorLabels" (dict "context" .context "component" .component) }}
{{- end }}

{{/*
Secret name
*/}}
{{- define "openstatus.secretName" -}}
{{- if .Values.existingSecret }}
{{- .Values.existingSecret }}
{{- else }}
{{- include "openstatus.fullname" . }}-secret
{{- end }}
{{- end }}

{{/*
ConfigMap name
*/}}
{{- define "openstatus.configMapName" -}}
{{- include "openstatus.fullname" . }}-config
{{- end }}

{{/*
Image pull secrets
*/}}
{{- define "openstatus.imagePullSecrets" -}}
{{- with .Values.global.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Init container that waits for a service via HTTP
Usage: {{ include "openstatus.waitForHttp" (dict "name" "server" "host" "openstatus-server" "port" "3000" "path" "/ping") }}
*/}}
{{- define "openstatus.waitForHttp" -}}
- name: wait-for-{{ .name }}
  image: busybox:1.36
  command:
    - sh
    - -c
    - |
      echo "Waiting for {{ .name }} at {{ .host }}:{{ .port }}{{ .path }}..."
      until wget -q -O /dev/null http://{{ .host }}:{{ .port }}{{ .path }} 2>/dev/null; do
        echo "{{ .name }} not ready, retrying in 5s..."
        sleep 5
      done
      echo "{{ .name }} is ready."
{{- end }}

{{/*
Init container that waits for a TCP port to be open
Usage: {{ include "openstatus.waitForTcp" (dict "name" "libsql" "host" "openstatus-libsql" "port" "8080") }}
*/}}
{{- define "openstatus.waitForTcp" -}}
- name: wait-for-{{ .name }}
  image: busybox:1.36
  command:
    - sh
    - -c
    - |
      echo "Waiting for {{ .name }} at {{ .host }}:{{ .port }}..."
      until nc -z {{ .host }} {{ .port }} 2>/dev/null; do
        echo "{{ .name }} not ready, retrying in 5s..."
        sleep 5
      done
      echo "{{ .name }} is ready."
{{- end }}

{{/*
LibSQL service host
*/}}
{{- define "openstatus.libsqlHost" -}}
{{- include "openstatus.fullname" . }}-libsql
{{- end }}

{{/*
Tinybird service host
*/}}
{{- define "openstatus.tinybirdHost" -}}
{{- include "openstatus.fullname" . }}-tinybird
{{- end }}

{{/*
Workflows service host
*/}}
{{- define "openstatus.workflowsHost" -}}
{{- include "openstatus.fullname" . }}-workflows
{{- end }}

{{/*
Server service host
*/}}
{{- define "openstatus.serverHost" -}}
{{- include "openstatus.fullname" . }}-server
{{- end }}

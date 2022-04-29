{{/*
Expand the name of the chart.
*/}}
{{- define "graph-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "graph-node.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "graph-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "graph-node.labels" -}}
helm.sh/chart: {{ include "graph-node.chart" . }}
{{ include "graph-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "graph-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "graph-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "graph-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "graph-node.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
combine environment variables with postgres credentials
*/}}

{{- define "graph-node.envFull" }}
{{- range $k, $v := .Values.postgresCredentials -}}
- name: {{ $k }} TODO merge arrays of hashes
{{- end }}
{{- end }}
            - name: postgres_host
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: host
            - name: postgres_user
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: user
            - name: postgres_pass
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: password
            - name: postgres_db
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: graph_db


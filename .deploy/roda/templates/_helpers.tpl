{{- define "app.env" }}
- name: DATABASE_NAME
  value: "{{ .Values.postgres.dbName }}"
- name: DATABASE_PORT
  value: "5432"
- name: DATABASE_USER
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.postgres.secrets.user.name }}"
      key: "{{ .Values.postgres.secrets.user.key }}"
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.postgres.secrets.password.name }}"
      key: "{{ .Values.postgres.secrets.password.key }}"
- name: DATABASE_URL
  value: "postgres://$(DATABASE_USER):$(DATABASE_PASSWORD)@{{ .Values.appName }}-postgres:$(DATABASE_PORT)/$(DATABASE_NAME)"
- name: RACK_ENV
  value: "production"
- name: DOCKER_LOGS
  value: "true"
- name: REDIS_URL
  value: "redis://{{ .Values.appName }}-redis:6379"
- name: REDIS_PORT
  value: "6379"
- name: SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.app.secrets.secretKeyBase.name }}"
      key: "{{ .Values.app.secrets.secretKeyBase.key }}"
{{- end }}

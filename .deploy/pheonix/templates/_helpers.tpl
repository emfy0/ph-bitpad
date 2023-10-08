{{- define "app.env" }}
- name: SECRET_KEY_BASE
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.app.secrets.secretKeyBase.name }}"
      key: "{{ .Values.app.secrets.secretKeyBase.key }}"
- name: DATABASE_NAME
  value: "{{ .Values.app.sqlite.path }}"
{{- end }}

{{- define "app.env" }}
- name: SECRET_KEY_BASE
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.app.secrets.secretKeyBase.name }}"
      key: "{{ .Values.app.secrets.secretKeyBase.key }}"
- name: DATABASE_PATH
  value: "{{ .Values.app.sqlite.path }}/{{ .Values.app.sqlite.filename }}"
{{- end }}

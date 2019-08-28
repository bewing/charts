<?php
$config['install_dir'] = '/opt/librenms';
$config['log_dir'] = '/tmp';
$config['rrd_dir'] = '/opt/librenms/rrd';
{{- if .Values.mariadb.enabled }}
$config['db_host'] = {{ (include "librenms.mariadb.fullname" .) | quote }};
$config['db_port'] = {{ .Values.mariadb.service.port }};
$config['db_user'] = {{ .Values.mariadb.db.user | quote }};
$config['db_pass'] = getenv('DB_PASSWORD');
$config['db_name'] = {{ .Values.mariadb.db.name | quote }};
{{- else }}
$config['db_host'] = {{ .Values.externalDatabase.host | quote }};
$config['db_port'] = {{ .Values.externalDatabase.port }};
$config['db_user'] = {{ .Values.externalDatabase.user | quote }};
$config['db_pass'] = getenv('DB_PASSWORD');
$config['db_name'] = {{ .Values.externalDatabase.name | quote }};
{{- end }}

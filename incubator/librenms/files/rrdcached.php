<?php
{{- if .Values.rrdcached.enabled }}
$config['rrdcached'] = {{ printf "%s:%d" (include "librenms.rrdcached.fullname" . ) (int64 .Values.rrdcached.service.port) | quote }};
{{- else }}
$config['rrdcached'] = {{ printf "%s:%d:" .Values.externalRrdcached.host (int64 .Values.externalRrdcached.port) | quote }};
{{- end }}
$config['rrdtool_version'] = "1.7.0";

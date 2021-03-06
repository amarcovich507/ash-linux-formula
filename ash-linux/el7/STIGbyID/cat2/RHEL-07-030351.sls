# Finding ID:	RHEL-07-030351
# Version:	RHEL-07-030351_rule
# SRG ID:	SRG-OS-000343-GPOS-00134
# Finding Level:	medium
# 
# Rule Summary:
#	The operating system must immediately notify the System
#	Administrator (SA) and Information System Security Officer
#	(ISSO) (at a minimum) via email when the threshold for the
#	repository maximum audit record storage capacity is reached.
#
# CCI-001855 
#    NIST SP 800-53 Revision 4 :: AU-5 (1) 
#
#################################################################
{%- set stig_id = 'RHEL-07-030351' %}
{%- set helperLoc = 'ash-linux/el7/STIGbyID/cat2/files' %}
{%- set audCfg = '/etc/audit/auditd.conf' %}
{%- set parmName = 'space_left_action'%}
{%- set alrtMeth = salt.pillar.get('ash-linux:lookup:audit-space-action', 'email') %}

script_{{ stig_id }}-describe:
  cmd.script:
    - source: salt://{{ helperLoc }}/{{ stig_id }}.sh
    - cwd: /root

{%- if salt.file.file_exists(audCfg) %}
file_{{ stig_id }}-{{ parmName }}:
  file.replace:
    - name: '{{ audCfg }}'
    - pattern: '^\s{{ parmName }}.*$'
    - repl: '{{ parmName }} = {{ alrtMeth }}'
    - append_if_not_found: True
{%- else %}
file_{{ stig_id }}-{{ parmName }}:
  file.append:
    - name: '{{ audCfg }}'
    - text: '{{ parmName }} = {{ alrtMeth }}'
    - makedirs: True
{%- endif %}

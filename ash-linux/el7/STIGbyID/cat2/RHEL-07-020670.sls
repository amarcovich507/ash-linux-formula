# Finding ID:	RHEL-07-020670
# Version:	RHEL-07-020670_rule
# SRG ID:	SRG-OS-000480-GPOS-00227
# Finding Level:	medium
# 
# Rule Summary:
#	All local interactive user home directories must be group-
#	owned by the home directory owners primary group.
#
# CCI-000366 
#    NIST SP 800-53 :: CM-6 b 
#    NIST SP 800-53A :: CM-6.1 (iv) 
#    NIST SP 800-53 Revision 4 :: CM-6 b 
#
#################################################################
{%- set stig_id = 'RHEL-07-020670' %}
{%- set helperLoc = 'ash-linux/el7/STIGbyID/cat2/files' %}
{%- set sysuserMax = salt.cmd.run("awk '/SYS_UID_MAX/{print $2}' /etc/login.defs")|int %}
{%- set userList =  salt.user.list_users() %}

script_{{ stig_id }}-describe:
  cmd.script:
    - source: salt://{{ helperLoc }}/{{ stig_id }}.sh
    - cwd: /root


{%- for user in userList %}
  {%- set userInfo = salt.user.info(user) %}
  {%- set userHome = userInfo['home'] %}
  {%- set userUid = userInfo['uid']|int %}
  {%- set userGid = userInfo['gid']|int %}
  {%- if userUid > sysuserMax %}
fixgroup_{{ stig_id }}-{{ userHome }}:
  file.directory:
    - name: '{{ userHome }}'
    - group: {{ userGid }}

  {%- endif %}
{%- endfor %}

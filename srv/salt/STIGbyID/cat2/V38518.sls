# STIG URL: http://www.stigviewer.com/stig/red_hat_enterprise_linux_6/2014-06-11/finding/V-38518
# Finding ID:	V-38518
# Version:	RHEL-06-000133
# Finding Level:	Medium
#
#     All rsyslog-generated log files must be owned by root. The log files 
#     generated by rsyslog contain valuable information regarding system 
#     configuration, user authentication, and other such information. Log 
#     files should be protected from unauthorized access.
#
############################################################

script_V38518-describe:
  cmd.script:
  - source: salt://STIGbyID/cat2/files/V38518.sh

{% set cfgFile = '/etc/rsyslog.conf' %}

# Define list of syslog "facilities":
#    These will be used to look for matching logging-targets
#    within the /etc/rsyslog.conf file
{% set facilityList = [
	'auth', 
	'authpriv', 
	'cron', 
	'daemon', 
	'kern', 
	'lpr', 
	'mail', 
	'mark', 
	'news', 
	'security', 
	'syslog', 
	'user', 
	'uucp', 
	'local0', 
	'local1', 
	'local2', 
	'local3', 
	'local4', 
	'local5', 
	'local6', 
	'local7',
  ] %}


# Iterate the facility-list to see if there's any active
# logging-targets defined
{% for logFacility in facilityList %}
  {% set srchPat = '^' + logFacility + '\.' %}
  {% if salt['file.search'](cfgFile, srchPat) %}
    {% set cfgStruct = salt['file.grep'](cfgFile, srchPat) %}
    {% set cfgLine = cfgStruct['stdout'] %}
    {% set logTarg = cfgLine[1] %}

notify_V38518-{{ logFacility }}:
  cmd.run:
  - name: 'echo "Logging-target set for ''{{ cfgLine }}({{ logTarg }})'' syslog facility"'
  {% endif %}
{% endfor %}

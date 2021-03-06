# Finding ID:	RHEL-07-010030
# Version:	RHEL-07-010030_rule
# SRG ID:	SRG-OS-000023-GPOS-00006
# Finding Level:	medium
# 
# Rule Summary:
#	The operating system must display the Standard Mandatory DoD
#	Notice and Consent Banner before granting local or remote
#	access to the system via a graphical user logon.
#
# CCI-000048 
#    NIST SP 800-53 :: AC-8 a 
#    NIST SP 800-53A :: AC-8.1 (ii) 
#    NIST SP 800-53 Revision 4 :: AC-8 a 
#
#################################################################
{%- set stig_id = 'RHEL-07-010030' %}
{%- set helperLoc = 'ash-linux/el7/STIGbyID/cat2/files' %}
{%- set pkgName = 'dconf' %}
{%- set dconfDir = '/etc/dconf/db/local.d' %}
{%- set targVal = 'banner-message-enable=true' %}
{%- set headerLabel = 'org/gnome/login-screen' %}
{%- set dconfHeader = '[' + headerLabel + ']' %}
{%- set dconfBanner = dconfDir + '/01-banner-message' %}


script_{{ stig_id }}-describe:
  cmd.script:
    - source: salt://{{ helperLoc }}/{{ stig_id }}.sh
    - cwd: /root

# Check if target RPM is installed
{%- if salt.pkg.version(pkgName) %}
  # Check if a section-header is already present
  {%- if salt.file.search(dconfBanner, '^\[' + headerLabel + '\]') %}
    # Check if a banner-message has already been specified
    {%- if salt.file.search(dconfBanner, targVal) %}
file_{{ stig_id }}-{{ dconfBanner }}:
  cmd.run:
    - name: 'echo "Use of a banner-message already enabled"'
    - cwd: /root
    {%- else  %}
file_{{ stig_id }}-{{ dconfBanner }}:
  file.replace:
    - name: '{{ dconfBanner }}'
    - pattern: '^\[{{ headerLabel }}\]'
    - repl: |
        {{ dconfHeader }}
        {{ targVal }}
    {%- endif  %}
  {%- else %}
file_{{ stig_id }}-{{ dconfBanner }}:
  file.append:
    - name: '{{ dconfBanner }}'
    - text: |
        {{ dconfHeader }}
        {{ targVal }}
  {%- endif %}
{%- else %}
{%- endif %}

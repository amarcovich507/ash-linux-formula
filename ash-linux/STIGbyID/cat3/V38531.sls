# STIG URL: http://www.stigviewer.com/stig/red_hat_enterprise_linux_6/2014-06-11/finding/V-38531
# Rule ID:		
# Finding ID:		V-38531
# Version:		RHEL-06-000174
# SCAP Security ID:	
# Finding Level:	Low
#
#     The operating system must automatically audit account creation. In 
#     addition to auditing new user and group accounts, these watches will 
#     alert the system administrator(s) to any modifications. Any 
#     unexpected users, groups, or modifications should be investigated for 
#     legitimacy.
#
#  CCI: CCI-000018
#  NIST SP 800-53 :: AC-2 (4)
#  NIST SP 800-53A :: AC-2 (4).1 (i&ii)
#  NIST SP 800-53 Revision 4 :: AC-2 (4)
#
############################################################

{%- set stig_id = 'V38531' %}
{%- set helperLoc = 'ash-linux/STIGbyID/cat3/files' %}
{%- set audRulCfg = '/etc/audit/audit.rules' %}
{%- set auditRule = '-p wa -k audit_account_changes' %}
{%- set checkFiles = [
  '/etc/passwd',
  '/etc/group',
  '/etc/shadow',
  '/etc/gshadow',
  '/etc/security/opasswd',
] %}

# Rule prototype
# fullRule = '-w' + ' ' + checkFile + ' ' + auditRule %}

# Output a action description
script_{{ stig_id }}-describe:
  cmd.script:
    - source: salt://{{ helperLoc }}/{{ stig_id }}.sh
    - cwd: /root

# Iterate each file in {{ checkFiles }}
{%- for checkFile in checkFiles %}
  {%- set fullRule = '-w' + ' ' + checkFile + ' ' + auditRule %}

ruleExists_{{ stig_id }}-{{ checkFile }}:
  cmd.run:
    - name: 'echo "STIG-specified audit rule already in place"'
    - onlyif: 'grep -c -E -e "{{ fullRule }}" {{ audRulCfg }}'

ruleAdd_{{ stig_id }}-{{ checkFile }}:
  file.append:
    - name: '{{ audRulCfg }}'
    - text: |

        # Monitor {{ checkFile }} for changes (per STIG-ID {{ stig_id }})
        {{ fullRule }}
    - unless: 'grep -c -E -e "{{ fullRule }}" {{ audRulCfg }}'


# End iteration of file list
{%- endfor %}

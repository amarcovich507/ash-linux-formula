# STIG URL: http://www.stigviewer.com/stig/red_hat_enterprise_linux_6/2014-06-11/finding/V-38513
# Finding ID:	V-38513
# Version:	RHEL-06-000120
# Finding Level:	Medium
#
#     The systems local IPv4 firewall must implement a deny-all, 
#     allow-by-exception policy for inbound packets. In "iptables" the 
#     default policy is applied only after all the applicable rules in the 
#     table are examined for a match. Setting the default policy to "DROP" 
#     implements proper design for a firewall, ...
#
#  CCI: CCI-000066
#  NIST SP 800-53 :: AC-17 e
#  NIST SP 800-53A :: AC-17.1 (v)
#
############################################################

{%- set stig_id = '38513' %}
{%- set helperLoc = 'ash-linux/el6/STIGbyID/cat2/files' %}
{%- set file = '/etc/sysconfig/iptables' %}

script_V{{ stig_id }}-describe:
  cmd.script:
    - source: salt://{{ helperLoc }}/V{{ stig_id }}.sh
    - cwd: '/root'

{%- if not salt['file.file_exists'](file) %}
iptables_V{{ stig_id }}-existing:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: ESTABLISHED,RELATED
    - require_in:
      - module: iptables_V{{ stig_id }}-saveRunning

iptables_V{{ stig_id }}-sshdSafety:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - dport: 22
    - proto: tcp
    - require_in:
      - module: iptables_V{{ stig_id }}-saveRunning
{%- endif %}

iptables_V{{ stig_id }}-inputDefault:
  module.run:
    - name: 'iptables.set_policy'
    - table: filter
    - chain: INPUT
    - policy: DROP

iptables_V{{ stig_id }}-saveRunning:
  module.run:
    - name: 'iptables.save'
    - require:
      - module: iptables_V{{ stig_id }}-inputDefault

service_V{{ stig_id }}:
  service.running:
    - name: iptables
    - enable: True
    - require:
      - module: iptables_V{{ stig_id }}-saveRunning
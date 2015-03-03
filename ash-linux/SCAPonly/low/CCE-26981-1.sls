# This Salt test/lockdown implements a SCAP item that has not yet been
# merged into the DISA-published STIGS
#
# Rule ID:
# - homedir_perms_no_groupwrite_worldread
#
# Security identifiers:
# - CCE-26981-1
#
# Rule Summary: Ensure that User Home Directories are not Group-Writable or 
#               World-Readable.
#
# Rule Text: User home directories contain many configuration files 
#            which affect the behavior of a user's account. No user 
#            should ever have write permission to another user's home 
#            directory. Group shared directories can be configured in 
#            sub-directories or elsewhere in the filesystem if they are 
#            needed. Typically, user home directories should not be 
#            world-readable, as it would disclose file names to other 
#            users. If a subset of users need read access to one 
#            another's home directories, this can be provided using 
#            groups or ACLs.
#
# Note: This finding only requires setting user's home-directory
#       permissions to 750. However, this handler will set user's
#       home directories to mode 700
#
#################################################################

{%- set helperLoc = 'ash-linux/SCAPonly/low/files' %}
{%- set scapId = 'CCE-26981-1' %}

script_{{ scapId }}-describe:
  cmd.script:
    - source: salt://ash-linux/STIGbyID/cat2/files/V38619.sh
    - cwd: '/root'

{% for user in salt['user.getent']('') %}
  {% set ID = user['name'] %}
  {% set homeDir = user['home'] %}

modeset_{{ scapId }}-{{ ID }}:
  file.directory:
    - name: '{{ homeDir }}'
    - user: '{{ ID }}'
    - mode: '0700

{% endfor %}
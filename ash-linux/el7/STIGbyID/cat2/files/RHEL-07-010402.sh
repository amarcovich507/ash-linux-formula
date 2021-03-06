#!/bin/sh
# Finding ID:	RHEL-07-010402
# Version:	RHEL-07-010402_rule
# SRG ID:	SRG-OS-000383-GPOS-00166
# Finding Level:	medium
# 
# Rule Summary:
#	The operating system must prohibit the use of cached SSH
#	authenticators after one day.
#
# CCI-002007 
#    NIST SP 800-53 Revision 4 :: IA-5 (13) 
#
#################################################################
# Standard outputter function
diag_out() {
   echo "${1}"
}

diag_out "----------------------------------------"
diag_out "STIG Finding ID: RHEL-07-010402"
diag_out "   The operating system must prohibit"
diag_out "   the use of cached SSH authenticators"
diag_out "   after one day."
diag_out "----------------------------------------"

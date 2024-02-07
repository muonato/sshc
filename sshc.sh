#!/bin/bash
# muonato/sshc.sh @ GitHub 07-FEB-2024
#
# Simple helper to send command to host(s) over ssh,
# assumes login with ssh-agent (or without password)
#
# Usage:
#       bash sshc.sh <hostsfile>|<hostname> <command>
#
# Parameters:
#       1: Hostname or path to filename
#       2: Command to send over ssh
#
# Examples:
#       $ bash sshc.sh hosts.txt "uptime"
#       = query uptime of hosts listed in file
#
#       $ bash lssw.sh server.domain.net "cat /etc/os-release"
#       = view OS release of specified hostname
#
#       The 'hostsfile' should have one hostname per row
#
#       NOTICE: Verify the command to execute carefully !
#
: ${1?"ERROR: missing hostname or filename"}
: ${2?"ERROR: missing command string to execute"}

CMD=$2

# Test for hostname file
if [[ -f "$1" ]]; then
    while read HOST ; do
        echo -e "\n$HOST\n=============="
        echo "" | ssh $HOST $CMD ;
    done < $1
    echo -e "\nCommand string sent to hosts in '$1'\n"
else
    HOST=$1
    echo "" | ssh $HOST $CMD ;
    echo -e "\nCommand string sent to host '$HOST'\n"
fi

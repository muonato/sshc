#!/bin/bash
# muonato/sshc @ GitHub 10-FEB-2024
#
# Simple helper to ssh commandline to hosts, assumes 
# login with ssh-agent (or without password).
# Hosts may be listed one-per-row in a file and grouped
# with labels in brackets.
#
# Usage:
#       sshc.sh <host | hostsfile> <command> [group]
#
# Parameters:
#       1: Hostname or path to file (required)
#       2: Command to send over ssh (required)
#       3: Group label in hostsfile (optional)
#
# Examples:
#       1. Hosts file may be grouped with brackets
#           $ cat hosts.txt
#           [webhost]
#           frontend.mydomain.net
#           webfront.yoursite.com
#
#           [foobar]
#           foobar-1.mydomain.net
#           foobar-2.mydomain.net
#
#       2. Check uptime of a specific host
#           $ ./sshc.sh myhost.mydomain.net "uptime"
#
#       3. Check version of Apache in hostfile group 'webhost'
#           $ ./sshc.sh hosts.txt "httpd -v" webhost
#
#       4. Verify exclude statement in configuration file
#           $ ./sshc.sh hosts.txt "cat /etc/yum.conf | grep exclude"
#
#       5. Check version of Apache installed in Docker container
#           $ ./sshc.sh hosts.txt "sudo docker exec my-container httpd -v"
#
: ${1?"ERROR: missing hostname or filename"}
: ${2?"ERROR: missing command string to execute"}

# Args
HOSTS=$1
COMND=$2
LABEL=$3

if [[ -f "$HOSTS" ]]; then
    while read ENTRY; do
        BLOCK=$(echo $ENTRY|grep -e '^\[.*\]')
        if [[ $BLOCK ]]; then
            MATCH=$(echo "$ENTRY"|grep "$LABEL")
            if [[ $MATCH ]]; then
                GROUP="TRUE"
                ENTRY=""
            else
                GROUP=""
            fi
        fi
        if [[ $GROUP && $ENTRY ]]; then
            echo -e "\n[\033[1;36m$ENTRY\033[0m]"
            echo "" | ssh $ENTRY $COMND;
        fi
    done < $HOSTS
else
    echo "" | ssh $HOSTS $COMND;
fi

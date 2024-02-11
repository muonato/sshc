#!/bin/bash
# muonato/sshc @ GitHub 11-FEB-2024
#
# Simple helper to send ssh command to hosts, assumes 
# login with ssh-agent (or without password).
# Hosts may be grouped with labels in brackets and listed
# one-per-row in a hostsfile.
#
# Usage:
#       bash sshc.sh <host | hostsfile> <command> [group]
#
# Parameters:
#       1:  Hostname or path to file (required)
#       2:  Command to send over ssh (required)
#           Use "check" to list hosts in hostsfile
#       3:  Group label in hostsfile (optional)
#
# Examples:
#
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
#       3. List hosts in the hostsfile group 'webhost'
#           $ ./sshc.sh hosts.txt "check" "webhost"
#
#       4. Show version of Apache in Docker container of hostsfile group 'webhost'
#           $ ./sshc.sh hosts.txt "sudo docker exec my-container httpd -v" "webhost"
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
            if [[ $COMND == "check" ]]; then
                echo -e "\033[1;36m$ENTRY\033[0m"
            else
                echo -e "\n[\033[1;36m$ENTRY\033[0m]"
                echo "" | ssh $ENTRY $COMND;
            fi
        fi
    done < $HOSTS
else
    echo "" | ssh $HOSTS $COMND;
fi

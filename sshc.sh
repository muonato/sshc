#!/bin/bash
# muonato/sshc @ GitHub 08-APR-2024
#
# Simple helper to send commandline to host(s) over ssh,
# assumes login with ssh-agent (or without password).
# Hosts may be grouped with labels in brackets and listed
# one-per-row in a hostsfile. Comment rows # are ignored.
#
# Usage:
#       bash sshc.sh <host | hostsfile> <command> [group]
#
# Parameters:
#       1:  Hostname or path to file (required)
#       2:  Command to send over ssh (required)
#           Use "check" to list affected hosts
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
#       4. Show version of Apache in hostfile group 'webhost'
#           $ ./sshc.sh hosts.txt "httpd -v" webhost
#
#       5. Show version of Apache in Docker container
#           $ ./sshc.sh hosts.txt "sudo docker exec my-container httpd -v"
#
#       6. Parameters may be written to a separate file
#           $ cat parameters.txt
#           hosts.txt "httpd -v" "webhost"
#           hosts.txt "uptime" "foobar"
#
#       7. Read parameters from a separate file
#           $ xargs -L 1 ./sshc.sh < parameters.txt
#

# Args
HOSTS=${1?"ERROR: missing parameters"}
COMND=$2
LABEL=$3

if [[ -f "$HOSTS" ]]; then
        while read ENTRY; do
        # remove CRLF
        ENTRY=$(echo $ENTRY|tr -d "\r")

                # skip comment rows
                ENTRY=$(echo $ENTRY|grep -v '^#')

                # identify group tags
                BLOCK=$(echo $ENTRY|grep -e '^\[.*\]')

                if [[ $BLOCK ]]; then
                        # match requested group
                        MATCH=$(echo "$ENTRY"|grep "$LABEL")
                        if [[ $MATCH ]]; then
                                GROUP="TRUE"
                                ENTRY=""
                        else
                                GROUP=""
                        fi
                fi
                if [[ -z $LABEL && $ENTRY || $GROUP && $ENTRY ]]; then
                        if [[ $COMND == "check" ]]; then
                                echo -e "\033[1;36m$ENTRY\033[0m"
                        else
                                echo -e "\n[\033[1;36m$ENTRY\033[0m]"
                                echo "" | ssh $ENTRY $COMND;
                        fi
                fi
        done < $HOSTS
else
    EMPTY=$(echo $HOSTS|grep -v '^#')
    if [[ -n $EMPTY ]]; then
        echo "" | ssh $HOSTS $COMND;
    fi
fi

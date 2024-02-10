# sshc
Simple helper to send ssh command to host(s), assumes login with ssh-agent (or without password).

Hosts may be listed one-per-row in a file with group labels in brackets. All hosts in a file will be parsed when a group label is not specified.

## Usage
```
sshc.sh <hostname | hostsfile> <command> [group]
```

## Examples
Hosts file may be grouped with brackets

```
$ cat hosts.txt
[webhost]
frontend.mydomain.net
webfront.yoursite.com

[foobar]
foobar-1.mydomain.net
foobar-2.mydomain.net
```

Query uptime of specific host

```
$ sshc.sh myhost.mydomain.net "uptime"
```

Verify exclude in configuration file for hosts group 'webhost'

```
$ sshc.sh hosts.txt "cat /etc/yum.conf|grep exclude" webhost
```

Check version of Apache installed in Docker container

```
$ sshc.sh hosts.txt "sudo docker exec my-container httpd -v"

```

## Platform
Tested on GNU bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)

# sshc
Simple helper to send ssh command to hosts, assumes login with ssh-agent (or without password).

Hosts may be grouped with labels in brackets and listed one-per-row in a hostsfile. All hosts will be parsed when a group label is not specified.

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
$ ./sshc.sh myhost.mydomain.net "uptime"
```
List hosts in the hostfile group 'webhost'

```
$ ./sshc.sh host.txt "check" "webhost"
```
Verify exclude in configuration file for hostsfile group 'webhost'

```
$ sshc.sh hosts.txt "cat /etc/yum.conf|grep exclude" "webhost"
```

Show version of Apache in Docker container for hostsfile group 'webhost'

```
$ sshc.sh hosts.txt "sudo docker exec httpd-container httpd -v" "webhost"
```

## Platform
Tested on GNU bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)

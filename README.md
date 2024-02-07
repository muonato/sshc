# sshc
Simple helper to send command to host(s) over ssh

## Usage
```
sshc.sh [-r] </path/to/hostsfile>|<hostname> <command>

```

## Examples
Query uptime of specific host

```
$ sshc.sh myhost.mydomain.net "uptime"
```

Verify exclude statement in configuration file

```
$ sshc.sh hosts.txt "cat /etc/yum.conf|grep exclude"
```

Check version of Apache installed in Docker container

```
$ sshc.sh hosts.txt "sudo docker exec my-container httpd -v"

```

Hosts file lists one host per line

```
$ cat hosts.txt
foobar-1.mydomain.net
foobar-2.mydomain.net
snafu.somedomain.com
```

## Platform
Tested on GNU bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)

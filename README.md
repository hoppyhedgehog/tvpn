# tvpn
A VPNC Wrapper Script that allows you to connect to your Cisco VPN using Openconnect instead of using the Native Cisco Client.

I created this for use on MAC OSX Monterey (12.6)+, but it could also be used on Linux.

#  PREREQUISITES

### Root user 
- TVPN is designed to be run AS ROOT

### Homebrew is required.
- To install Homebrew and the prerequisites, I have created brew-setup.sh on his repo as well.


### VPNC Script is required. 
- It is included in /etc/vpnc 
- OR you may [download it from here](https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script)

### OpenConnect is required
- You can install it from [GitHub](https://formulae.brew.sh/formula/openconnect) or use the brew-setup.sh

*Also, the version I used is included in this repo.*

### ruby is required
- ruby should be installed in /usr/bin/ruby on your MAC
* if not see (https://www.ruby-lang.org/en/documentation/installation/)*

### VPN Server
- The IP Address or FQDN of YOUR Company VPN Server

### Credentials
- Your VPN Authentication Credentials
- The credentials should be saved to file /etc/vpnc/.tvpn-credentials


###  Set the SHELL environment

It is recommended that you set the default shell to bash
```
# chsh -s /bin/bash 
```

It is also recommended you download mac_shell_environment_wrapper.sh and copy it to /usr/local/bin/
- Edit $HOME/.bashrc 
```
vi ~/.bashrc
```

Add the following
```
source /usr/local/bin/mac_shell_environment_wrapper.sh
```

- Reload your shell environment 
```
. ~/.bashrc
```
The prompt will change and look similar to
```
[20220928.134409][~/scripts]
[86][root@benmacbook]#
```

## VERIFICATIONS

### Verify GNU Tools are installed 
After installing homebrew essentials) that the following resolv to the HomeBrew 'GNU Linux' Tools in /usr/local/bin
```
# which ls
/usr/local/bin/ls
# which date
/usr/local/bin/date
# which sed
/usr/local/bin/sed
# which awk
/usr/local/bin/awk
# which find
/usr/local/bin/find
# which locate
/usr/local/bin/locate
# which stat
/usr/local/bin/stat
# which xargs
/usr/local/bin/xargs
```


### Verify openconnect is installed
```
# which openconnect
/usr/local/bin/openconnect
```

Verify Version
```
# openconnect --version
OpenConnect version v9.01
Using GnuTLS 3.7.7. Features present: PKCS#11, RSA software token, HOTP software token, TOTP software token, Yubikey OATH, System keys, DTLS, ESP
Supported protocols: anyconnect (default), nc, gp, pulse, f5, fortinet, array
Default vpnc-script (override with --script): /usr/local/etc/vpnc/vpnc-script
```


# Installing TVPN Script

- Download tvpn and copy it to /usr/local/bin

- Verify you copied it as a text file
```
# file /usr/local/bin/tvpn
/usr/local/bin/tvpn: Bourne-Again shell script text executable, ASCII text
```

- Change the permissions to execute (755)

```
# chmod 755 /usr/local/bin/tvpn
```

Verify /usr/local/bin is in your path
```
# echo $PATH|grep local
/usr/local/bin:/usr/local/sbin:/root/perl5/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/var/lib/snapd/snap/bin:/root:/root/scripts:/root/bin:/root/local/bin:/bin:/sbin:/root/bin
```
If not, set the path
```
export PATH=/usr/local/bin:$PATH
```


# Identify your preferred network interface that is active use:

- MAC OSX
```
# scutil --nwi|awk 'BEGIN {s=0} $0 ~ /^IPv4/ {s=1;next} s==1 && $0 ~ /flags/ {intf=$1;next} s==1 && $1 ~ /address/ {ip=$NF; print intf,ip} $1 ~ /REACH/{exit}'
```
[^note]:
EXAMPLE OUTPUT (Single Interface)
```
en9 192.168.1.88
```

[^note]:
EXAMPLE OUTPUT (Multiple Interface)
```
en9 192.168.1.88
en0 192.168.1.13
```

- LINUX
```
## ip -o -f inet addr show
1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever
2: ens192    inet 172.16.242.51/20 brd 172.16.255.255 scope global noprefixroute ens192\       valid_lft forever preferred_lft forever
3: virbr0    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0\       valid_lft forever preferred_lft forever
```



# Create Directory /etc/vpnc
```
mkdir /etc/vpnc
```

#  Create text file /etc/vpnc/.tvpn-credentials
Add your credentials based on the following variables
```
COM_AUTHGROUP=
COM_USER=
COM_PASSWD=
COM_DOMAIN=
INTERFACE=
```

[^note]:
EXAMPLE /etc/vpnc/.tvpn-credentials
```
# CREDENTIALS FILE FOR TVPN SCRIPT
# YOUR VPN AUTH GROUP
COM_AUTHGROUP="ACME"
# YOUR VPN USER ID
COM_USER="wcoyote"
# YOUR VPN PASSWORD (enclose in single quotes!)
COM_PASSWD='Ro@dRunn3r'
# YOUR VPN DOMAIN
COM_DOMAIN="ACME"
# YOUR VPN HOST NAME OR IP ADDRESS
COM_HOST="vpn-hq.acme.com"
# YOUR PRIMARY ACTIVE INTERFACE
INTERFACE=en10
```

# Copy VPNC Script to /etc/vpnc


- Download and copy vpnc-script to /etc/vpnc/
- Verify
```
# file /etc/vpnc/vpnc-script
/etc/vpnc/vpnc-script: POSIX shell script text executable, Unicode text, UTF-8 text
```

# CREATE DNS TEMPLATES
Create the (resolv.conf) default template, and your VPN(custom) Entries

- Copy default resolv.conf to /etc/vpnc/vpnc.resolv.conf.default
```
# cp /etc/resolv.conf /etc/vpnc/vpnc.resolv.conf.default
```

- Create your CUSTOM resolv.conf in /etc/vpnc/resolv.conf.custom
```
# cp /etc/vpnc/vpnc.resolv.conf.custom
```

# LOGS
TVPN logs are stored in $HOME/logs/tvpn
```
# ls $HOME/logs/tvpn
tvpn.202209.log
```


# RUN TVPN

## VIEW TVPN USAGE


VIEW SCRIPT USAGE
```
	# tvpn -?
	================================================================
	>[tvpn]:  VPN Script to connect to the VPN [version 4.0]
	================================================================
	>usage
	  #tvpn [start|stop|status|-c|-s|-d|-r|-v]
		  start   Initialize connection to vpn-hq.tintri.com VPN
		  stop    Close connection to vpn-hq.tintri.com VPN
		  status  View the current VPN Connection Status
		  -c      View your current Credentials
		  -s      Tail the current /Users/bpatridge/logs/tvpn.202209.log
			  to verify the current Connection Status
		  -d      Enable Debug
		  -r      Reset Network and Routing
		  -v      Version info
	================================================================
```

## Check TVPN status
```
# tvpn status
[2022-09-28T14:57:28] benmacbook tvpn Not currently running.
```

## View Current Credentials from /etc/vpnc/.tvpn-credentials
```
# tvpn -c
================================================================
CREDENTIALS FROM [/etc/vpnc/.tvpn-credentials]
================================================================
VPN_GROUP       =       ACME
VPN_USER        =       wcoyote
VPN_PASSWORD    =       Ro@dRunn3r
VPN_DOMAIN      =       ACME
VPN_HOST        =       vpn-hq.acme.com
MY_INTERFACE    =       en10
================================================================

```


## Start TVPN
- To Start TVPN
```
# tvpn start
[2022-09-28T15:24:30] benmacbook Initiating connection to VPN to TINTRI
[2022-09-28T15:24:30] benmacbook Started VPN as PID: 4726
#
```

## View Connection Status
```
#tvpn -s
[2022-09-28T15:24:30] benmacbook Started VPN as PID:
Attempting to connect to server 101.254.210.230:443
Connected to 101.254.210.230:443
SSL negotiation with vpn-hq.acme.com
Server certificate verify failed: signer not found
Connected to HTTPS on vpn-hq.tintri.com with ciphersuite (TLS1.2)-(ECDHE-SECP256R1)-(RSA-SHA512)-(AES-256-GCM)
> POST / HTTP/1.1
> Host: vpn-hq.acme.com
> User-Agent: Open AnyConnect VPN Agent v9.01
> Accept: */*
> Accept-Encoding: identity
> X-Transcend-Version: 1
> X-Aggregate-Auth: 1
> X-Support-HTTP-Auth: true
> X-AnyConnect-STRAP-Pubkey: MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAED1QxFzpzgeSr0YNXB891wFdlkgMbMTmSLlAthyr75sc2KYYA1uMG4XnRjBcK6tgii/0ChGJ7PvSuUfZPzHinSA==
> X-AnyConnect-STRAP-DH-Pubkey: MFkwEwYHKoZIzj0CAQYIKoZ
```

## Stop TVPN
```
# tvpn stop
```


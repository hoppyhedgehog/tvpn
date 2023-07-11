# ABOUT tvpn

TVPN is a VPNC Wrapper Script that allows you to connect to your Cisco VPN using Openconnect instead of using the Native Cisco Client.

I created this for use on MAC OSX Monterey (12.6)+, but it could also be used on Linux.

# GITHUB URL
https://github.com/hoppyhedgehog/tvpn


# NEW FEATURES
Version 5.0 includes major changes:
- Credentials file is /etc/.credentials
- Paswords are now encrypted and decrypted (when needed)
- There is a "setup" option. Setup builds credentials file which caches username/domain/authgroup/vpn server/DNS info/etc.
- There are options to reset the individual options within the credentials.
- The reset scripts to modify dns when on VPN vs HOME are renamed to /usr/local/bin/tvpn-reset-dns-vpn and /usr/local/bin/tvpn-reset-dns-home

# UPGRADING


If you have tvpn v4.1 or earlier here are details on files that should be copied over the existing ones.

**tvpn**
- The main script that should overwrite your existing one in /usr/local/bin

**.tvpn-credentials** 
- The /etc/vpnc/.tvpn-credentials file was renamed to /etc/vpnc/.credentials

**brew-setup.sh**
- You should re-download brew-setup.sh, although if you have tvpn installed you do NOT have to re-run it.

**mac_shell_environment_wrapper.sh**
- No significant changes.

**vpnc-script**
- Download and replace file vpnc-script. It was changed from a customized file to the default file [download it from here](https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script)




#  INSTALLATION PREREQUISITES

### Root user 
- TVPN is designed to be run AS ROOT
You may run sudo if you prefer

### Homebrew is required.
- To install Homebrew and the prerequisites, I have created brew-setup.sh on his repo as well.
- BE SURE YOU ARE A NON-ROOT USER.
-- You will get an error if you attempt to install as root
```
#  ./brew-setup.sh -c
[2022-09-29T15:35:32] HomeBrew found: /usr/local/bin/brew
[2022-09-29T15:35:32] Curl Found /usr/bin/curl
[2022-09-29T15:35:32] ERROR: You cannot install HomeBrew as a root user
```
- View Usage
```
$ chmod 755 brew-setup.sh
$ ./brew-setup.sh 
===================================================
VERSION: 2.5
====================================================
brew-setup.sh [-c|-g|-G|-l|-i|-t|-h/?|v]
	-c	Check to see if HomeBrew Exists
	-i	Install HomeBrew and Tools
	-l	List HomeBrew Tools to be installed
	-g	Re-check gnu-tools (done during install)
	-G	Manually correct gnu-tool links (if they need to be rechecked)
	-t	Install HomeBrew Tools ONLY
	-v	Show brew-setup.sh Version
====================================================
```

- Install HomeBrew and the tools.
```
$ ./brew-setup.sh -i
```

- If you already have homebrew installed and only want to install the tools you can merely run:
```
$ ./brew-install.sh -t
```

### VPNC Script is required. 
- It is included in this repo
- OR you may [download it from here](https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script)
- Verify the script is downloaded correctly without spaces or bad characters
```
# bash vpnc-script
this script must be called from vpnc
```
If you see an error such as
```
# bash vpnc-script
vpnc-script: line 838: warning: here-document at line 439 delimited by end-of-file (wanted `EOF')
vpnc-script: line 839: syntax error: unexpected end of file
```
Then the file was not downloaded correctly. 
Re-download the file from https://raw.githubusercontent.com/cloudflare/vpnc-scripts/master/vpnc-script by doing File --> Save to verify it is saved as a plain text file.

### OpenConnect is required
- Use the brew-setup.sh script, or you can install it from [GitHub](https://formulae.brew.sh/formula/openconnect) 

*Also, the version I used is included in this repo.*



### YOUR VPN Credentials
- Your VPN Authentication Credentials (User Name, Password, Domain, Auth Group)
- The IP Address or FQDN of YOUR Company VPN Server
- The credentials should be saved to file /etc/vpnc/.credentials using the template format in this repo


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

# RECOMMENDATIONS

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

### Disable SIP on the MAC
If you are a HomeBrew CLI user you will find System Integrity Protection (SIP) Makes most CLI operations impossible.
Therefore I always recommend turning it off.
```
To verify SIP:

# csrutil status
System Integrity Protection status: enabled.

1) Disable SIP on Mac:

a) Reboot the Mac and hold down Command + R keys simultaneously after you hear the startup chime, this will boot OS X into Recovery Mode

b) When the "OS X Utilities" screen appears, pull down the 'Utilities' menu at the top of the screen instead, and choose "Terminal"

c) Type the following command into the terminal then hit return:

# csrutil disable; reboot

d) You will see a message saying that System Integrity Protection has been disabled and the Mac needs to restart for changes to take effect, and the Mac will then reboot itself automatically, just let it boot up as normal

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


# Create Directory /etc/vpnc
```
mkdir /etc/vpnc
```


# Copy VPNC Script to /etc/vpnc


- Download and copy vpnc-script to /etc/vpnc/
- Verify
```
# file /etc/vpnc/vpnc-script
/etc/vpnc/vpnc-script: POSIX shell script text executable, Unicode text, UTF-8 text
```


# BEGIN SETUP
Setup TVPN by viewing the script usage.
```
================================================================
>[tvpn]:  VPN Script to connect to the VPN [version 5.0]
================================================================
>usage
  # tvpn [start|stop|status|restart|setup|-s|-d|-p|-r <arg>|-v]
          start   Initialize connection to  VPN
          stop    Close connection to  VPN
          restart Restart VPN connection
          status  View the current VPN Connection Status
          setup   Setup and configure TVPN
          -s      Tail the current /Users/bpatridge/logs/tvpn/tvpn.202307.log
                  to verify the current Connection Status
          -d      Enable Debug
          -p      Print Credentials (password decrypted)
          -r <arg>
                        all     - Reset Everything and re-run Setup
                        route   - Reset Routing
                        int     - Reset Network Interface info
                        user    - Reset VPN User Credentials
                        pass    - Reset VPN User Password
                        dom     - Reset VPN Domain
                        group   - Reset VPN Auth Group
                        serv    - Reset VPN Server
                        vd      - Reset VPN DNS Servers
                        ld      - Reset LOCAL  DNS Servers
          -v      Version info
================================================================
```

Then you may issue setup

```
# tvpn setup
[69][root@benmacbook]# tvpn setup
[2023-07-10T15:13:29] benmacbook Using INTERFACE=en10 IP=192.168.1.187 NWSERVICE='USB 10/100/1000 LAN 2'
[2023-07-10T15:13:29] benmacbook Enter your VPN Username> bpatridge
[2023-07-10T15:13:34] benmacbook Writing VPN User [bpatridge] --> /private/etc/vpnc/.credentials
[2023-07-10T15:13:34] benmacbook -----------------------------------------------------------
[2023-07-10T15:13:34] benmacbook Enter your Password >
[2023-07-10T15:13:46] benmacbook Re-Enter your Password >
[2023-07-10T15:13:48] benmacbook -----------------------------------------------------------
[2023-07-10T15:13:48] benmacbook Enter your AD Domain > acme
[2023-07-10T15:13:52] benmacbook Writing AD Domain [ACME] --> /private/etc/vpnc/.credentials
[2023-07-10T15:13:52] benmacbook -----------------------------------------------------------
[2023-07-10T15:13:52] benmacbook Enter your VPN Auth Group> acme
[2023-07-10T15:13:54] benmacbook Writing VPN AuthGroup[ACME] --> /private/etc/vpnc/.credentials
[2023-07-10T15:13:54] benmacbook -----------------------------------------------------------
[2023-07-10T15:13:54] benmacbook Enter your VPN Server FQDN or IP address> vpn-hq.acme.com
[2023-07-10T15:14:27] benmacbook Writing VPN Server [vpn-hq.acme.com] --> /private/etc/vpnc/.credentials
[2023-07-10T15:14:27] benmacbook -----------------------------------------------------------
[2023-07-10T15:14:27] benmacbook -----------------------------------------------------------
[2023-07-10T15:14:27] benmacbook Gathering a list of VPN DNS Servers
[2023-07-10T15:14:27] benmacbook ENTER BLANK OR "." TO EXIT
[2023-07-10T15:14:27] benmacbook Enter your VPN DNS Server IP #1>10.25.40.53
[2023-07-10T15:14:41] benmacbook Enter your VPN DNS Server IP #2>10.10.10.53
[2023-07-10T15:14:46] benmacbook Enter your VPN DNS Server IP #3>172.16.241.94
[2023-07-10T15:14:54] benmacbook Enter your VPN DNS Server IP #4>172.16.241.187
[2023-07-10T15:15:04] benmacbook Enter your VPN DNS Server IP #5>8.8.8.8
[2023-07-10T15:15:08] benmacbook Enter your VPN DNS Server IP #6>1.1.1.1
[2023-07-10T15:15:11] benmacbook Enter your VPN DNS Server IP #7>
[2023-07-10T15:15:12] benmacbook Writing VPN DNS [6] SERVERS --> /private/etc/vpnc/.credentials
[2023-07-10T15:15:12] benmacbook Gathering a list of VPN DNS Servers to search
[2023-07-10T15:15:12] benmacbook ENTER BLANK OR "." TO EXIT
[2023-07-10T15:15:12] benmacbook Enter your VPN DNS Domain Search Server Name #1>acme.ad
[2023-07-10T15:15:18] benmacbook Enter your VPN DNS Domain Search Server Name #2>acme.com
[2023-07-10T15:15:22] benmacbook Enter your VPN DNS Domain Search Server Name #3>bintri.ad
[2023-07-10T15:15:24] benmacbook Enter your VPN DNS Domain Search Server Name #4>
[2023-07-10T15:15:25] benmacbook Writing VPN DNS [3] DOMAIN SEARCH SERVERS --> /private/etc/vpnc/.credentials
[2023-07-10T15:15:25] benmacbook -----------------------------------------------------------
[2023-07-10T15:15:25] benmacbook -----------------------------------------------------------
[2023-07-10T15:15:25] benmacbook Gathering a list of LOCAL DNS Servers
[2023-07-10T15:15:25] benmacbook ENTER BLANK OR "." TO EXIT
[2023-07-10T15:15:25] benmacbook Enter your LOCAL DNS Server IP #1>192.168.1.1
[2023-07-10T15:15:34] benmacbook Enter your LOCAL DNS Server IP #2>8.8.8.8
[2023-07-10T15:15:36] benmacbook Enter your LOCAL DNS Server IP #3>1.1.1.1
[2023-07-10T15:15:37] benmacbook Enter your LOCAL DNS Server IP #4>
[2023-07-10T15:15:38] benmacbook Writing LOCAL DNS [3] SERVERS --> /private/etc/vpnc/.credentials
[2023-07-10T15:15:38] benmacbook Gathering a list of LOCAL DNS Servers to search
[2023-07-10T15:15:38] benmacbook ENTER BLANK OR "." TO EXIT
[2023-07-10T15:15:38] benmacbook Enter your LOCAL DNS Domain Search Server Name #1>
[2023-07-10T15:15:40] benmacbook -----------------------------------------------------------
########################################
# CREDENTIALS FILE FOR TVPN SCRIPT
########################################
INTERFACE=en10
NWSERVICE='USB 10/100/1000 LAN 2'
COM_USER="bpatridge"
COM_PASSWD='mypassword'
COM_DOMAIN="ACME"
COM_AUTHGROUP="ACME"
COM_HOST="myvpn.acme.com"
VPN_NAMESERVER[1]="10.25.40.53"
VPN_NAMESERVER[2]="10.10.10.53"
VPN_NAMESERVER[3]="172.16.241.94"
VPN_NAMESERVER[4]="172.16.241.187"
VPN_NAMESERVER[5]="8.8.8.8"
VPN_NAMESERVER[6]="1.1.1.1"
VPN_SEARCH[1]="acme.ad"
VPN_SEARCH[2]="acme.com"
VPN_SEARCH[3]="bintri.ad"
LOCAL_NAMESERVER[1]="192.168.1.1"
LOCAL_NAMESERVER[2]="8.8.8.8"
LOCAL_NAMESERVER[3]="1.1.1.1"

```

To verify it is connected you can issue 'tvpn -s' and should see something like the following when it is connected
```
# tvpn -s
Received DTLS packet 0x00 of 57 bytes
No work to do; sleeping for 18000 ms...
Sent DTLS packet of 64 bytes; DTLS send returned 65
No work to do; sleeping for 17000 ms...
Received DTLS packet 0x00 of 57 bytes
No work to do; sleeping for 17000 ms...
Sent DTLS packet of 64 bytes; DTLS send returned 65
No work to do; sleeping for 16000 ms...
Received DTLS packet 0x00 of 57 bytes
No work to do; sleeping for 16000 ms...
```

If there is a need to monitor the initial startup of tvpn there is also file tvpn.wait
```
# cat $HOME/logs/tvpn/tvpn.wait
[2023-07-10T14:32:37] benmacbook Waiting to confirm connection. Sleep #0
[2023-07-10T14:32:42] benmacbook Waiting to confirm connection. Sleep #1
[2023-07-10T14:32:47] benmacbook Waiting to confirm connection. Sleep #2
[2023-07-10T14:32:52] benmacbook Waiting to confirm connection. Sleep #3
[2023-07-10T14:32:57] benmacbook Waiting to confirm connection. Sleep #4
[2023-07-10T14:33:02] benmacbook Waiting to confirm connection. Sleep #5
[2023-07-10T14:33:07] benmacbook Waiting to confirm connection. Sleep #6
[2023-07-10T14:33:12] benmacbook DNS Check Complete. [tpvn.daemon] exiting successfully.

```


# CHECK CURRENT VERSION
```
# tvpn -v
tvpn v5.0
```

# STARTING AND STOPPING VPN CONNECTION USING TVPN


## Check TVPN status
```
# tvpn status
[2022-10-03T11:21:14] benmacbook [tvpn] is currently running as PID 33282

```

## View Current Credentials from /etc/vpnc/.credentials
```
# tvpn -p
########################################
# CREDENTIALS FILE FOR TVPN SCRIPT
########################################
INTERFACE=en10
NWSERVICE='USB 10/100/1000 LAN 2'
COM_USER="bpatridge"
COM_PASSWD='U2FsdGVkX19l5YWuyOpgY0pvjodz3U1XSUtk5Wo9pKU=' [UNENCRYPTED = N3wH0r!z0nZ]
COM_DOMAIN="TINTRI"
COM_AUTHGROUP="TINTRI"
COM_HOST="vpn-hq.tintri.com"
VPN_NAMESERVER[1]="10.25.40.53"
VPN_NAMESERVER[2]="10.10.10.53"
VPN_NAMESERVER[3]="172.16.241.94"
VPN_NAMESERVER[4]="172.16.241.187"
VPN_NAMESERVER[5]="8.8.8.8"
VPN_NAMESERVER[6]="1.1.1.1"
VPN_SEARCH[1]="tintri.ad"
VPN_SEARCH[2]="tintri.com"
VPN_SEARCH[3]="bintri.ad"
LOCAL_NAMESERVER[1]="192.168.1.1"
LOCAL_NAMESERVER[2]="8.8.8.8"
LOCAL_NAMESERVER[3]="1.1.1.1"
================================================================


```
## Start TVPN
- To Start TVPN
```
# tvpn start
[2022-09-28T15:24:30] benmacbook Initiating connection to VPN to ACME
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
Connected to HTTPS on vpn-hq.acme.com with ciphersuite (TLS1.2)-(ECDHE-SECP256R1)-(RSA-SHA512)-(AES-256-GCM)
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
[2022-10-03T10:52:29] benmacbook [tvpn] currently running under 30614. Stopping.
```


## Restart TVPN

```
# tvpn restart
``` 

# LOGS
TVPN logs are stored in $HOME/logs/tvpn
```
# ls $HOME/logs/tvpn
tvpn.2022010.log
```

If there is a need to monitor the initial startup of tvpn there is also file tvpn.<date>.wait
```
# tail tvpn.202210.wait
[2022-10-03T10:53:41] benmacbook Waiting to confirm connection. Sleep #0
[2022-10-03T10:53:46] benmacbook Waiting to confirm connection. Sleep #1
[2022-10-03T10:53:51] benmacbook Waiting to confirm connection. Sleep #2
[2022-10-03T10:53:56] benmacbook Waiting to confirm connection. Sleep #3
[2022-10-03T10:54:01] benmacbook Waiting to confirm connection. Sleep #4
[2022-10-03T10:54:06] benmacbook Waiting to confirm connection. Sleep #5
[2022-10-03T10:54:11] benmacbook DNS Check Complete. [tpvn.daemon] exiting successfully.
```


# APPENDIX

## A - Tips

#### Identify your preferred ACTIVE network interface:

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


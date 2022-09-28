# tvpn
A VPNC Wrapper Script that allows you to connect to your Cisco VPN using Openconnect instead of using the Native Cisco Client.

I created this for use on MAC OSX Catalina+, but it could also be used on Linux.

#  PREREQUISITES

### Root user 
- TVPN is designed to be run AS ROOT

### VI Shell Wrapper VIB
- Though this is OPTIONAL, if you are a CLI person it is recommended you try my VI/VIM Editor Shell Wrapper called [VIM](https://github.com/hoppyhedgehog/vib/)

### Homebrew is required.
- To install Homebrew and the prerequisites, I have created brew-setup.sh on his repo as well.

### Running brew-setup
- You can prune homebrew-essentials.txt but it is still highly recommended you run brew-setup as is to setup the correct soft links

### OpenConnect is required
- You can install it from [GitHub](https://formulae.brew.sh/formula/openconnect) or use the brew-setup.sh

### VPNC Script is required  
- You may [download it from here](https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script)

*Also, the version I used is included in this repo.*

### ruby is required
- ruby should be installed in /usr/bin/ruby on your MAC
* if not see (https://www.ruby-lang.org/en/documentation/installation/)*

### VPN Server
- The IP Address or FQDN of YOUR Company VPN Server

### Credentials
- Your Authentication (typically Active Directory) Userid And Password

###  Set the SHELL environment

It is recommended that you 
- Download mac_shell_environment_wrapper.sh and copy it to /usr/local/bin/
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


# INSTALLING TVPN

- Copy tvpn to /usr/local/bin

- Change the permissions to execute (755)

```
chmod 755 /usr/local/bin/tvpn
```



# Identify your preferred network interface that is active use:
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



# Create Directory vpnc
```
mkdir /etc/vpnc
```

#  Create file /etc/vpnc/.tvpn-credentials
```
COM_AUTHGROUP=
COM_USER=
COM_PASSWD=
COM_DOMAIN=
INTERFACE=
```

[^note]:
EXAMPLE
```
# cat /etc/vpnc/.tvpn-credentials
# CREDENTIALS FILE FOR TVPN SCRIPT
# YOUR VPN AUTH GROUP
export COM_AUTHGROUP="ACME"
# YOUR VPN USER ID
export COM_USER="wcoyote"
# YOUR VPN PASSWORD (enclose in single quotes!)
export COM_PASSWD='Ro@dRunn3r'
# YOUR VPN DOMAIN
export COM_DOMAIN="ACME"
# YOUR VPN HOST NAME OR IP ADDRESS
export COM_HOST="vpn-hq.acme.com"
# YOUR PRIMARY ACTIVE INTERFACE
INTERFACE=en10
```

# SETUP VPNC


- Copy-n-paste vpnc-script to /etc/vpnc
```
cd /etc/vpnc
vi vpnc-script
```

# CREATE DNS TEMPLATES
Create the (resolv.conf) default template, and your VPN(custom) Entries

- Copy default resolv.conf to /etc/vpnc/vpnc.resolv.conf.default
```
cp /etc/resolv.conf /etc/vpnc/vpnc.resolv.conf.default
```

- Create your CUSTOM resolv.conf in /etc/vpnc/resolv.conf.custom
```
cp /etc/vpnc/vpnc.resolv.conf.custom
```



# VIEW TVPN USAGE


VIEW SCRIPT USAGE
```
	# tvpn -?
	================================================================
	>[tvpn]:  VPN Script to connect to the TINTRI VPN [version 3.2]
	================================================================
	>usage
		#tvpn [start|stop|status|-s|-d|-r|-v]
			start   Initialize connection to vpn-hq.tintri.com VPN
			stop    Close connection to vpn-hq.tintri.com VPN
			status  View the current VPN Connection Status
			-s      Tail the current /Users/bpatridge/logs/tvpn.202209.log
				to verify the current Connection Status
			-d      Enable Debug
			-r      Reset Network and Routing
			-v      Version info
	================================================================

```

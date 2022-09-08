# tvpn
A VPNC Wrapper Script that allows you to connect to your Cisco VPN.

I created this for use on MAC OSX, but it could also be used on Linux.

#  PREREQUISITES

## Root user 
- TVPN is designed to be run AS ROOT

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

#  SHELL ENVIRONMENT

It is recommended that you 
- Download mac_shell_environment_wrapper.sh and put in /usr/local/bin/
- Edit $HOME/.bashrc and add
```
source /usr/local/bin/mac_shell_environment_wrapper.sh
```

- Reload your shell environment 
```
. ~/.bashrc
```

- Verify (After installing homebrew essentials) that the following resolv to the HomeBrew 'GNU Linux' Tools in /usr/local/bin
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


- Verify openconnect is installed
```
# which openconnect
/usr/local/bin/openconnect
```


# INSTALLING TVPN

- Copy tvpn to /usr/local/bin

```
chmod 755 /usr/local/bin/tvpn
```

- Edit tvpn
```
cd /usr/local/bin
vi tvpn
```

- Modify the following fields
```
COM_AUTHGROUP=
COM_USER=
COM_PASSWD=
COM_DOMAIN=
INTERFACE=
```
* if you do not know the network interface that is active use:
```
ifconfig | pcregrep -M -o '^[^\t:]+(?=:([^\n]|\n\t)*status: active)'
```


[^note]:
EXAMPLE
```
export COM_AUTHGROUP="ACME"      # YOUR AUTH GROUP
export COM_USER="wcoyote"        # YOUR VPN USER ID
export COM_PASSWD="Ro@dRunn3r"   # YOUR VPN PASSWORD
export COM_DOMAIN="ACME"        # YOUR DOMAIN
export COM_HOST="vpn-hq.acme.com" # YOUR VPN HOST (use IP if DNS doesnt work)
INTERFACE=en10
```

# SETUP VPNC

- Create Directory vpnc
```
mkdir /etc/vpnc
```

- Copy-n-paste vpnc-script to /etc/vpnc
```
cd /etc/vpnc
vi vpnc-script
```

# CREATE DNS (resolv.conf) default and your VPN(custom) Entries

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
	>ABOUT:  VPN Script to connect to the vpn-hq.tintri.com VPN
	================================================================
	>usage
		#tvpn [start|stop|status|-s|-d]
			start 	Initialize connection to vpn-hq.tintri.com VPN
			stop	Close connection to vpn-hq.tintri.com VPN
			status	View the current VPN Connection Status
			-s	Tail the current /Users/bpatridge/logs/tvpn.202205.log
				to verify the current Connection Status
			-d	Enable Debug
	================================================================
```

# tvpn
A VPNC Wrapper Script that allows you to connect to your Cisco VPN.

I created this for use on MAC OSX, but it could also be used on Linux.

#  PREREQUISITES

** For MAC


### Homebrew is required.
- To install Homebrew and the prerequisites, I have created brew-setup.sh on his repo as well.

### OpenConnect is required
- You can install it from [GitHub](https://formulae.brew.sh/formula/openconnect) or use the brew-setup.sh

### VPNC Script is required  
- You may [download it from here](https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script)

*Also, the version I used is included in this repo.*

### ruby is required
It should be installed in /usr/bin/ruby on your MAC
*If not see https://www.ruby-lang.org/en/documentation/installation/*

### VPN Server
- The IP Address or FQDN of YOUR Company VPN Server

### Credentials
- Your Authentication (typically Active Directory) Userid And Password

#  SHELL ENVIRONMENT

It is recommended that you

```
###########
USAGE
###########

VIEW SCRIPT USAGE
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

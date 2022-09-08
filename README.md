# tvpn
A VPNC Wrapper Script that allows you to connect to your Cisco VPN

#  PREREQUISITES

** For MAC


Homebrew is required.
To install Homebrew and the prerequisites, I have created brew-setup.sh on his repo as well.

VPNC Script is required:  You may download it from here:
https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script

Also, the version I used is included in this repo.


###########
USAGE
###########

SUDO TO ROOT
	# sudo -s
EXECUTE SETUP
	# ./setup.sh
	#

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

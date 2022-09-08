# tvpn
A VPNC Wrapper Script that allows you to connect to your Cisco VPN

# INSTALLATION EXAMPLE
```
$ sudo -s
# cd $HOME
# mkdir tmp
# cd tmp
# tar -xzvf tvpn_2.0.tgz
x tvpn_2.0/
x tvpn_2.0/setup.sh
x tvpn_2.0/INSTALL
x tvpn_2.0/etc/
x tvpn_2.0/tvpn
x tvpn_2.0/etc/vpnc/
x tvpn_2.0/etc/vpnc/resolv.conf.tintri
x tvpn_2.0/etc/vpnc/vpnc-script
# 
# cd tvpn_2.0
# cat INSTALL
###########
INSTALLATION INSTRUCTIONS
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

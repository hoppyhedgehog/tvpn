#!/bin/bash
###################################################################
#LAST_MODIFIED: 2022-09-26T16:32:39
###################################################################
PS4='${LINENO}: '
VERSION=2.4
###################################################################
SCRIPT=$(basename ${BASH_SOURCE[0]})
UBIN=/usr/local/bin
LINE="===================================================="
RESULTS_DIR=/tmp/$(echo $SCRIPT|cut -d\. -f1)_data
LOGDATE="$(date '+%Y-%m-%d_%H%M%S')"
LOGFILE=/tmp/$(echo $SCRIPT|cut -d\. -f1).$LOGDATE.log
HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
###################################################################
if [ ! -d $RESULTS_DIR ]; then
	mkdir -p $RESULTS_DIR &>/dev/null
fi
###################################################################
writelog() {
        DATETIME="[$(date '+%Y-%m-%dT%H:%M:%S')]"
        echo -e "$DATETIME $1" |tee -a $LOGFILE
}
###################################################################
check_root(){
	if [ $USER == "root" ]; then
		writelog "ERROR: You cannot install HomeBrew as a root user"
		exit 1
	fi
}
###################################################################
# BUILD LIST OF HOMEBREW TOOLS TO INSTALL
###################################################################
HOMEBREW_ESSENTIALS=(
	"archey" 
	"atool" 
	"autoconf" 
	"autoenv" 
	"autogen" 
	"automake" 
	"axel" 
	"bash" 
	"bash-completion" 
	"bdw-gc" 
	"berkeley-db" 
	"binutils" 
	"binwalk" 
	"binwalk" 
        "bison"
        "c-ares"
        "cairo"
        "cask"
        "ccat"
        "clang-format"
        "cmake"
        "colordiff"
        "coreutils"
        "curl"
        "ddrescue"
        "ddrescue"
        "diffutils"
        "dos2unix"
        "findutils"
        "gawk"
        "gcc"
        "gd"
        "gdb"
        "gdbm"
        "gdk-pixbuf"
        "gettext"
        "git"
        "glew"
        "glib"
        "global"
        "gmp"
        "gnu-getopt"
        "gnu-indent"
        "gnu-tar"
        "gnu-which"
        "gnutls"
        "gobject-introspection"
        "googler"
        "graphite2"
        "grep"
        "grpc"
        "gstat"
        "gtk+"
        "gtk+3"
        "gts"
        "guile"
        "gzip"
        "icu4c"
        "inetutils"
        "ipmitool"
        "iproute2mac"
        "jasper"
        "jemalloc"
        "jpeg"
        "jpeg-turbo"
        "ldid"
        "ldns"
        "less"
        "lftp"
        "libcbor"
        "libconfig"
        "libdnet"
        "libev"
        "libevent"
        "libffi"
        "libfido2"
        "libgcrypt"
        "libgpg-error"
        "libiconv"
        "libidn"
        "libidn2"
        "libmagic"
        "libmpc"
        "libpcap"
        "libpng"
        "librsvg"
        "libscrypt"
        "libtasn1"
        "libtiff"
        "libtool"
        "libunistring"
        "libx11"
        "libxau"
        "libxcb"
        "libxdmcp"
        "libxext"
        "libxrender"
        "libyaml"
        "libzip"
        "links"
        "llvm"
        "lua"
        "lynx"
        "lz4"
        "lzip"
        "lzlib"
        "lzo"
        "m-cli"
        "m4"
        "makedepend"
        "mounty"
        "mpdecimal"
        "mpfr"
        "mac-cleanup"
        "maclaunch"
        "ncurses"
        "netpbm"
        "nettle"
        "nghttp2"
        "nmap"
        "openssh"
        "openssl@1.1"
        "p11-kit"
        "p7zip"
        "pcre"
        "pcre2"
        "perl"
        "pgcli"
        "pixman"
        "pssh"
        "pssh"
        "pstree"
        "pyenv"
        "pyenv-virtualenv"
        "python3"
        "python@3.9"
        "rar"
        "rbenv"
        "readline"
        "rsync"
        "ruby"
        "ruby-build"
        "screen"
        "sqlite"
        "stoken"
        "tcpdump"
        "tig"
        "tnftpd"
        "unbound"
        "unrar"
        "unzip"
        "vim"
        "watch"
        "wdiff"
        "webp"
        "wget"
        "xorgproto"
        "zlib"
        "nmap"
	)	
##################################################################
# LIST OF HOMEBREW GNU TOOLS TO ALIAS TO ACTUAL TOOLS IN
# /usr/local/bin
##################################################################
GUN_TOOLS=(
	"awk" 
	"cat" 
	"chmod"
	"chown" 
	"chgrp"
	"cksum"
	"cp"
	"cut"
	"date"
	"dd"
	"df"
	"dir"
	"env"
	"find"
	"hostid"
	"kill"
	"ln"
	"ls"
	"mkdir"
	"mknod"
	"nice"
	"nohup"
	"printf"
	"pwd"
	"rm"
	"rmdir"
	"sed"
	"sleep"
	"sort"
	"split" 
	"stat"
	"stty"
	"sum"
	"sync"
	"tac"
	"tail"
	"tee"
	"test"
	"touch"
	"tr"
	"true"
	"tty"
	"uname"
	"uniq"
	"uptime"
	"wc"
	"who"
	"whoami"
	"xargs"
	"yes")

##################################################################
list_tools() {
	for brewtool in ${homebrew_essentials_arr[@]}; do
		echo $brewtool
	done
	exit 0
}
##################################################################
check_gnutools(){
	writelog "Checking gnu tools in /usr/local/bin" |tee -a $LOGFILE
	for gnutool in ${GNU_TOOLS[@]}; do
		if [[ ( -f  $UBIN/g${gnutool}) && ( ( ! -L $UBIN/${gnutool} ) ||  ( ! -f $UBIN/${gnutool} )) ]]; then
			writelog "Linking  $UBIN/g${gnutool} --> $UBIN/$gnutool" |tee -a $LOGFILE
			ln -s $UBIN/g${gnutool} $UBIN/$gnutool
		fi
	done
}
##################################################################
fixdirperms() {
        writelog "Issuing  #sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions" |tee -a $LOGFILE
        sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions
        check_gnutools

}
##################################################################
brew_install() {
	writelog "# brew install $brewline" |tee -a $LOGFILE
	brew install $brewline |tee -a $LOGFILE
}
##################################################################
build_brew() {
	local brewline=
	local n=1
	for brewtool in ${HOMEBREW_ESSENTIALS[@]}; do	
		if [ $n -le 15 ]; then
			brewline=$(printf "$brewline $brewtool")
		else
			brew_install
			n=0
		fi
		((n++))
	done
	brew_install

}
##################################################################
usage() {

	echo $LINE
	echo "VERSION: $VERSION"
	echo $LINE
	echo "$SCRIPT [-c|-l|-i|-t|-h/?|v]"
	echo "	-c	Check to see if HomeBrew Exists"
	echo "	-i	Install HomeBrew and Tools"
	echo "	-l	List HomeBrew Tools to be installed"
	echo "	-t	Install HomeBrew Tools ONLY"
	echo "	-v	Show $SCRIPT Version"
	echo $LINE
	exit
}
##################################################################
if [ $# == 0 ]; then
	usage
fi
while getopts 'clitvh' OPT_NAME; do
	case $OPT_NAME in
		("h"|\?)
			usage;;
		("t")	tools_only=1;;
		("c")	check=1;;
		("l")	list_tools;exit;;
		("i")	do_install=1;;
		("v")	echo "$SCRIPT version $VERSION";exit 0;;
	esac
done
if [ -z $tools_only ] && [ -z $check ] && [ -z $do_install ]; then
	usage
fi
##################################################################

rm -f $LOGFILE 2>/dev/null 

if [ ! -z $check ] || [ ! -z $do_install ] || [ ! -z $tools_only ]; then
	if [ $(which brew) ]; then
		writelog "HomeBrew found: $(which brew)"
	else
		writelog "HomeBrew was not found."  |tee -a $LOGFILE
		nobrew=1
	fi
	if [ $(which curl) ]; then
		writelog "Curl Found $(which curl)"
	else
		writelog "ERROR: curl not found."
		exit 1
	fi
fi

check_root 

if [  -z $check ] && [ ! -z $do_install ]; then
	if [ ! -z $do_install ] && [  -z $nobrew ]; then
		writelog "Attempting to install Homebrew"
		writelog "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" |tee -a $LOGFILE
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" |tee -a $LOGFILE
	else
		exit 1
	fi

fi

if [ ! -z $do_install ] || [ ! -z $tools_only ]; then
	if [[ ( -z $nobrew ) &&  ( $(which brew) ) ]]; then
		build_brew |tee -a $LOGFILE
		fixdirperms
		check_gnutools
	fi
fi
writelog "Done."
writelog "Results in $LOGFILE"
##################################################################

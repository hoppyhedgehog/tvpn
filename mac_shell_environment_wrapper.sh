#################################################################
# FILENAME: SEE $SHELL_WRAPPER VARIABLE BELOW
# LOCATION: /usr/local/bin/mac_shell_environment_wrapper.sh
#################################################################
#
# SUMMARY:
#
# THE FOLLOWING SHELL ENVIRONMENT SCRIPT CHANGES THE USER ENVIRONMENT
# SET THE PATH TO /usr/local/bin/ to for HOMEBREW and other tools
#################################################################
# FOR QUICK DIRECTORY CHANGE ACCESS
# IT ALSO MAKES CHANGES TO THE HISTORY FILE TO INCREASE THE LOGGING
# HISTORY AS WELL AS ADDS DATE AND TIME STAMPS
#
# INSTALLATION INSTRUCTIONS
#	1) Create the following file by typing 
#		vi /usr/local/bin/mac_shell_environment_wrapper.sh
#	2) Cut-N-Paste ALL of the contents of this file into the file and save it.
#	3) Type 'bash' to see the new environment.
#	4) Type 'mcd' to see the new directory shortcut commands
# 
# LAST UPDATED SEPT 8 2022
#
#################################################################
# MAIN CASE 
#################################################################
#################################################################
# Generic Variables
#################################################################
VIB_ENABLED=0		# [0=no |1=yes] IF using VIB from https://github.com/hoppyhedgehog/vib
#################################################################
YEAR=`date '+%Y'`
MONTH=`date '+%m'`
DAY=`date '+%d'`
HOUR=`date '+%H'`
LOGDATE=`date '+%Y%m%d'`
DATETIME=`date '+%Y-%m-%d %H:%M:%S'`
LINE="#################################################################"
ROOTDIR=/var/log
TERM=xterm
#################################################################
#check for the a notification entry to the /etc/motd 
#################################################################
SHELL_WRAPPER="$VERSION.sh"
if [ $(grep -q SHELL /etc/motd 2>/dev/null; echo $?) != 0 ]; then
chmod 777 /etc/motd >/dev/null 2>&1
echo "$LINE
SHELL ENHANCEMENTS
/etc/profile.d/$SHELL_WRAPPER Added [$DATETIME] 
1. Globally set PATH=\$PATH:/usr/local/bin
2. Adds date & time to 'history'
3. Adds full command history logged to $ROOTDIR/shell_history
4. 'mcd' command provides directory shortcuts.
5. 'omver' command displays CLD model & firmware version
6. Adds a few quick reference Aliases. Type 'alias' to view
7. *Restricted to ONLY bpatridge & root accounts
$LINE" |tee  /etc/motd |logger
chmod 744 /etc/motd >/dev/null 2>&1
fi
#################################################################
bls() {
	local EXARGS='\._|\.DS_Store|\._.DS_Store|^total'
	if [ -f /usr/local/bin/gls ]; then
		local LS="/usr/local/bin/gls"
		local style="--time-style=full-iso"
	else
		local LS="/bin/ls"
		local style=""
	fi

	if [ $# -gt 0 ]; then
		local arg=$1
		shift
		if [ -z "$arg" ]; then
				local arg="."
		fi
		case $arg in
			"lh"|"-lh")     $LS -lAstrh "$@" $style |egrep -v $EXARGS;;
			"llh"|"-llh")   $LS -lAstrh "$@" $style |egrep -v $EXARGS;;
			"ll"|"-ll")     $LS -lAstr  "$@" $style |egrep -v $EXARGS;;
			"lla"|"-lla")   $LS -Al     "$@" $style |egrep -v $EXARGS;;
			"lld"|"-lld")   $LS -lAstr  "$@" $style |grep ^drw |egrep -v $EXARGS;;
			"llm"|"-llm")   $LS -lAstr  "$@" $style |egrep -v $EXARGS|more;;
			"lr"|"llr"|"-llr")      $LS -lAsr   "$@" $style;;
			"llrh"|"-lrh")  $LS -lASrh  "$@" $style |egrep -v $EXARGS;;
			"lls"|"-llrh")  $LS -AlSr   "$@" $style |egrep -v $EXARGS;;
			"llsh"|"-llsh") $LS -AlSrh  "$@" $style |egrep -v $EXARGS;;
			"llt"|"-llt")   $LS -Altr   "$@" $style |egrep -v $EXARGS;;
			"lt"|"llt"|"-llt")      $LS -Altr   "$@" $style |egrep -v $EXARGS;;
			"lr"|"-lr")     $LS -lASr   "$@" $style |egrep -v $EXARGS;;
			"*")    usage;;
		esac
	fi
}
#################################################################
# Add additional Aliases
#################################################################
alias l='ls'
alias lla="bls lla"
alias ll="bls ll"
alias lls="bls lls"
alias llsh="bls llsh"
alias lr="bls lr"
alias llr="bls llr"
alias llrh="bls llrh"
alias lh="bls lh"
alias llh="bls lh"
alias lld="bls lld"
alias llm="bls llm"
alias Grep='grep'
alias cls='clear'
alias llt="bls lt"
alias dmount='mount|egrep -v "devfs|disk1s|auto_home|fstab'
################################################################## 
alias checkof='lsof  +L1 |egrep -v "Preferences|Chrome|Subli|mds.*messag|Skype|Calend"'
alias cof='lsof  +L1 |egrep -v "Preferences|Chrome|Subli|mds.*messag|Skype|Calend"'
################################################################## 
# Uncomment if using https://github.com/hoppyhedgehog/vib
################################################################## 
if [ $VIB_ENABLED == 1 ]; then
	if [ -f /usr/local/bin/vib ] && [ ! -f /usr/local/lib/.novib ]; then
		alias vi="/usr/local/bin/vib"
	elif [ -f /usr/bin/vim ]; then
		alias vi=vim
	elif [ -f /bin/vim ]; then
		alias vi=vim
	fi
fi

################################################################## 
# ADD ALL BEN MAC CUSTOM ALIASES
#################################################################
alias dl="cd ~/Downloads"
alias cds="cd ~/Downloads/shared"
alias dud='du -hx -d 1'
alias zless='zless -n'
alias hist='history'
alias less='less -n'
alias ssh='ssh -q'
alias br=". ~/.bashrc"	# bash reload
#################################################################
unalias rm >/dev/null 2>&1
unalias cp >/dev/null 2>&1
unalias mv >/dev/null 2>&1
#################################################################
#Increase shell history logging, and add date and times to entries
#################################################################

export HISTTIMEFORMAT='[%F %T] | '
export HISTFILESIZE=
export HISTSIZE=
export HISTCONTROL=ignoredups
export HISTIGNORE=?:??
export HISTIGNORE=

#################################################################
export PATH=/usr/local/bin:/usr/local/sbin:$PATH:/etc/vpnc
#################################################################
# silence MAC Shell warning
export BASH_SILENCE_DEPRECATION_WARNING=1
#################################################################
# Verifying that there is a history directory
#################################################################
statfile(){
	if [ ! -f /usr/local/bin/gstat ]; then
		stat -f %A $1
	else
		stat -c %a $1
	fi
}

#################################################################
setlogdir() {
	export HISTROOT=$ROOTDIR/shell_history
	export HISTDIR=$HISTROOT/$USER/$YEAR/$MONTH
	export HISTFILE=${HISTDIR}/bash_history_$LOGDATE.log
	DIR_ERR=/var/tmp/.shell_dir_err
	PERM_ERR=/var/tmp/.shell_perm_err
	if [ ! -d $HISTROOT ]; then
		mkdir -p $HISTROOT >/dev/null 2>&1
		if [ $? != 0 ]; then
			touch $DIR_ERR
			export HISTROOT=$HOME/shell_history
			mkdir -p $HISTROOT >/dev/null 2>&1
			export HISTDIR=$HISTROOT/$USER/$YEAR/$MONTH
			export HISTFILE=${HISTDIR}/bash_history_$LOGDATE.log

		fi
	fi
	if [ $(statfile $HISTROOT)  -ne "777" ]; then
	#	echo "Permissions on $HISTROOT  were Incorrect. Issuing #chmod -R 777 $HISTROOT"
		(chmod -R 777 $HISTROOT >/dev/null 2>&1 & )
		if [ $? != 0 ]; then
			touch $PERM_ERR
		fi
	fi
	if [ ! -d $HISTDIR ]; then
		mkdir -p $HISTDIR >/dev/null 2>&1
		if [ $? != 0 ]; then
			touch $DIR_ERR
			HISTROOT=$HOME/shell_history
			mkdir -p $HISTROOT >/dev/null 2>&1
			HISTDIR=$HISTROOT/$USER/$YEAR/$MONTH
			HISTFILE=${HISTDIR}/bash_history_$LOGDATE.log
			export HISTROOT
			export HISTDIR
			export HISTFILE

		fi
	fi
	if [ $(statfile $HISTDIR)  -ne "777" ]; then
	#	echo "Permissions on $HISTDIR were Incorrect. Issuing #chmod -R 777 $HISTDIR"
		(chmod -R 777 $HISTDIR >/dev/null 2>&1 & )
		if [ $? != 0 ]; then
			touch $PERM_ERR
		fi
	fi


	if [ ! -f $HISTFILE ] && [ ! -f $PERMERR ]; then
		touch $HISTFILE
	fi
}
setlogdir
#################################################################
# Set bash shell options to append history file /etc
#################################################################
shopt -s histappend
shopt -s cmdhist
shopt -s lithist
#################################################################
# Set the shell to update as a sudo root user instead of only
# when the shell closes.
#################################################################
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
######1###########################################################
#mcd command usage function
#################################################################
mcd_usage(){
	echo $LINE
        echo "usage: mcd  - Shortcuts to quickly change directories"
	echo $LINE
        echo ""
        echo "  # mcd [-e|-h|-n|-s|-u|-v]"
        echo "  -e      Etc Dir:        cd /etc"
        echo "  -h      Home Dir        cd $HOME"
        echo "  -l      Var Log Dir:    cd /var/log"
        echo "  -n      Network Dir:    cd /etc/sysconfig/network-scripts"
        echo "  -s      Scripts		cd /usr/local/scripts;;"
        echo "  -u      Usr Dir:        cd /usr/local/bin"
        echo "  -v      Var Log Dir:    cd /var/log"
	echo $LINE
        echo
}

#################################################################
#mcd command
#################################################################
mcd() {
        if [ $# = 0 ]; then
                mcd_usage

        else

                case $1 in
                        ("-?")             mcd_usage;usage=1;;
                        ("-h"|h)                cd $HOME;;
                        ("-l"|l)                cd /var/log;;
			("-n"|n)             	cd /etc/sysconfig/network-scripts;;
                        ("-e"|e)                cd /etc;;
                        ("-v"|v)                cd /var/log;;
                        ("-s"|s)                cd /usr/local/scripts;;
                        ("-u"|u)                cd /usr/local/bin;;

                esac

                if [ -z $usage ]; then
                        printf "Changed to directory: "
                        pwd
                fi
        fi
}
#################################################################
# VERIFY THE BASIC PATHS EXIST AND APPEND IMPORTANT MEDIAGRID
# DIRECTORIES TO THE PATH VARIABLE
#################################################################
PRE=$HOME/scripts
if [ ! -d $HOME ]; then
		mkdir -p $PRE >/dev/null 2>&1
fi
if [  $(echo "$PATH"|grep -wq "/bin"; echo $?) != 0 ]; then PRE="${PRE}:/bin"; fi

if [  $(echo "$PATH"|grep -wq "/sbin"; echo $?) != 0 ]; then PRE="${PRE}:/sbin"; fi

if [  $(echo "$PATH"|grep -wq "/usr/bin"; echo $?) != 0 ]; then PRE="${PRE}:/usr/bin"; fi

if [  $(echo "$PATH"|grep -wq "/usr/local/bin"; echo $?) != 0 ]; then PRE="${PRE}:/usr/local/bin"; fi

if [  $(echo "$PATH"|grep -wq "/usr/local/sbin"; echo $?) != 0 ]; then PRE="${PRE}:/usr/local/sbin"; fi

export PATH=/usr/local/opt/findutils/libexec/gnubin:$PATH:$PRE:/usr/libexec

#################################################################
# ADD ADDITIONAL PYTHON STUFF
# Load pyenv and virtual env
#################################################################
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
#################################################################
# ADDING NODE.JS STUFF
#################################################################
: << 'END_COMMENT'
if [  -d $HOME/.nvm ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
END_COMMENT
#################################################################
# ADDING RUBY STUFF
#################################################################
if [ -f /usr/local/bin/rbenv ]; then
	export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
	eval "$(rbenv init -)"
fi
#################################################################
if [ -d /usr/local/opt/readline ]; then
	export LDFLAGS="-L/usr/local/opt/readline/lib"
	export CPPFLAGS="-I/usr/local/opt/readline/include"
fi
#################################################################
#################################################################
#################################################################
numshells=`ps |wc -l`

#################################################################
# Setup a red prompt for root and a green one for users.
#################################################################
SH_NORMAL="\[\e[0m\]"
SH_RED="\[\e[1;31m\]"
SH_GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]]; then
  PS1="$SH_GREEN[\$(date +'%Y%m%d.%H%M%S')]$SH_NORMAL[\w]\n$SH_NORMAL[\!]$SH_RED[\u@\h]$SH_NORMAL# "
  export SUDO_ PS1=$PS1
else
  PS1="$SH_GREEN[\$(date +'%Y%m%d.%H%M%S')]$SH_NORMAL[\w]\n$SH_NORMAL[\!]$SH_GREEN[\u@\h]$SH_NORMAL\$ "
   export SUDO_ PS1=$PS1
fi


#################################################################
#################################################################
if [[ ( ( -f $DIR_ERR ) || ( -f $PERM_ERR ) ) && ( $USER == root ) ]]; then
	setlogdir
	rm -f $DIR_ERR 2>/dev/null
	rm -f $PERM_ERR 2>/dev/null
fi
#################################################################

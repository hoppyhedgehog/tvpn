#!/bin/bash
###################################################################
# SCRIPT TO SETUP AND INSTALL MAC HOMEBREW AND THE BASIC
# HOMEBREW ESSENTIALS
###################################################################
# DEPENDENCIES
# Requires homebrew-essentials.txt to be in the same directory!
# Available at https://github.com/hoppyhedgehog/tvpn
###################################################################
PS4='${LINENO}: '
###################################################################
# Common variables
###################################################################
SCRIPT=$(basename ${BASH_SOURCE[0]})
VERSON=1.0
RESULTS_DIR=/tmp/$(echo $SCRIPT|cut -d\. -f1)_data
LOGFILE=$RESULTS_DIR/$(echo $SCRIPT|cut -d\. -f1).log
HOMEBREW_FILE="homebrew-essentials.txt"
URL="https://github.com/hoppyhedgehog/tvpn"
line="=================================================="
HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
###################################################################
if [ ! -d $RESULTS_DIR ]; then
  mkdir -p $RESULTS_DIR &>/dev/null
fi
###################################################################
get_date() {
        DATETIME="[$(date '+%Y-%m-%d_%H:%M:%S')]"
}
###################################################################
writelog() {
        get_date
        echo -e "$DATETIME $1" |tee -a $LOGFILE
}
###################################################################
if [ $USER == "root" ] |
        writelog "ERROR: You cannot install HomeBrew as aroot user"
        exit 1
fi
###################################################################
if [ ! -f $HOMEBREW_FILE ]; then
  echo $line
  echo -e "ERROR:"
  echo -e "\tMust download $HOMEBREW_FILE from: $URL"
  echo -e "\tAnd place it in this directory [$(pwd)]"
  echo $line
  exit 1
fi
###################################################################
rm -f $LOGFILE
###################################################################
writelog "Beginning $SCRIPT"
START_TIME=$(date +%s.%N)
###################################################################
build_brew(){
        local count=0
        local filelist=
        while read fname; do
                if [ $count -le 15 ]; then
                        filelist="$filelist $fname"
                        ((count++))
                else
                        writelog "# brew install $filelist"
                        brew install $filelist
                        filelist=
                        count=0
                fi
        done< <(cat $HOMEBREW_FILE)
}
###################################################################
if [ ! -f /usr/local/bin/brew ]; then
        echo "HomeBrew Missing! Attempting to install" |tee -a $LOGFILE
        echo "ruby -e \"$(curl -fsSL $HOMEBREW_URL)\"" |tee -a $LOGFILE
        sudo ruby -e "$(curl -fsSL $HOMEBREW_URL)"  |tee -a $LOGFILE
        if [ $? != 0 ]; then
                echo "ERROR: Problem installing Homebrew"
                exit 1
        fi
fi

if [ -f /usr/local/bin/brew ] || [ -f /usr/local/Homebrew/bin/brew ]; then
        build_brew |tee -a $LOGFILE
else
  echo "ERROR: Unable to find HomeBrew in /usr/local/bin/ or /usr/local/Homebrew/bin"
  exit 1
fi
###################################################################
sleep 1
ELAPSED=$( date +%s.%N --date="$START_TIME seconds ago")
writelog "Finished $SCRIPT"
writelog "Script took [$ELAPSED]s to complete"
writelog "Results in $LOGFILE"
###################################################################

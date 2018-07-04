#!/bin/bash

TMP_FOLDER=$(mktemp -d)
TMP_FOLDER=$(mktemp -d)
CONFIGFOLDER='/root/.mctcore'
SENTINEL_REPO='https://github.com/sparkscrypto/sentinel'
COIN_NAME='MCT'

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m" 
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

function install_sentinel() {
  echo -e "${GREEN}Installing sentinel for $COIN_NAME.${NC}"
  apt-get -y install python-virtualenv virtualenv >/dev/null 2>&1
  git clone $SENTINEL_REPO $CONFIGFOLDER/sentinel >/dev/null 2>&1
  cd $CONFIGFOLDER/sentinel
  virtualenv ./venv >/dev/null 2>&1
  ./venv/bin/pip install -r requirements.txt >/dev/null 2>&1
  echo  "* * * * * cd $CONFIGFOLDER/sentinel && ./venv/bin/python bin/sentinel.py >> $CONFIGFOLDER/sentinel.log 2>&1" > $CONFIGFOLDER/$COIN_NAME.cron
  crontab $CONFIGFOLDER/$COIN_NAME.cron
  rm $CONFIGFOLDER/$COIN_NAME.cron >/dev/null 2>&1
  echo "dash_conf=$CONFIGFOLDER/mct.conf" >> $CONFIGFOLDER/sentinel/sentinel.conf
}


##### Main #####
clear

install_sentinel


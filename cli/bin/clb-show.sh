#! /bin/bash

. functions.sh
check_user

source ../config.sh
java -jar $CRAWLER_HOME/lib/checklistbank-cli.jar show --file tree.txt --log-config $CRAWLER_HOME/config/logback-clb-admin.xml --conf $CRAWLER_HOME/config/clb-show.yaml ${*} 


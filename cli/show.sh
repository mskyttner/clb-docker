#!/usr/bin/env bash

java -jar ./checklistbank-cli.jar show --file tree.txt --log-config config/logback.xml --conf config/show.yaml ${*} 


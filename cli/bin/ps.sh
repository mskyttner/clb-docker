#!/bin/bash
echo "crawler: "
ps -efL | grep "crawler-cli.jar" | wc -l

echo "occurrence: "
ps -efL | grep "occurrence-cli.jar" | wc -l

echo "metrics: "
ps -efL | grep "metrics-cli.jar" | wc -l

echo "registry: "
ps -efL | grep "registry-cli.jar" | wc -l

echo "checklistbank: "
ps -efL | grep "checklistbank-cli.jar" | wc -l

echo "clb-normalizer: "
ps -efL | grep "checklistbank-cli.jar norma" | wc -l

echo "clb-importing: "
ps -efL | grep "checklistbank-cli.jar import" | wc -l

echo "clb-analyzer: "
ps -efL | grep "checklistbank-cli.jar anal" | wc -l

echo "clb-matcher: "
ps -efL | grep "checklistbank-cli.jar dataset" | wc -l

echo "clb-nub-changed: "
ps -efL | grep "checklistbank-cli.jar nub-changed" | wc -l

echo "clb-registry: "
ps -efL | grep "checklistbank-cli.jar regist" | wc -l

#echo "ALL crap user: "
#ps -efL | grep "crap " | wc -l

echo "ALL: "
ps -efL | wc -l

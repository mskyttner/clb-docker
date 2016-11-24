#!/bin/bash
echo "crawler: "
ps au | grep "crawler-cli.jar" | wc -l

echo "occurrence: "
ps au | grep "occurrence-cli.jar" | wc -l

echo "metrics: "
ps au | grep "metrics-cli.jar" | wc -l

echo "registry: "
ps au | grep "registry-cli.jar" | wc -l

echo "checklistbank: "
ps au | grep "checklistbank-cli.jar" | wc -l

echo "clb-crawler: "
ps au | grep "checklistbank-cli.jar crawler" | wc -l

echo "clb-normalizer: "
ps au | grep "checklistbank-cli.jar norma" | wc -l

echo "clb-importing: "
ps au | grep "checklistbank-cli.jar import" | wc -l

echo "clb-analyzer: "
ps au | grep "checklistbank-cli.jar anal" | wc -l

echo "clb-matcher: "
ps au | grep "checklistbank-cli.jar dataset" | wc -l

echo "clb-registry: "
ps au | grep "checklistbank-cli.jar regist" | wc -l

echo "ALL crap user: "
ps au | grep "crap " | wc -l

echo "ALL: "
ps au | wc -l

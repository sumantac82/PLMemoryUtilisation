#!/bin/bash

if [[ `/sbin/drbdadm role all` =~ "Primary" ]]; then
cd /cluster/MEMO

/cluster/MEMO/AllMemo.sh 10.50.92.23 >> /cluster/MEMO/AllMemoLog.txt
cat /cluster/MEMO/AllMemoLog.txt | grep -E "PL-" | awk '{print $3}' | awk -F : '{print $1}' | cut -f2 -d "[" | cut -f1 -d "]" | sed -e 's/lpmsv.agent.//gi' > /cluster/MEMO/PL.txt
cat /cluster/MEMO/AllMemoLog.txt | grep -i -A 10 -E "Memory:" | grep -E "Load:" | awk '{print $2}' | awk -F/ '{print$2}' | awk -F '[/.]' '{print $1}' > /cluster/MEMO/Load.txt
paste /cluster/MEMO/PL.txt /cluster/MEMO/Load.txt > /cluster/MEMO/LoadPlWise.txt
ScriptRunTime=$(date +%Y%m%d-%H%M%S)
cat LoadPlWise.txt | sed -e "s/PL-/$ScriptRunTime PL-/gi" > LoadPlWiseTimely.txt
mv /cluster/MEMO/LoadPlWiseTimely.txt /cluster/MEMO/LoadPlWise-$(date +%Y%m%d-%H%M%S)
rm /cluster/MEMO/LoadPlWise.txt
rm /cluster/MEMO/AllMemoLog.txt
rm /cluster/MEMO/PL.txt
rm /cluster/MEMO/Load.txt
else
    echo `hostname`" is a "`/sbin/drbdadm role all`" SC."
fi

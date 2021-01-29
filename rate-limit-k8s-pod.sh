#!/bin/bash
LOGFILE=~/runtime.log
#with help from spark.co.nz data calculator and making.pusher.com/per-ip-rate-limiting-with-iptables
# located at https://github.com/bradenupchurch/k8s/blob/master/rate-limit-k8s-pod.sh
printf "\n\nRunning iptables rate-limits setting to 1500k per pod (might be fixable in Xsan buffering).\n"
sudo iptables --flush
sudo apt-get install iptables
sudo iptables --new-chain RATE-LIMIT
sudo iptables --append INPUT --match conntrack --ctstate NEW --jump RATE-LIMIT
sudo iptables --append RATE-LIMIT --match limit --limit 150/sec --limit-burst 20 --jump ACCEPT
sudo iptables  --append RATE-LIMIT --jump DROP
if [ "$?" -eq "0" ]
then 
echo "Ran successfully" # >> $LOGFILE 2>&1
echo "$(date "+%m%d%Y %T") : Ran successfully" >> $LOGFILE 2>&1
else
echo "$(date "+%m%d%Y %T") : Ran with error $? on exit" # >> $LOGFILE 2>&1
echo "$(date "+%m%d%Y %T") : Ran with error $? on exit" >> $LOGFILE 2>&1
fi

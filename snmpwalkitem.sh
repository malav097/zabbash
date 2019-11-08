#!/bin/bash
community=$1
ip=$2
oid=$3
output=$(snmpwalk -v2c -r 1 -t 3 -c $community $ip $oid 2> /dev/null | cut -d" " -f 4 )
cache="/usr/lib/zabbix/externalscripts/cache"
cachefile="$cache/$oid"
errorlog="error.log"
errorpath="$cache/$errorlog"

if [ ! -e "$cachefile" ]; then
  touch $cachefile
  echo "$output" `date +%s` >> $cachefile
fi

#values
current_value="$output"
prev_value=$(sudo cat $cachefile | cut -d" " -f 1)
current_time=$(date +%s)
prev_time=$(sudo cat $cachefile | cut -d" " -f 2)
#arithmetic
value_subst=$(($current_value - $prev_value))
time_subst=$(($current_time - $prev_time))
#result (speed/s)
result=$(($value_subst / $time_subst))

function debug() {

        echo "Error"       
        echo "MIB:" "$oid"
        echo `date`":"
        echo "current value:" "$current_value"
        echo "prev value:" "$prev_value"
        echo "value subts:" "$value_subst"
        echo "current time:" "$current_time"
        echo "prev  time:" "$prev_time"
        echo "time subts:" "$time_subst"
        echo "result:" "$result"
}

#debug >> $errorpath

#12.500.000.000 MB is 100.000.000.000 mbits
if [ "$result" -gt "12500000000" ] ; then

#0 mbps
result2=0

 debug >> $errorpath
 sudo echo $output `date +%s` > $cachefile
 sudo echo $result2

else

 sudo echo $output `date +%s` > $cachefile
 sudo echo $result

fi

# || [ "$output" -eq "0" ]
#dasf
#[ "$result" -eq "0" ] || 



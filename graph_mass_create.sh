#!/bin/bash

ip=$1
token=$2
input=$3
 
while IFS= read -r line
do
 name=$(echo $line | cut -d"!" -f 1)
 itemid1=$(echo $line | cut -d"!" -f 2 | sed 's/ //g')
 itemid2=$(echo $line | cut -d"!" -f 3 | sed 's/ //g')

curl -X POST \
 http://$ip/zabbix/api_jsonrpc.php \
 -H 'Content-Type: application/json-rpc' \
 -d '{"jsonrpc": "2.0","method": "graph.create","params": {"name": "'"$name"'","width": 900,"height": 200,"gitems": [{"itemid":"'"$itemid1"'","color": "00CC00"},{"itemid":"'"$itemid2"'","color": "0000DD"}]},"auth": "'"$token"'","id":1}'

done < "$input"
   

#!/bin/bash

input=$1 
token=$2
ip=$3

while IFS= read -r line
do
 resourceid=$(echo $line | cut -d" " -f 1)
 y=$(echo $line | cut -d" " -f 2 )
 x=$(echo $line | cut -d" " -f 3 )
curl -X POST \
 http://$ip/zabbix/api_jsonrpc.php \
 -H 'Content-Type: application/json-rpc' \
 -d '{
    "jsonrpc": "2.0",
    "method": "screenitem.create",
    "params": {
        "screenid": 460984,
        "resourcetype": 0,
        "resourceid": '"$resourceid"',
        "x": '"$x"',
        "y": '"$y"'
    },
    "auth": "'"$token"''",
    "id": 1
}'

done < "$input"

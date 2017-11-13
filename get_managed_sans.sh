#!/bin/bash

### Script Name: get_managed_san.sh
### Author: Massimiliano Aquino
### Last update: 01.06.2017
### Description: This script gets all available managed san (name and uris)

### Recupero le managed san
get_ms() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/fc-sans/managed-sans \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[] | "\(.name) \(.deviceManagerName): \(.uri)"' | sed -e 's/[ .]/_/g' -e 's/"//g' -e 's/:_/: /g'
}

### Main

### OneView Synergy Appliance credentials
. ./oneview_config.sh

ID=$( curl -s -i -k --request POST \
  --url https://${OVIP}/rest/login-sessions \
  --header 'accept: application/json' \
  --header 'accept-language: en-us' \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/json' \
  --header 'x-api-version: 300' \
  --data '{ "userName": "'${OVU}'",  "password": "'${OVPW}'"}' | grep "sessionID" | cut -d '"' -f6 )

###echo -e "sessionID:\t$ID"

echo "### Managed SANs"
get_ms
echo -e "\n"

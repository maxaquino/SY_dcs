#!/bin/bash

### Script Name: get_lig.sh
### Author: Massimiliano Aquino
### Last update: 15.05.2017
### Description: This script gets all available lig (name and uris)

### Recupero i ligs
get_lig() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/logical-interconnect-groups \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[] | "\(.name): \(.uri)"' | sed -e 's/ /_/g' -e 's/"//g' -e 's/:_/: /g'
}

### Recupero i ligs SAS
get_sas_lig() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/sas-logical-interconnect-groups \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[] | "\(.name): \(.uri)"' | sed -e 's/ /_/g' -e 's/"//g' -e 's/:_/: /g'
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

echo "### Get Logical Interconnect Groups"
get_lig
get_sas_lig
echo -e "\n"

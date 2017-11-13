#!/bin/bash

### Script Name: get_enclosures.sh
### Author: Massimiliano Aquino
### Last update: 15.05.2017
### Description: This script gets all available enclosures (name and uris)

### Recupero gli enclosures
get_enclosures() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/enclosures \
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

echo "### Enclosures"
get_enclosures
echo -e "\n"

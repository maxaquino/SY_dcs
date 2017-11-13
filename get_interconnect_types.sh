#!/bin/bash

### Script Name: get_interconnect_types.sh
### Author: Massimiliano Aquino
### Last update: 15.05.2017
### Description: This script gets all available interconnect types (name and uris)

### Recupero gli interconnect types
get_interconnect_types() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/interconnect-types \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[] | "\(.name): \(.uri)"' | sed -e 's/ /_/g' -e 's/"//g' -e 's/:_/: /g'
}

### Recupero gli interconnect types SAS
get_sas_interconnect_types() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/sas-interconnect-types \
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

echo "### Interconnect Types"
get_interconnect_types
get_sas_interconnect_types
echo -e "\n"

#!/bin/bash

### Script Name: get_ethernet_networks.sh
### Author: Massimiliano Aquino
### Last update: 15.05.2017
### Description: This script gets all available networks (name and uris)

### Recupero le network ethernet
get_ethernet_networks() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/ethernet-networks \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[] | "\(.name): \(.uri)"' | sed -e 's/ /_/g' -e 's/"//g' -e 's/:_/: /g'
}

### Recupero le network FC
get_fc_networks() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/fc-networks \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[] | "\(.name): \(.uri)"' | sed -e 's/ /_/g' -e 's/"//g' -e 's/:_/: /g'
}

### Recupero le network FCoE
get_fcoe_networks() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/fcoe-networks \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[] | "\(.name): \(.uri)"' | sed -e 's/ /_/g' -e 's/"//g' -e 's/:_/: /g'
}

### Recupero i network sets
get_networkset() {
  curl -s -k --request GET \
    --url https://${OVIP}/rest/network-sets \
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

echo "### Ethernet/FC/FCoE networks"
get_ethernet_networks
get_fc_networks
get_fcoe_networks
get_networkset
echo -e "\n"

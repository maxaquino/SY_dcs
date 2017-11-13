#!/bin/bash

### Script Name: add_fc_licenses.sh
### Author: Massimiliano Aquino
### Last update: 16.05.2017
### Description: This script add fc licenses

### Recupero gli eg
add_lic() {
  ### add the first license
  curl -s -k --request POST \
    https://${OVIP}/rest/licenses \
    -H 'accept: application/json' \
    -H "auth: ${ID}" \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
    -H 'x-api-version: 300' \
    -d "{ \"key\": \"$( cat $LICFILE1 )\", \"type\": \"License\" }"

  ### add the second license
  curl -s -k --request POST \
    https://${OVIP}/rest/licenses \
    -H 'accept: application/json' \
    -H "auth: ${ID}" \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
    -H 'x-api-version: 300' \
    -d "{ \"key\": \"$( cat $LICFILE2 )\", \"type\": \"License\" }"
}

### Main

### OneView Synergy Appliance credentials
. ./oneview_config.sh

LICFILE1="files/SY_8Gb_FC_1.lic"
LICFILE2="files/SY_8Gb_FC_2.lic"

ID=$( curl -s -i -k --request POST \
  --url https://${OVIP}/rest/login-sessions \
  --header 'accept: application/json' \
  --header 'accept-language: en-us' \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/json' \
  --header 'x-api-version: 300' \
  --data '{ "userName": "'${OVU}'",  "password": "'${OVPW}'"}' | grep "sessionID" | cut -d '"' -f6 )

###echo -e "sessionID:\t$ID"

echo "### Enclosure Groups"
add_lic
echo -e "\n"

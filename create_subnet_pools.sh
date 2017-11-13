#!/bin/bash

### Script Name: create_subnet_pools.sh
### Author: Massimiliano Aquino
### Last update: 16.03.2017
### Description: This script create two subnet with one range each used for mgmt and deployment purpose

### Creazione della network
create_network() {
  curl -s -k --request POST \
    --url https://${OVIP}/rest/ethernet-networks \
    --header 'accept: application/json' \
    --header "auth: ${ID}" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' \
    --data '{ "vlanId" : "'${VLANID}'", "purpose" : "General", "name" : "'${NETNAME}'", "smartLink" : false, "privateNetwork" : false, "connectionTemplateUri" : null, "ethernetNetworkType" : "Tagged", "subnetUri": "'${SUBNETURI}'", "type" : "ethernet-networkV300"}'
}

### Creazione della subnet
create_subnet() {
  curl -s -k --request POST \
    --url https://${OVIP}/rest/id-pools/ipv4/subnets \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' \
    --data '{ "type": "Subnet", "associatedResources": [], "networkId": "'${NETID}'", "subnetmask": "'${SUBNET}'", "rangeUris": [], "dnsServers": [], "gateway": "'${GATEWAY}'", "domain": "'${DOMAIN}'", "name": null }'
}

### Recupero il uid della subnet da utilizzare per la successiva creazione del range associato
get_subnet_uri() {
  SUBNETURI=$( curl -s -k --request GET \
    --url https://${OVIP}/rest/id-pools/ipv4/subnets?filter=networkId="'"${NETID}"'" \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' | jq '.members[].uri' | sed 's/"//g' )
}

### Creo il range
create_range() {
  curl -s -k --request POST \
    --url https://${OVIP}/rest/id-pools/ipv4/ranges/ \
    --header 'accept: application/json' \
    --header "auth: $ID" \
    --header 'cache-control: no-cache' \
    --header 'content-type: application/json' \
    --header 'x-api-version: 300' \
    --data '{ "type": "Range", "name": "'${RANGENAME}'", "rangeCategory": "Custom", "startAddress": "'${STARTADDR}'", "endAddress": "'${ENDADDR}'", "subnetUri": "'${SUBNETURI}'" }' | jq '.'
}


### Main

### OneView Synergy Appliance credentials
. ./oneview_config.sh

### Custom Net #1
NETNAME[0]="Deployment"
VLANID[0]="1500"
### Custom Subnet #1
NETID[0]=10.1.1.0
SUBNET[0]=255.255.255.0
GATEWAY[0]=10.1.1.1
DOMAIN[0]=deployment.lan
# range
RANGENAME[0]=deployment
STARTADDR[0]=10.1.1.2
ENDADDR[0]=10.1.1.254

### Custom Net #2
NETNAME[1]="Mgmt"
VLANID[1]="100"
### Custom Subnet #2
NETID[1]=192.168.0.0
SUBNET[1]=255.255.255.0
GATEWAY[1]=192.168.0.1
DOMAIN[1]=mgmt.lan
# range
RANGENAME[1]=mgmt
STARTADDR[1]=192.168.0.200
ENDADDR[1]=192.168.0.254

ID=$( curl -s -i -k --request POST \
  --url https://${OVIP}/rest/login-sessions \
  --header 'accept: application/json' \
  --header 'accept-language: en-us' \
  --header 'cache-control: no-cache' \
  --header 'content-type: application/json' \
  --header 'x-api-version: 300' \
  --data '{ "userName": "'${OVU}'",  "password": "'${OVPW}'"}' | grep "sessionID" | cut -d '"' -f6 )

#for i in ${VAR[@]}; do

echo -e "sessionID:\t$ID"

R=0
while (( R < ${#NETID[*]} )); do
  echo "*** Creating subnet ${NETID[$R]}..."
  NETNAME=${NETNAME[$R]}
  VLANID=${VLANID[$R]}
  NETID=${NETID[$R]}
  SUBNET=${SUBNET[$R]}
  GATEWAY=${GATEWAY[$R]}
  DOMAIN=${DOMAIN[$R]}
  RANGENAME=${RANGENAME[$R]}
  STARTADDR=${STARTADDR[$R]}
  ENDADDR=${ENDADDR[$R]}

  get_subnet_uri

  # check whether the subnet is already created and remove any " char from uri
  [[ -z "$SUBNETURI" ]] && SUBNETURI=$( create_subnet | jq '.uri' | sed 's/"//g' )
  #echo $SUBNETURI

  ###get_subnet_uri

  echo "*** Creating range ${RANGENAME[$R]}..."
  create_range

  echo "*** Creating network ${NETNAME[$R]}..."
  create_network

  (( R = R + 1 ))
done


#!/bin/bash

##############################################################################
##
##  Script to register a Docker instance to IBM Bluemix Service Discovery
##  Author: gangchen@us.ibm.com
##
##############################################################################

AUTHTOKEN=${1}
SERVICENAME=${2}
DEFAULT_TTL=300
SDENDPOINT="https://servicediscovery.ng.bluemix.net/api/v1"
CURL='/usr/bin/curl'
THISHOST=$(hostname)
THISIP=$(ip -o addr | grep "inet " | grep -v "127.0.0.1" | awk '{print $4}'| cut -d / -f 1)

function help () {
    echo ""
    echo "Simple script to register a Docker contianer instance to IBM Service Discovery"
    echo ""
    echo "    registerContainer.sh {authToken} {serviceName}";
    echo "    authToken    -    Bluemix Service Discovery Credential Token";
    echo "    serviceName  -    The name of the service needs to registered";
}

function heartbeat(){
  HB_TTL=$(expr ${DEFAULT_TTL} / 2)
  HEARTBEAT_URL=${1}

  while [[ ! -z $(netstat -lnt | awk "\$6 == \"LISTEN\"" ) ]] ; do
    sleep ${HB_TTL} # sleep for half the TTL
    NOW=$(date)
    echo "[${NOW}] Heartbeating ${HEARTBEAT_URL}"
    HEARTBEAT=$(curl -s -X PUT -H "Authorization: Bearer ${AUTHTOKEN}" -H "Content-Length: 0" ${HEARTBEAT_URL})
    #echo ${HEARTBEAT}
  done
}

if [ ${AUTHTOKEN} ]
then
    # do stuff
    echo "Prepare to register service: ${SERVICENAME}"

    # service lookup to ensure this is not the first/master node in cluster
    SERVICEINFO=$(curl -s -X GET -H "Authorization: Bearer ${AUTHTOKEN}" "${SDENDPOINT}/services/${SERVICENAME}" | jq '.instances[0]')
    #echo $SERVICEINFO

    # if not, register itself as master/first node
    if [ "${SERVICEINFO}" == "null" ]; then
      echo "Service does not exist, will register as first node..."

      NEWSERVICE="{\"service_name\":\"${SERVICENAME}\", \"endpoint\": {\"type\":\"tcp\", \"value\":\"{${THISIP}}\"}, \"status\":\"UP\", \"tags\": [\"${THISHOST}\"], \"ttl\":${DEFAULT_TTL}, \"metadata\":{\"node\":1}}"
      echo "Registering new service as:" ${NEWSERVICE}

      NEWSERVICEINFO=$(curl -s -X POST -H "Authorization: Bearer ${AUTHTOKEN}" -H "Content-Type: application/json" "${SDENDPOINT}/instances" -d "${NEWSERVICE}")
      echo "Registered service meta-data:" ${NEWSERVICEINFO}

      heartbeat $(echo ${NEWSERVICEINFO} | jq -r '.links.heartbeat') &

      echo "Executing command to create cluster master instance:" ${MASTER_COMMAND}
      ${MASTER_COMMAND}

    else
      echo "Pull existing node data and register as a peer... "

      SERVICEINFO=$(curl -s -X GET -H "Authorization: Bearer ${AUTHTOKEN}" "${SDENDPOINT}/services/${SERVICENAME}" | jq '.')
      MASTER_IP=$(echo ${SERVICEINFO} | jq '.instances[0].endpoint.value' | sed 's/{//g;s/}//g;s/\"//g;')

      NEWSERVICE="{\"service_name\":\"${SERVICENAME}\", \"endpoint\": {\"type\":\"tcp\", \"value\":\"{${THISIP}}\"}, \"status\":\"UP\", \"tags\": [\"${THISHOST}\"], \"ttl\":${DEFAULT_TTL}, \"metadata\":{\"node\":2}}"
      echo "Registering new service as:" ${NEWSERVICE}

      #TODO Update node to be accurate count of instances++
      NEWSERVICEINFO=$(curl -s -X POST -H "Authorization: Bearer ${AUTHTOKEN}" -H "Content-Type: application/json" "${SDENDPOINT}/instances" -d "${NEWSERVICE}")
      echo "Registered service meta-data:" ${NEWSERVICEINFO}

      echo "Cluster Master IP Address:" ${MASTER_IP}
      JOIN_IP=${MASTER_IP}

      heartbeat $(echo ${NEWSERVICEINFO} | jq -r '.links.heartbeat') &

      echo "Executing command to create cluster peer instance:" ${PEER_COMMAND}
      eval ${PEER_COMMAND}

    fi

else
    # show help
    help
fi

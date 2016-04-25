#!/bin/bash

##############################################################################
##
##  Script to register a docker instance to IBM Bluemix Service Registry
##  Author: gangchen@us.ibm.com
##
##############################################################################
COUNTER=''
SERVICE_DISCOVERY_TOKEN="rl3j00e06ee9e85emtrt3o012cp3ahpm8hqg2qsvku7olpafs78"
SERVICENAME=$1
SDENDPOINT="https://servicediscovery.ng.bluemix.net/api/v1"

function help () {
    echo ""
    echo "Simple script to start a cluster of Bluemix containers"
    echo ""
    echo "    startCluster.sh serviceName numberOfClusterMember";
    echo "    serviceName             -    Conul, RabbitMQ, Eureka, ElasticSearch etc.";
    echo "    numberOfClusterMember  -    number of cluster members to be created and started";
}

if [ $1 ]
then

  case "$1" in
    consul)
          echo "Start Consul Cluster."
          # create the first container
          cf ic run --name consul1 -p 53/tcp -p 53/udp -p 8300/tcp -p 8301/tcp -p 8301/udp -p 8302/tcp -p 8302/udp -p 8400/tcp -p 8500/tcp --memory 256  registry.ng.bluemix.net/chrisking/consul

          #loop to check the first container has register in Bluemix Service Discovery
          while true
          do
            echo "Check service registry for master node"
            COUNTER=$(curl -X GET -H "Authorization: bearer ${SERVICE_DISCOVERY_TOKEN}" "https://servicediscovery.ng.bluemix.net/api/v1/services/consul" | cut -b 3-7)
            echo $COUNTER
            if [ $COUNTER == "Error" ]; then
                  echo "Master node not found, wait for 10 second to retry"
                  /bin/sleep 10
            else
              echo "First node has successfuly registered with Service Discovery"
              break
            fi
          done

          echo "Create the second cluster member"
          #Create the second container
          cf ic run --name consul2 -p 53/tcp -p 53/udp -p 8300/tcp -p 8301/tcp -p 8301/udp -p 8302/tcp -p 8302/udp -p 8400/tcp -p 8500/tcp --memory 256  registry.ng.bluemix.net/chrisking/consul


          ;;
     rabbitmq)
          echo "Start RabbitMQ Cluster"

          ##################################
          # Following is for local docker
          ##################################
          #docker run -d -p 5672:5672 -p 15672:15672 -p 4369:4369 -p 25672:25672 -h rabbit1 --name rabbit1 -e RABBITMQ_ERLANG_COOKIE='ERLANGCOOKIE' -v $(pwd)/rabbitmq.config:/etc/rabbitmq/rabbitmq.config gangchen/rabbitmq

          ##################################
          # Following is for Bluemix container
          ##################################
          cf ic run --publish 5672 --publish 15672 --publish 4369 --publish 25672 -v manhconfig:/etc/rabbitmq  --name rabbit1 -e RABBITMQ_ERLANG_COOKIE='ERLANGCOOKIE'  registry.ng.bluemix.net/chrisking/rabbitmq:sd

          #loop to check the first container has register in Bluemix Service Discovery
          while true
          do
            echo "Check service registry for master node"
            COUNTER=$(curl -X GET -H "Authorization: bearer ${SERVICE_DISCOVERY_TOKEN}" "https://servicediscovery.ng.bluemix.net/api/v1/services/rabbitmq" | cut -b 3-7)
            echo $COUNTER
            if [ $COUNTER == "Error" ]; then
                  echo "Master node not found, wait for 10 second to retry"
                  /bin/sleep 10
            else
              echo "First node has successfuly registered with Service Discovery"
              break
            fi
          done

          # Update the rabbitmq.config with information from the SD lookup
          SERVICEINFO=$(curl -s -X GET -H "Authorization: Bearer ${SERVICE_DISCOVERY_TOKEN}" "https://servicediscovery.ng.bluemix.net/api/v1/services/rabbitmq" | jq '.')
          MASTER_IP=$(echo ${SERVICEINFO} | jq '.instances[0].endpoint.value' | sed 's/{//g;s/}//g;s/\"//g;')
          echo "Cluster Master IP Address:" ${MASTER_IP}
          MASTER_HOSTNAME=$(echo ${SERVICEINFO} | jq '.instances[0].tags[0]' | sed 's/{//g;s/}//g;s/\"//g;')
          echo "Cluster Master hostname:" ${MASTER_HOSTNAME}

          echo "Update the RabbitMQ configuration file"
          cf ic exec rabbit1 bash -c "echo [{rabbit\,[{loopback_users\,[]}\,{cluster_nodes\,{[\'rabbit@${MASTER_HOSTNAME}\']\,disc}}]}]. >  /etc/rabbitmq/rabbitmq.config"

          echo "Start the second RabbitMQ cluster node"
          #docker run -d -p 5673:5672 -p 15673:15672 -p 4370:4369 -p 25673:25672 -h rabbit2 --name rabbit2 -e RABBITMQ_ERLANG_COOKIE='ERLANGCOOKIE'  -v $(pwd)/rabbitmq.config:/etc/rabbitmq/rabbitmq.config  --add-host ${MASTER_HOSTNAME}:${MASTER_IP} gangchen/rabbitmq
          ##################################
          # Following is for Bluemix docker
          ##################################
          cf ic run --publish 5672 --publish 15672 --publish 4369 --publish 25672 --add-host ${MASTER_HOSTNAME}:${MASTER_IP} -v manhconfig:/etc/rabbitmq  --name rabbit2 -e RABBITMQ_ERLANG_COOKIE='ERLANGCOOKIE'  registry.ng.bluemix.net/chrisking/rabbitmq:sd

          ;;
     elasticsearch)
          echo "Start ElasticSearch Cluster"
          ;;
     *)
          echo "Please enter correct service name"
          exit 1
          ;;
  esac


else
    # show help
    help
fi

#!/bin/bash

##############################################################################
##
##  Script to register a docker instance to IBM Bluemix Service Registry
##  Author: gangchen@us.ibm.com
##
##############################################################################
COUNTER=''
SERVICE_DISCOVERY_TOKEN="rl3j00e06ee9e85emtrt3o012cp3ahpm8hqg2qsvku7olpafs78"

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

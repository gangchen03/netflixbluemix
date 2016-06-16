# Deploy Spring Boot Netflix OSS app to IBM Bluemix Container

## Introduction

This project tracks the activities and artifacts of deploying Netflix OSS based microservice solution to IBM Cloud (Bluemix).
It is maintained by IBM Cloud Lab Services and Cloud Solution Engineering team.
The overall project consists of multiple sub projects:

 - Customized Netflix docker image build files
 - Sample Spring Boot applications to access DB2 and other Bluemix services such as RabbitMQ, ElasticSearch
 - Docker compose solution

## Project repositories:

 - https://github.com/ibm-solution-engineering/netflixbluemix _current repo_
 - https://github.com/ibm-solution-engineering/netflixbluemix-core - Contains Eureka, Zuul, and Nginx applications
 - https://github.com/ibm-solution-engineering/netflixbluemix-db2 - Containers DB2-based microservice
 - https://github.com/ibm-solution-engineering/netflixbluemix-mq - Contains RabbitMQ-based microservice
 - https://github.com/ibm-solution-engineering/netflixbluemix-mysql - Contains MySQL-based microservice
 - https://github.com/ibm-solution-engineering/netflixbluemix-elasticsearch - Contains Elasticsearch-based microservice

## Sample Deployed Architecture

![Sample Deployed Architecture for Netflix OSS Components on Bluemix Containers](/netflix-bluemix-phase1-arch-v2.png)

This repository group will deploy the following containers:
- **Eureka**
- **Eureka** failover replica
- **Zuul** internal proxy, linked to _Eureka_
- **Nginx** external proxy, linked to _Zuul_ & _Eureka_
- Sample microservices, linked to _Eureka_:
  - **DB2**
  - **MySQL**
  - **RabbitMQ**
  - **Elasticsearch**

## Setup your local development environment

### Prerequisites

- Install Java JDK 1.8 and ensure it is available in your PATH

### Download source code

- Clone this repository.
     **`git clone https://github.com/ibm-solution-engineering/netflixbluemix.git`**

- Clone the peer repositories.
     **`./clonePeers.sh`**

## Build the Spring Boot apps:
- Build all projects.
  Run the utility script to kick off the build and copy jars to docker folder.  
     **`$ ./buildAll.sh`**    

- Alternatively, you can build individual projects from their own repositories.

  - Build the microservice app to access MySQL service and demonstrate Hystrix circuit breaker:

   	`$ cd microservice`  
   	`$ ./gradlew build`

    To run the app:
   	`$ ./gradlew build && java -jar build/libs/gs-spring-boot-0.1.0.jar`

  - Build the Eureka Server:

   	`$ cd eurekaserver`  
   	`$ ./gradlew build`

   	To run the server:
   	`$ ./gradlew build && java -jar build/libs/eureka-spring-boot-0.1.0.jar`  

  - Build the Zuul Proxy:

   	`$ cd zuulproxy`  
   	`$ ./gradlew build`  

   	To run the Proxy:
   	`$ ./gradlew build && java -jar build/libs/zuul-spring-boot-0.1.0.jar`  

  - Build the microservice app to access DB2 instance on SoftLayer:

   	`$ cd db2microservice`  
   	`$ ./gradlew build`  

   	To run the app:
   	`$ ./gradlew build && java -jar build/libs/gc-spring-boot-db2-0.1.0.jar`  

  - Build the microservice app to access RabbitMQ Bluemix Service:

   	`$ cd mqmicroservice`  
   	`$ ./gradlew build`  

   	To run the app:
   	`$ ./gradlew build && java -jar build/libs/gc-rabbitmq-0.1.0.jar`  

## Deploy to local Docker environment

 Ensure that you have a local Docker environment setup properly. The solution requires **`docker-compose`**.
 The scripts is validated with Docker version **1.10.x**

- Build all projects, as described in the previous section

- Build all docker images  
     `docker-compose build`

- Run the docker containers  
     `docker-compose up`  

- Destroy docker containers  
     `docker-compose down`  

## Deploy to remote Docker environment on IBM Bluemix

### Prerequisites

- Install Docker Compose.
  Due to a number of SSL library version incompatibilities, it is recommended to follow the documented install directions available in the [Bluemix Docs](https://new-console.ng.bluemix.net/docs/containers/container_cli_ov.html#container_cli_compose_install).

- Install [Cloud Foundry Plugin](https://new-console.ng.bluemix.net/docs/cli/index.html#cli)

- Install [IBM Containers plugin](https://new-console.ng.bluemix.net/docs/containers/container_cli_ov.html#container_cli_ov)

### Configure CLI to point to Bluemix

- Log in via the CF command line  
    `cf api https://api.ng.bluemix.net`  
    `cf login`

- Initialize your IBM Containers credentials  
    `cf ic init`

- Copy & paste the `export DOCKER_YYY_ZZZ` commands _(there should be three of them)_ into your command line.  
  For example:  
`export DOCKER_HOST=tcp://containers-api.ng.bluemix.net:[port]`  
`export DOCKER_CERT_PATH=/Users/username/.ice/certs/containers-api.ng.bluemix.net/xxxxxxx-yyyyyy-0000000-11111`  
`export DOCKER_TLS_VERIFY=1`  

- Validate these values are set via the `env | grep DOCKER` command.

- Validate the remote Docker communication.  The `docker images` command should show your available images in the private Docker registry inside your Bluemix organization.

- Ensure that your Bluemix organization's Container quota contains at least 2.5GB of RAM and 1 public IP address.  This can be managed via the [Manage Organizations](https://new-console.ng.bluemix.net/?direct=classic/#/manage/type=org&tabId=users) page of Bluemix.

### Build & deploy your app to Bluemix

Note that specific Docker Compose files must be used in this process to interact with the current Docker Compose support inside the IBM Containers service.  These files point to the same builds, images, etc. but are built using different versions of the Docker Compose file format, as needed.

- Build all projects, as described in the previous *Build* section

- Set your namespace in your local CLI via the following command:
     `export NAMESPACE=$(cf ic namespace get)`

- Build all docker images, using the **bluemix-compose.yml** file.  This is a Version 2-formatted Docker Compose file.  
     `docker-compose -f bluemix-compose.yml build`

- Run the docker containers, using the **bluemix-compose-v1.yml** file.  This is a Version 1-formatted Docker Compose file.  
     `docker-compose -f bluemix-compose-v1.yml up -d`  

- Assign a public IP address to the NGINX container
     - `docker ps | grep nginx` to identify the nginx container ID
     - `cf ic ip request` to request a public IP address
     - `cf ic ip bind [nginx_container_id] [public_ip]` to bind the public IP address to the NGINX container
     - After a few moments, access the application through the *Validate Deployment* section below.

- Destroy docker containers  
     `docker-compose down`  

## Validate deployment
Use the following links to validate a successful solution deployment to local or Bluemix container.

- Access Landing Page:
    [http://nginx_ip/eureka/default.html](http://nginx_ip/eureka/default.html)    
    This is a default landing page with links to all necessary Netflix OSS components, such as Hystrix Dashboard; and each individual microservice endpoint, such as DB2, MySQL, etc.

- Access Eureka Server Console:  
    [http://nginx_ip/eureka/](http://nginx_ip/eureka/)  

- Invoke microservice that queries DB2:  
    [http://nginx_ip/db2-hello-service/app/db2/department](http://nginx_ip/db2-hello-service/app/db2/department)    
    You should see a list of department records returned from DB2, for example:
```
A00-->SPIFFY COMPUTER SERVICE DIV.-->000010
B01-->PLANNING-->000020  
C01-->INFORMATION CENTER-->000030
```

- Invoke microservice that queries MySQL:  
    [http://nginx_ip/hello-service/app/tasklist](http://nginx_ip/hello-service/app/tasklist)    
    You should see a list of tasks returned from MySQL, for example:
```
2-->Build Task, 12-->Task on Bluemix, 22-->due on Friday, 32-->Add the task,
```

- Invoke microservice that sends RabbitMQ message:  
    [http://nginx_ip/mq-hello-service/app/mq/msg/HelloIBM](http://nginx_ip/mq-hello-service/app/mq/msg/HelloIBM)  
  You should see the message in browser: `Msg send to RabbitMQ!`  
  The Docker container log should show: `message received as HelloIBM`  

- Invoke microservice that queries Elasticsearch:  
    [http://nginx_ip/elasticsearch-service/app/es](http://nginx_ip/elasticsearch-service/app/es)    
    You should see a table of information queried from Elasticsearch

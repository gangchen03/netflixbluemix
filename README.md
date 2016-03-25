# Deploy Spring Boot Netflix OSS app to IBM Bluemix Container

## Introduction

This project tracks the activities and artifacts of deploying Netflix OSS based Micro-servcie solution to IBM Cloud (Bluemix).
It is maintained by IBM Cloud Lab Services and Cloud Solution Engineering team.
The overall project consists of multiple sub projects:

 - Customized Netflix docker image build files
 - Sample Spring Boot applications to access DB2 and other Bluemix services such as RabbitMQ, ElasticSearch
 - Docker compose solution

## Project repositories:

 - https://github.com/osowski/netflixbluemix _current repo_
 - https://github.com/osowski/netflixbluemix-core - Contains Eureka, Zuul, and Nginx applications
 - https://github.com/osowski/netflixbluemix-db2 - Containers DB2-based microservice
 - https://github.com/osowski/netflixbluemix-mq - Contains RabbitMQ-based microservice
 - https://github.com/osowski/netflixbluemix-mysql - Contains MySQL-based microservice
 - https://github.com/osowski/netflixbluemix-elasticsearch - Contains Elasticsearch-based microservice

## Setup your local development environment

### Prerequisites

- Install Java JDK 1.8 and ensure it is available in your PATH

### Download source code

- Clone this repository.
     **`git clone https://github.com/osowski/netflixbluemix.git`**

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
     `$ docker-compose build`

- Run the docker containers  
     `$ docker-compose up`  

- Destroy docker containers  
     `$ docker-compose down`  

## Deploy to remote Docker environment on IBM Bluemix

_TBD_

## Validate deployment
Use the following links to validate a successful solution deployment to local or Bluemix container.

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

- Invoke microservice that sends RabbitMQ message:  
    [http://nginx_ip/mq-hello-service/app/mq/msg/HelloIBM](http://nginx_ip/mq-hello-service/app/mq/msg/HelloIBM)  
  You should see the message in browser: `Msg send to RabbitMQ!`  
  The Docker container log should show: `message received as HelloIBM`  
